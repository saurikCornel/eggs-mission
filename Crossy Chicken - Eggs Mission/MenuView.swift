import SwiftUI

struct MenuView: View {

    var body: some View {
        GeometryReader { geometry in
            var isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                if !isLandscape {
                    ZStack {
                        VStack {
                            HStack {
                                BalanceTemplate()
                                    .padding()
                                EggTemplate()
                                    .padding()
                            }
                            Spacer()
                        }
                        
                        
                        VStack {
                            Spacer()
                            HStack {
                                ButtonTemplateSquare(image: "settingsBtn", action: {AvalResult.shared.currentScreen = .SETTINGS})
                                
                                ButtonTemplateSquare(image: "leaderboardBtn", action: {AvalResult.shared.currentScreen = .LEADERBOARD})
                            }
                        }
                        
                        VStack(spacing: 20) {
                            
                            ButtonTemplateBig(image: "startBtn", action: {AvalResult.shared.currentScreen = .MISSIONGAME})
                            
                            ButtonTemplateBig(image: "miniBtn", action: {AvalResult.shared.currentScreen = .MINIGAMES})
                            
                            ButtonTemplateBig(image: "exchangeBtn", action: {AvalResult.shared.currentScreen = .EXCHANGE})
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

struct ButtonTemplateSmall: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 80)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding(10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}

struct ButtonTemplateBig: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 100)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}

struct ButtonTemplateSquare: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}

struct BalanceTemplate: View {
    @AppStorage("coinscore") var coinscore: Int = 10
    var body: some View {
        ZStack {
            Image(.coinTemplate)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                            Text("\(coinscore)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 85, y: 35)
                        
                    }
                )
        }
    }
}

struct EggTemplate: View {
    @AppStorage("eggscore") var eggscore: Int = 10
    var body: some View {
        ZStack {
            Image(.eggTemplate)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                            Text("\(eggscore)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 85, y: 35)
                        
                    }
                )
        }
    }
}

struct ButtonTemplateMiddle: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding(10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}

#Preview {
    MenuView()
}
