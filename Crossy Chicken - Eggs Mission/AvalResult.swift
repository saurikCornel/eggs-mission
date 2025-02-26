import Foundation


enum AvailableScreens {
    case MENU
    case LOADING
    case SETTINGS
    case LEADERBOARD
    case EXCHANGE
    case MINIGAMES
    case FIRECARDS
    case FALLCOIN
    case MISSIONGAME
}

class AvalResult: ObservableObject {
    @Published var currentScreen: AvailableScreens = .LOADING
    static var shared: AvalResult = .init()
}
