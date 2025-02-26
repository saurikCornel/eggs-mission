import SwiftUI

enum LossReason {
    case fire
    case luk
    case none
}

struct MissionGame: View {
    @State private var chickenPosition: CGPoint = CGPoint(x: 2, y: 2)
    @State private var coins: [CGPoint] = []
    @State private var goldenEggs: [CGPoint] = []
    @State private var fires: [CGPoint] = []
    @State private var luks: [CGPoint] = []
    @State private var score = 0
    @State private var timeRemaining = 60
    @State private var isGameActive = true
    @State private var isFlipped: Bool = false
    @State private var gameTimer: Timer?
    @State private var lossReason: LossReason = .none // Новое состояние
    

    
    let gridSize: CGFloat = 5

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if !isLandscape {
                    let availableHeight = geometry.size.height * 0.8
                    let cellSize = 70.0
                    let gridWidth = gridSize * cellSize
                    let gridHeight = gridSize * cellSize

                    ZStack {
                        VStack {
                            HStack {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .padding(.top, 20)
                                    .padding()
                                    .foregroundStyle(.white)
                                    .onTapGesture {
                                        gameTimer?.invalidate()
                                        AvalResult.shared.currentScreen = .MENU
                                    }
                                Spacer()
                                TimeTemplate(time: timeRemaining)
                                    .padding()
                            }
                            Spacer()

                            ZStack {
                                GridView(gridSize: gridSize, cellSize: cellSize, coins: coins, goldenEggs: goldenEggs, fires: fires, luks: luks)
                                Image("chickenFrame")
                                    .resizable()
                                    .frame(width: cellSize * 0.8, height: cellSize * 0.8)
                                    .scaleEffect(x: isFlipped ? -1 : 1, y: 1)
                                    .position(x: (chickenPosition.x + 0.5) * cellSize, y: (chickenPosition.y + 0.5) * cellSize)
                            }
                            .frame(width: gridWidth, height: gridHeight)

                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                            if timeRemaining > 0 && isGameActive {
                                timeRemaining -= 1
                            } else if isGameActive {
                                isGameActive = false
                                lossReason = .none
                                gameTimer?.invalidate()
                            }
                        }
                        spawnObjects()
                    }
                    .gesture(DragGesture().onEnded { gesture in
                        if isGameActive {
                            moveChicken(direction: gesture.translation)
                        }
                    })
                } else {
                    ZStack {
                        Color.black.opacity(0.7)
                            .edgesIgnoringSafeArea(.all)
                        RotateDeviceScreen()
                    }
                }

                // Game over overlay
                if !isGameActive {
                    if coins.isEmpty && goldenEggs.isEmpty {
                        WinViewMission()
                    } else {
                        switch lossReason {
                        case .fire:
                            LoseViewFire()
                        case .luk:
                            LoseViewLuke()
                        case .none:
                            LoseViewFire()
                        }
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

    // MARK: - Game Logic Functions

    private func spawnObjects() {
        coins = randomPositions(count: 5, excluding: [])
        goldenEggs = randomPositions(count: 2, excluding: coins)
        fires = randomPositions(count: 3, excluding: coins + goldenEggs)
        luks = randomPositions(count: 3, excluding: coins + goldenEggs + fires)
    }

    private func randomPositions(count: Int, excluding: [CGPoint]) -> [CGPoint] {
        var positions: [CGPoint] = []
        while positions.count < count {
            let newPos = CGPoint(x: CGFloat(Int.random(in: 0..<Int(gridSize))), y: CGFloat(Int.random(in: 0..<Int(gridSize))))
            if !positions.contains(newPos) && !excluding.contains(newPos) && newPos != chickenPosition {
                positions.append(newPos)
            }
        }
        return positions
    }

    private func moveChicken(direction: CGSize) {
        let newChickenPosition: CGPoint
        if abs(direction.width) > abs(direction.height) {
            newChickenPosition = CGPoint(
                x: chickenPosition.x + (direction.width > 0 ? 1 : -1),
                y: chickenPosition.y
            )
            isFlipped = direction.width < 0
        } else {
            newChickenPosition = CGPoint(
                x: chickenPosition.x,
                y: chickenPosition.y + (direction.height > 0 ? 1 : -1)
            )
        }

        guard isValidPosition(newChickenPosition) else { return }
        chickenPosition = newChickenPosition
        handleCollision(at: chickenPosition)
    }

    private func isValidPosition(_ position: CGPoint) -> Bool {
        return position.x >= 0 && position.x < gridSize &&
               position.y >= 0 && position.y < gridSize
    }

    private func handleCollision(at position: CGPoint) {
        if coins.contains(position) {
            coins.removeAll { $0 == position }
            score += 10
        } else if goldenEggs.contains(position) {
            goldenEggs.removeAll { $0 == position }
            score += 25
        } else if fires.contains(position) {
            lossReason = .fire
            isGameActive = false
        } else if luks.contains(position) {
            lossReason = .luk
            isGameActive = false
        }

        if coins.isEmpty && goldenEggs.isEmpty {
            isGameActive = false
        }
    }
}

// MARK: - GridView Definition

struct GridView: View {
    let gridSize: CGFloat
    let cellSize: CGFloat
    let coins: [CGPoint]
    let goldenEggs: [CGPoint]
    let fires: [CGPoint]
    let luks: [CGPoint]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<Int(gridSize), id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<Int(gridSize), id: \.self) { column in
                        let position = CGPoint(x: CGFloat(column), y: CGFloat(row))
                        let imageName: String

                        if coins.contains(position) {
//                            imageName = "coinCell"
                            Image("coinCell")
                                .resizable()
                                .frame(width: cellSize, height: cellSize)
                        } else if goldenEggs.contains(position) {
//                            imageName = "goldenEggCell"
                            Image("goldenEggCell")
                                .resizable()
                                .frame(width: cellSize, height: cellSize)
                        } else if fires.contains(position) {
//                            imageName = "fireCell"
                            Image("fireCell")
                                .resizable()
                                .frame(width: cellSize, height: cellSize)
                        } else if luks.contains(position) {
//                            imageName = "lukCell"
                            Image("lukCell")
                                .resizable()
                                .frame(width: cellSize, height: cellSize)
                        } else {
//                            imageName = "cell"
                            Image("cell")
                                .resizable()
                                .frame(width: cellSize, height: cellSize)
                        }
//
//                        Image(imageName)
//                            .resizable()
//                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
        }
    }
}


struct WinViewMission: View {
    @AppStorage("eggscore") var eggscore: Int = 10

    var body: some View {
        ZStack {
            Image(.winMission)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    eggscore += 10
                    AvalResult.shared.currentScreen = .MENU
                }
        }
    }
}

struct LoseViewFire: View {
    var body: some View {
        ZStack {
            Image(.loseFire)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    AvalResult.shared.currentScreen = .MENU
                }
        }
    }
}

struct LoseViewLuke: View {
    var body: some View {
        ZStack {
            Image(.loseLuke)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    AvalResult.shared.currentScreen = .MENU
                }
        }
    }
}

#Preview {
    MissionGame()
}
