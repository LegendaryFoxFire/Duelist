//
//  Multiplayer with Time-Staggered Role Assignment
//

import UIKit
import MultipeerConnectivity

class Multiplayer: NSObject, ObservableObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    
    private var browser: MCNearbyServiceBrowser?
    
    private let serviceType = "duelist"
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    
    lazy var session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
    private lazy var advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
    
    var onConnected: (() -> Void)?
    
    @Published var receivedGameState: GameState?
    @Published var isConnected = false
    @Published var connectedPeerName: String? = nil
    @Published var currentRole: MultipeerRole?
    
    private var staggerTimer: Timer?
    private let userID: String
    
    
    init(userID: String, useTimeStagger: Bool = true) {
        self.userID = userID
        super.init()
        session.delegate = self
        
        if useTimeStagger {
            startTimeStaggeredConnection()
        } else {
            let role = Self.assignRoleWithoutOpponent(userID: userID)
            startWithRole(role)
        }
    }
    
    init(role: MultipeerRole) {
        self.userID = UIDevice.current.name
        super.init()
        session.delegate = self
        self.currentRole = role
        startWithRole(role)
    }
    
    
    private func startTimeStaggeredConnection() {        
        currentRole = .advertiser
        startWithRole(.advertiser)
        
        let delaySeconds = calculateStaggerDelay(for: userID)
        
        staggerTimer = Timer.scheduledTimer(withTimeInterval: delaySeconds, repeats: false) { [weak self] _ in
            self?.performStaggeredSwitch()
        }
    }
    
    private func calculateStaggerDelay(for userID: String) -> TimeInterval {
        let hash = abs(userID.hashValue)
        let delaySeconds = 2.0 + Double(hash % 6)
        return delaySeconds
    }
    
    private func performStaggeredSwitch() {
        guard !isConnected else {
            return
        }
                
        stopCurrentRole()
        
        currentRole = .browser
        startWithRole(.browser)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            self?.finalFallback()
        }
    }
    
    private func finalFallback() {
        guard !isConnected else { return }
        stopCurrentRole()
        currentRole = .advertiser
        startWithRole(.advertiser)
    }
        
    private func startWithRole(_ role: MultipeerRole) {
        currentRole = role
        
        switch role {
        case .advertiser:
            advertiser.delegate = self
            advertiser.startAdvertisingPeer()
        case .browser:
            browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
            browser?.delegate = self
            browser?.startBrowsingForPeers()
        }
    }
    
    private func stopCurrentRole() {
        advertiser.stopAdvertisingPeer()
        browser?.stopBrowsingForPeers()
        browser = nil
        staggerTimer?.invalidate()
        staggerTimer = nil
    }
        
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            if state == .connected {
                self.isConnected = true
                self.connectedPeerName = peerID.displayName
                self.stopCurrentRole()
            } else if state == .notConnected {
                self.isConnected = false
                self.connectedPeerName = nil
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let gameState = try? JSONDecoder().decode(GameState.self, from: data) {
            DispatchQueue.main.async {
                self.receivedGameState = gameState
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {}
        
    func send(gameState: GameState) {
        guard !session.connectedPeers.isEmpty,
              let data = try? JSONEncoder().encode(gameState) else {
            return
        }
        
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Error sending game state: \(error)")
        }
    }
    
    func getOpponentName() -> String? {
        return connectedPeerName
    }
    
    func disconnect() {
        stopCurrentRole()
        session.disconnect()
        isConnected = false
        connectedPeerName = nil
    }
        
    enum MultipeerRole {
        case advertiser
        case browser
    }
    
    static func assignRoleWithoutOpponent(userID: String) -> MultipeerRole {
        let deviceName = UIDevice.current.name
        let combinedString = "\(userID)-\(deviceName)"
        
        var hasher = Hasher()
        hasher.combine(combinedString)
        hasher.combine(Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 100))
        
        let hash = hasher.finalize()
        return abs(hash) % 2 == 0 ? .advertiser : .browser
    }
}
