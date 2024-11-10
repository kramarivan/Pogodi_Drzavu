//
//  WelcomeScreenView.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 23.04.2024..
//

import SwiftUI

struct WelcomeView: View {
    
    @StateObject var viewModel = WelcomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 202 / 255, green: 203 / 255, blue: 250 / 255).edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Image("Welcome").scaledToFit()
                    Spacer()
                    
                    NavigationLink(destination: SettingsView()) {
                        Text("POKRENI IGRU")
                    }
                    .buttonStyle(CustomButtonStyle())
                    .padding(.bottom, 50)
                    .opacity(viewModel.isButtonVisible ? 1 : 0)
                }
                
            }.navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    WelcomeView()
}
