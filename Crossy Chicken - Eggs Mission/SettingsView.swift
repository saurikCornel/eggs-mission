import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var settings = CheckingSound()
    

    
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
                        
                        VStack {
                            Spacer()
                            
                            Image(.rateUsBtn)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 250, height: 80)
                                .onTapGesture {
                                    requestAppReview()
                                }
                        }
                        
                        
                        VStack(spacing: 10) {
                                if settings.musicEnabled {
                                    Image(.soundOn)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 220, height: 130)
                                        .onTapGesture {
                                            settings.musicEnabled.toggle()
                                        }
                                } else {
                                    Image(.soundOff)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 220, height: 130)
                                        .onTapGesture {
                                            settings.musicEnabled.toggle()
                                        }
                                }
                        }
                        .padding(.top, 90)
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
                Image(.backgroundSettings)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
}

// Расширение для работы с App Store
extension SettingsView {
    // Метод для запроса отзыва через StoreKit
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // Попробуем показать диалог с отзывом через StoreKit
            SKStoreReviewController.requestReview(in: scene)
        } else {
            print("Не удалось получить активную сцену для запроса отзыва.")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SoundManager.shared)
}
