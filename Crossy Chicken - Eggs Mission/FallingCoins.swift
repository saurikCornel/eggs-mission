import SwiftUI

struct FallingItem: Identifiable {
    let id = UUID()
    let type: String // "item1", "item2" или "goldenEgg"
    var position: CGPoint // Текущая позиция предмета
}

import SwiftUI

struct FallingCoins: View {
    @State private var gameOver = false // Состояние завершения игры

    var body: some View {
        GeometryReader { geometry in
            var isLandscape = geometry.size.width > geometry.size.height
            ZStack {
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
                        
                        
                        if gameOver {
                            LoseView() // Переход на LoseView при окончании игры
                        } else {
                            GameView(gameOver: $gameOver) // Игровой экран
                        }
                    }
                } else {
                    ZStack {
                        Color.black.opacity(0.7)
                            .edgesIgnoringSafeArea(.all)
                        RotateDeviceScreen()
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image("backgroundMenu")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
}

#Preview {
    FallingCoins()
}

struct GameView: View {
    @Binding var gameOver: Bool
    
    @State private var fallingItems: [FallingItem] = []
    @State private var chickenPosition: CGPoint = .zero
    @State private var score: Int = 0
    @State private var timeSinceLastItem: Double = 0
    @State private var nextItemInterval: Double = Double.random(in: 3...6)
    @State private var screenSize: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            ZStack {
                // Отображение очков
                
                VStack {
                    Image(.coinTemplate)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .overlay(
                            ZStack {
                                Text("\(score)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .position(x: 50, y: 40)
                            }
                        )
                        .padding(.top, 13)
                    Spacer()
                }
                
                
                
                // Падающие предметы
                ForEach(fallingItems) { item in
                    Image(item.type)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .position(item.position)
                }
                
                // Курица
                Image("chicken")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .position(chickenPosition)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newX = value.location.x
                                let minX = 25.0
                                let maxX = screenWidth - 25.0
                                chickenPosition.x = min(max(newX, minX), maxX)
                            }
                    )
            }
            .onAppear {
                screenSize = geometry.size
                
                // Запускаем фоновый таймер через Task
                Task {
                    while !gameOver {
                        try await Task.sleep(nanoseconds: 16_666_666) // 0.1 секунды
                        
                        // Обновляем позиции предметов
                        updateFallingItems(screenHeight: screenHeight)
                        
                        // Проверяем столкновения
                        checkCollisions(screenWidth: screenWidth, screenHeight: screenHeight)
                        
                        // Добавляем новые предметы
                        addNewItemsIfNeeded(screenWidth: screenWidth)
                    }
                }
            }
            .onChange(of: screenSize) { newSize in
                if chickenPosition == .zero {
                    chickenPosition = CGPoint(x: newSize.width / 2, y: newSize.height - 25)
                }
            }
        }
    }
    
    private func updateFallingItems(screenHeight: CGFloat) {
        for i in fallingItems.indices {
            fallingItems[i].position.y += 10 // Скорость падения
        }
        
        // Удаляем предметы, упавшие за пределы экрана
        fallingItems.removeAll { $0.position.y > screenHeight + 50 }
    }
    
    private func checkCollisions(screenWidth: CGFloat, screenHeight: CGFloat) {
        for item in fallingItems {
            let distance = hypot(item.position.x - chickenPosition.x, item.position.y - chickenPosition.y)
            if distance < 50 { // Порог столкновения
                if item.type == "goldenEgg" {
                    score += 1
                    fallingItems.removeAll { $0.id == item.id }
                } else {
                    gameOver = true
                }
            }
        }
    }
    
    private func addNewItemsIfNeeded(screenWidth: CGFloat) {
        timeSinceLastItem += 0.1
        if timeSinceLastItem >= nextItemInterval {
            let types = ["item1", "item2", "goldenEgg"]
            let newItem = FallingItem(
                type: types.randomElement()!,
                position: CGPoint(x: Double.random(in: 0...screenWidth), y: 0)
            )
            fallingItems.append(newItem)
            timeSinceLastItem = 0
            nextItemInterval = Double.random(in: 3...6)
        }
    }
}
