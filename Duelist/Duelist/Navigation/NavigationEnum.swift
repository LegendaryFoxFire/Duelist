//
//  NavigationEnum.swift
//  Duelist
//
//  Created by John Bukoski on 7/19/25.
//
import SwiftUI

/// Represents all possible navigation destinations in the Duelist app.
enum NavigationPage {
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
    case otherProfile(friend: Friend)
    case leaderboardProfile(friend: Friend)

    // MARK: - Gameplay
    case gameScreen
    case resultsScreen
    case postGameSummary

    // MARK: - Social
    case friendsList
    case viewFriendRequests
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
            NavMissing()
        case .storePage:
            Store_V()
        case .leaderboard:
            Leaderboard_V()
        case .leaderboardProfile(friend: let friend):
            LeaderboardProfile(friend: friend)
        case .settings:
            ProfileSettings_V()
        case .profile:
            Profile_V()
        case .otherProfile(let friend):
            OtherProfile_V(friend: friend)
        case .gameScreen:
            NavMissing()
        case .resultsScreen:
            DuelResults_V()
        case .postGameSummary:
            DuelSummary_V()
        case .friendsList:
            FriendsList_V()
        case .viewFriendRequests:
            FriendRequests_V()
        case .sendFriendRequests:
            SendFriendRequests_V()
        case .gameScreen:
            Gameplay_V()
        }
    }
}
