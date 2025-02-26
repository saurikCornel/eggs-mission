import SwiftUI

struct MiniGames: View {
    @AppStorage("score") var savedCoins: Int = 1
    @State private var isModalPresented = false

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
                                    .frame(width: 50, height: 50)
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
                            Image(.miniGamesText)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 100)
                            
                            
                            ButtonTemplateBig(image: "fallingCoinsBtn", action: {AvalResult.shared.currentScreen = .FALLCOIN})
                            
                            ButtonTemplateBig(image: "fireCardsBtn", action: {AvalResult.shared.currentScreen = .FIRECARDS})
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
    MiniGames()
}
