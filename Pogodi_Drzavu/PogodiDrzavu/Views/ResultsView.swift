//
//  ResultsView.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 27.04.2024..
//

import SwiftUI

struct ResultsView: View {

    @StateObject var viewModel: ResultsViewModel
    
    var body: some View {
            ZStack {
                Color(red: 202 / 255, green: 203 / 255, blue: 250 / 255).edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    List(viewModel.players) { player in
                        HStack {
                            Text(player.name)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(player.score)")
                        }
                        .listRowBackground(Color(red: 175 / 255, green: 200 / 255, blue: 198 / 255).overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        ).overlay(
                            RoundedRectangle(cornerRadius: 1)
                                .stroke(Color.black, lineWidth: 1)
                        ))

                    }
                    .frame(maxHeight: 300)
                    .padding(.horizontal, 70)
                    .scrollContentBackground(.hidden)
                    .rotationEffect(.degrees(180))
                    HStack{
                        Text("REZULTATI")
                        Text("  |  ")
                        Text("REZULTATI").rotationEffect(.degrees(180))
                    }.font(.custom("Space Grotesk", size: 42))
                    List(viewModel.players) { player in
                        HStack {
                            Text(player.name)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(player.score)")
                        }
                        .listRowBackground(Color(red: 175 / 255, green: 200 / 255, blue: 198 / 255).overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        ).overlay(
                            RoundedRectangle(cornerRadius: 1)
                                .stroke(Color.black, lineWidth: 1)
                        ))

                    }
                    .frame(maxHeight: 300)
                    .padding(.horizontal, 70)
                    .scrollContentBackground(.hidden)
                    
                    Spacer()
                    
                    NavigationLink(destination: WelcomeView()) {
                        Text("POČETAK")
                    }
                    .buttonStyle(CustomButtonStyle())
                    .padding(.bottom, 50)
                }
                .navigationBarBackButtonHidden(true)
            }
            .onAppear {
                viewModel.saveResults()
                    }
        }
    }


#Preview {
    ResultsView(viewModel: ResultsViewModel(players: [
        Player(name: "dueo", score: 2),
        Player(name: "ew", score: 5),
        Player(name: "dudeo", score: 7),
        Player(name: "eww", score: 0)
    ]))
}
