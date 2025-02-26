import SwiftUI

struct FireCards: View {
    @State private var cards: [Card] = []
    @State private var selectedCards: [Int] = []
    @State private var matchedSets = 0 // Changed from matchedPairs to matchedSets
    @State private var mistakes = 0
    @State private var isGameOver = false
    @State private var timeRemaining = 30
    @State private var timer: Timer? = nil
    
    init() {
        let baseCards = ["card1", "card2", "card3"]
        // Create three copies of each card instead of two
        let shuffledCards = (baseCards + baseCards + baseCards).shuffled().map { Card(imageName: $0) }
        _cards = State(initialValue: shuffledCards)
    }
    
    private func startTimer() {
        timer?.invalidate()
        timeRemaining = 30
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                if matchedSets < cards.count / 3 { // Changed from count/2 to count/3
                    isGameOver = true
                }
            }
        }
    }
    
    func flipCard(at index: Int) {
        guard !cards[index].isFlipped, selectedCards.count < 3 else { return } // Changed from 2 to 3
        
        cards[index].isFlipped.toggle()
        selectedCards.append(index)
        
        if selectedCards.count == 3 { // Changed from 2 to 3
            checkForMatch()
        }
    }
    
    func checkForMatch() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Check if all three selected cards match
            if cards[selectedCards[0]].imageName == cards[selectedCards[1]].imageName &&
               cards[selectedCards[1]].imageName == cards[selectedCards[2]].imageName {
                cards[selectedCards[0]].isMatched = true
                cards[selectedCards[1]].isMatched = true
                cards[selectedCards[2]].isMatched = true
                matchedSets += 1
                
                if matchedSets == cards.count / 3 { // Changed from count/2 to count/3
                    isGameOver = true
                    timer?.invalidate()
                }
            } else {
                cards[selectedCards[0]].isFlipped = false
                cards[selectedCards[1]].isFlipped = false
                cards[selectedCards[2]].isFlipped = false
                mistakes += 1
                
                if mistakes >= 9 {
                    isGameOver = true
                    timer?.invalidate()
                }
            }
            selectedCards.removeAll()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            
            ZStack {
                if !isLandscape {
                    if isGameOver {
                        if matchedSets == cards.count / 3 { // Changed from count/2 to count/3
                            WinView()
                                .transition(.opacity)
                                .edgesIgnoringSafeArea(.all)
                                .padding()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        } else {
                            LoseView()
                                .transition(.opacity)
                                .edgesIgnoringSafeArea(.all)
                                .padding()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                    } else {
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
                                        timer?.invalidate()
                                        AvalResult.shared.currentScreen = .MENU
                                    }
                                Spacer()
                                TimeTemplate(time: timeRemaining)
                                    .padding()
                            }
                            Spacer()
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 5) {
                                ForEach(cards.indices, id: \.self) { index in
                                    CardView(card: cards[index])
                                        .onTapGesture {
                                            flipCard(at: index)
                                        }
                                }
                            }
                            .padding()
                            Spacer()
                        }
                    }
                    
                } else {
                    Color.black.opacity(0.7)
                        .edgesIgnoringSafeArea(.all)
                    RotateDeviceScreen()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundMenu)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
            .onAppear {
                startTimer()
            }
        }
    }
}

// The other structs remain unchanged
struct Card: Identifiable {
    let id = UUID()
    let imageName: String
    var isFlipped = false
    var isMatched = false
}

struct CardView: View {
    let card: Card
    
    var body: some View {
        Image(card.isFlipped || card.isMatched ? card.imageName : "closeCard")
            .resizable()
            .scaledToFit()
            .frame(width: 180, height: 150)
            .cornerRadius(10)
    }
}

struct TimeTemplate: View {
    var time: Int
    var body: some View {
        ZStack {
            Image(.timerPlate)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                        Text("\(time)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 85, y: 35)
                    }
                )
        }
    }
}

struct WinView: View {
    @AppStorage("coinscore") var coinscore: Int = 10

    var body: some View {
        ZStack {
            Image(.winView)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    coinscore += 20
                    AvalResult.shared.currentScreen = .MENU
                }
        }
    }
}

struct LoseView: View {
    @AppStorage("currentLevel") var currentLevel = 1
    var body: some View {
        ZStack {
            Image(.loseView)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    currentLevel = 1
                    AvalResult.shared.currentScreen = .MENU
                }
        }
    }
}

#Preview {
    FireCards()
}
