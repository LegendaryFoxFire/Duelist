//
//  Multiplayer.swift
//  Duelist
//
//  Created by Noah Aguillon on 7/26/25.
//

import UIKit
import MultipeerConnectivity

class Multiplayer: NSObject, ObservableObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    
    private var browser: MCNearbyServiceBrowser?
    
    private let serviceType = "duelist"
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    
    private lazy var session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
    private lazy var advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
    
    var onConnected: (() -> Void)?
    
    @Published var receivedGameState: GameState?
    @Published var isConnected = false
    
    init(role: MultipeerRole) {
        super.init()
        session.delegate = self

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


    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("Peer \(peerID.displayName) changed state to \(state.rawValue)")
        DispatchQueue.main.async {
                self.isConnected = (state == .connected)
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
        print("Found peer: \(peerID.displayName)")
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost peer: \(peerID.displayName)")
    }

    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {}
    
    func send(gameState: GameState) {
        guard !session.connectedPeers.isEmpty,
              let data = try? JSONEncoder().encode(gameState) else { return }
        
        try? session.send(data, toPeers: session.connectedPeers, with: .reliable)
    }
    
    enum MultipeerRole {
        case advertiser
        case browser
    }

    static func assignRole(from id: String) -> MultipeerRole {
        return id.hash % 2 == 0 ? .advertiser : .browser
    }

}

