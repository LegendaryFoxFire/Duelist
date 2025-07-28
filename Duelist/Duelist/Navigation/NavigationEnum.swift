//
//  NavigationEnum.swift
//  Duelist
//
//  Created by John Bukoski on 7/19/25.
//
import SwiftUI

/// Represents all possible navigation destinations in the Duelist app.
indirect enum NavigationPage {
    // MARK: - Authentication
    case title
    case login(email: String, password: String)
    case register(email: String, password: String)

    // MARK: - Main Screens
    case dualScreen
    case storePage
    case leaderboard
    case mainMenu

    // MARK: - User Settings
    case settings
    case profile
    case otherProfile(user: User, source: NavigationPage)

    // MARK: - Gameplay
    case gameScreen
    case resultsScreen
    case postGameSummary

    // MARK: - Social
    case friendsList
    case friendRequests
    case sendFriendRequests
    
    @ViewBuilder
    func view(nav: NavigationHandler) -> some View {
        switch self {
        case .title:
            Title_Screen()
        case .login(email: let email, password: let password):
            Login(email: email, password: password)
        case .register(email: let email, password: let password):
            Register(email: email, password: password)
        case .mainMenu:
            Main_V()
        case .dualScreen:
            Loading_V()
        case .storePage:
            Store_V()
        case .leaderboard:
            Leaderboard_V()
        case .settings:
            ProfileSettings_V()
        case .profile:
            Profile_V()
        case .otherProfile(let user, let source):
            OtherProfile_V(user: user, sourceDestination: source)
        case .gameScreen:
            NavMissing()
        case .resultsScreen:
            DuelResults_V(winnerName: "REPLACE WINNERNAME IN NAV ENUM")
        case .postGameSummary:
            DuelSummary_V()
        case .friendsList:
            FriendsList_V()
        case .friendRequests:
            FriendRequests_V()
        case .sendFriendRequests:
            SendFriendRequests_V()
        }
    }
}
