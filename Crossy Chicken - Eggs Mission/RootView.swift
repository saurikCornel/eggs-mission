import Foundation
import SwiftUI


struct RootView: View {
    @ObservedObject var nav: AvalResult = AvalResult.shared
    var body: some View {
        switch nav.currentScreen {
                                        
        case .MENU:
            MenuView()
        case .LOADING:
            LoadingScreen()
        case .SETTINGS:
            SettingsView()
        case .LEADERBOARD:
            LeaderboardView()
        case .EXCHANGE:
            ExchangeView()
        case .MINIGAMES:
            MiniGames()
            
        case .FIRECARDS:
            FireCards()
        case .FALLCOIN:
            FallingCoins()
        case .MISSIONGAME:
            MissionGame()
        }

    }
}
