import SwiftUI

struct ExchangeView: View {
    @AppStorage("coinscore") var coinscore: Int = 10
    @AppStorage("eggscore") var eggscore: Int = 10
    @State private var coinsToExchange: Int = 20 // Начальное количество монет для обмена
    @State private var eggsToReceive: Int = 1 // Начальное количество яиц для получения
    @State private var showAlert: Bool = false // Показывать ли alert
    @State private var alertMessage: String = "" // Сообщение для alert

    let exchangeRate = 20 // 20 монет = 1 яйцо

    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
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
                            }
                            Spacer()
                        }

                        VStack {
                            Spacer()
                            Image(.exchangesBtn)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 220, height: 90)
                                .onTapGesture {
                                    performExchange()
                                }
                        }

                        VStack {
                            Image(.exchangeText)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 250)

                            HStack(spacing: 40) {
                                VStack {
                                    Image(.givingText)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 50)

                                    Image(.givingPlate)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 50)
                                        .overlay(
                                            ZStack {
                                                HStack {
                                                    Image(.coinExchange)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 20, height: 20)
                                                    Text("\(coinsToExchange)")
                                                        .foregroundStyle(.white)
                                                        .fontWeight(.bold)
                                                }
                                                HStack(spacing: 90) {
                                                    Image(.minus)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 40, height: 40)
                                                        .onTapGesture {
                                                            decreaseExchange()
                                                        }
                                                    Image(.plus)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 40, height: 40)
                                                        .onTapGesture {
                                                            increaseExchange()
                                                        }
                                                }
                                            }
                                        )
                                }

                                VStack {
                                    Image(.getText)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 50)

                                    Image(.givingPlate)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 50)
                                        .overlay(
                                            HStack {
                                                Image(.goldenEggLeader)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20, height: 20)
                                                Text("\(eggsToReceive)")
                                                    .foregroundStyle(.white)
                                                    .fontWeight(.bold)
                                            }
                                        )
                                }
                            }
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Exchange Result"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: - Exchange Logic

    private func increaseExchange() {
        coinsToExchange += exchangeRate
        eggsToReceive = coinsToExchange / exchangeRate
    }

    private func decreaseExchange() {
        if coinsToExchange > exchangeRate { // Не даем опуститься ниже начального значения
            coinsToExchange -= exchangeRate
            eggsToReceive = coinsToExchange / exchangeRate
        }
    }

    private func performExchange() {
        if coinscore >= coinsToExchange {
            coinscore -= coinsToExchange
            eggscore += eggsToReceive
            alertMessage = "Exchange successful! You spent \(coinsToExchange) coins and received \(eggsToReceive) golden egg(s)."
        } else {
            alertMessage = "Not enough coins! You need \(coinsToExchange) coins, but you have only \(coinscore)."
        }
        showAlert = true
    }
}

#Preview {
    ExchangeView()
}
