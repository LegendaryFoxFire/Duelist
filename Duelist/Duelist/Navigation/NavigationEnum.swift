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

    // MARK: - User Settings
    case settings
    case profile

    // MARK: - Gameplay
    case gameScreen
    case postGame

    // MARK: - Social
    case friendsList
    case otherProfile
    case addFriends
    
    @ViewBuilder
    func view(nav: NavigationHandler) -> some View {
        switch self {
        case .title:
            TitleScreen()
        case .login:
            Login()
        case .register:
            Register()
        case .dualScreen:
            NavMissing()
        case .storePage:
            NavMissing()
        case .leaderboard:
            NavMissing()
        case .settings:
            NavMissing()
        case .profile:
            NavMissing()
        case .gameScreen:
            NavMissing()
        case .postGame:
            NavMissing()
        case .friendsList:
            NavMissing()
        case .otherProfile:
            NavMissing()
        case .addFriends:
            NavMissing()
        }
    }
}
