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
    case login
    case register

    // MARK: - Main Screens
    case dualScreen
    case storePage
    case leaderboard
    case mainMenu

    // MARK: - User Settings
    case settings
    case profile

    // MARK: - Gameplay
    case gameScreen
    case resultsScreen
    case postGameSummary

    // MARK: - Social
    case friendsList
    case otherProfile
    case addFriends
    case searchFriends
    
    @ViewBuilder
    func view(nav: NavigationHandler) -> some View {
        switch self {
        case .title:
            TitleScreen()
        case .login:
            Login()
        case .register:
            Register()
        case .mainMenu:
            Main_V()
        case .dualScreen:
            NavMissing()
        case .storePage:
            Store_V()
        case .leaderboard:
            Leaderboard_V()
        case .settings:
            ProfileSettings_V()
        case .profile:
            Profile_V()
        case .gameScreen:
            NavMissing()
        case .resultsScreen:
            DuelResults_V()
        case .postGameSummary:
            DuelSummary_V()
        case .friendsList:
            FriendsList_V()
        case .searchFriends:
            searchFriends_V()
        case .otherProfile:
            //OtherProfile_V()
            Main_V()
        case .addFriends:
            FriendRequests_V()
        }
    }
}
