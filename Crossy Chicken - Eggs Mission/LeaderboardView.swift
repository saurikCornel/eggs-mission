import SwiftUI

struct LeaderboardView: View {
    // Модель для игрока в таблице лидеров
    struct LeaderboardEntry {
        var name: String
        var score: Int
    }

    // Массив лидеров с рандомными именами и очками
    @State private var leaderboard: [LeaderboardEntry] = [
        LeaderboardEntry(name: "Tom DJ", score: Int.random(in: 20...200)),
        LeaderboardEntry(name: "Jon Does", score: Int.random(in: 20...200)),
        LeaderboardEntry(name: "Harry W", score: Int.random(in: 20...200)),
        LeaderboardEntry(name: "Alice R", score: Int.random(in: 20...200)),
        LeaderboardEntry(name: "Anni R", score: Int.random(in: 20...200)),
        LeaderboardEntry(name: "Rouse", score: Int.random(in: 20...200)),
        LeaderboardEntry(name: "Olivia", score: Int.random(in: 20...200)),
        LeaderboardEntry(name: "Alice", score: Int.random(in: 20...200)),
        LeaderboardEntry(name: "Felix", score: Int.random(in: 20...200)),
        LeaderboardEntry(name: "Andrew Tat", score: Int.random(in: 20...200)),
    ]
    
    @AppStorage("eggscore") var eggscore: Int = 10
    
    // Вставляем игрока с его текущими очками
    var currentPlayer: LeaderboardEntry {
        LeaderboardEntry(name: "You", score: eggscore)
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                var isLandscape = geometry.size.width > geometry.size.height
                if !isLandscape {
                    ZStack {
                        
                        VStack {
                            HStack {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding(.top, 20)
                                    .padding()
                                    .foregroundStyle(.white)
                                    .onTapGesture {
                                        AvalResult.shared.currentScreen = .MENU
                                    }
                                Spacer()
                                    .padding()
                            }
                            Spacer()
                        }
                        
                        VStack {

                            // Вставляем текущего игрока в список и сортируем всех игроков
                            let leaderboardWithCurrentPlayer = leaderboard + [currentPlayer]
                            let sortedLeaderboard = leaderboardWithCurrentPlayer.sorted { $0.score > $1.score }

                            // Отображаем лидеров
                            ForEach(sortedLeaderboard.prefix(11), id: \.name) { entry in
                                if entry.name == "You" {
                                    // Выделяем плашку для текущего игрока
                                    LeaderboardRow(entry: entry, isCurrentPlayer: true)
                                } else {
                                    LeaderboardRow(entry: entry, isCurrentPlayer: false)
                                }
                            }
                        }
                    }
                    .background(
                        Image(.backgroundLeader)
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                            .scaleEffect(1.1)
                    )
                    .frame(width: geometry.size.width, height: geometry.size.height)

                } else {
                    ZStack {
                        Color.black.opacity(0.7)
                            .edgesIgnoringSafeArea(.all)
                        
                        RotateDeviceScreen()
                    }
                }
            }
        }
    }
}

// Строка таблицы лидеров
struct LeaderboardRow: View {
    var entry: LeaderboardView.LeaderboardEntry
    var isCurrentPlayer: Bool // Флаг, чтобы выделить текущего игрока

    var body: some View {
        HStack {
            Text(entry.name)
                .font(.system(size: 23))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(20)
                .background(Color.clear)
                .shadow(radius: 5)
            
            Spacer()
            
            HStack(spacing: -10) {
                Image(.goldenEggLeader)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text("\(entry.score)") // Отображаем очки
                    .font(.system(size: 23))
                    .foregroundColor(.yellow)
                    .fontWeight(.bold)
                    .padding(20)
                    .background(Color.clear) // Прозрачный фон
                    .cornerRadius(10)
            }

        }
        .frame(width: 300, height: 30)
        .padding(10)
        .background(isCurrentPlayer ? Color.yellow.opacity(0.2) : Color.clear) // Фон для текущего игрока
        .cornerRadius(10)
    }
}

#Preview {
    LeaderboardView()
}
