//
//  SettingsView.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 23.04.2024..
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var playerName: String = ""
    
    var body: some View {
        ZStack{
            Color(red: 202 / 255, green: 203 / 255, blue: 250 / 255).edgesIgnoringSafeArea(.all)
            VStack{
                VStack {
                    Form {
                        Section(header: Text("Postavke Igre").foregroundColor(.black).font(.custom("Space Grotesk", size: 18))){
                            Picker("Vrijeme runde", selection: $viewModel.selectedDurationIndex) {
                                ForEach(0..<viewModel.durations.count, id: \.self) { index in
                                    Text("\(viewModel.durations[index])s")
                                }
                            }.listRowBackground(Color(red: 175 / 255, green: 200 / 255, blue: 198 / 255).overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            ).overlay(
                                RoundedRectangle(cornerRadius: 1)
                                    .stroke(Color.black, lineWidth: 1)
                            ))
                            
                            Picker("Broj rundi", selection: $viewModel.selectedRoundIndex) {
                                ForEach(0..<viewModel.rounds.count, id: \.self) { index in
                                    Text("\(viewModel.rounds[index])")
                                }
                            }.listRowBackground(Color(red: 175 / 255, green: 200 / 255, blue: 198 / 255).overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            ).overlay(
                                RoundedRectangle(cornerRadius: 1)
                                    .stroke(Color.black, lineWidth: 1)
                            ))
                            
                            Picker("Kontinent", selection: $viewModel.selectedContinentIndex) {
                                ForEach(0..<viewModel.continents.count, id: \.self) { index in
                                    Text(viewModel.continents[index])
                                }
                            }.listRowBackground(Color(red: 175 / 255, green: 200 / 255, blue: 198 / 255).overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            ).overlay(
                                RoundedRectangle(cornerRadius: 1)
                                    .stroke(Color.black, lineWidth: 1)
                            ))
                        }
                        
                        Section(header: Text("Dodaj Igrače").foregroundColor(.black).font(.custom("Space Grotesk", size: 18))){
                            HStack{
                                TextField("Unesi ime igrača", text: $playerName).foregroundColor(.black)
                                Button("Dodaj") {
                                    viewModel.addPlayer(name: playerName)
                                    playerName = ""  // Reset after adding
                                }.disabled(viewModel.playerCheck(name: playerName))
                            }
                        }
                        
                        Section(header: HStack{Text("Trenutni igrači").foregroundColor(.black).font(.custom("Space Grotesk", size: 18));Spacer();Text("Pozicija sjedenja").foregroundColor(.black).font(.custom("Space Grotesk", size: 18))}){
                            ForEach(viewModel.players.indices, id: \.self) { index in
                                HStack {
                                    Text(viewModel.players[index].name)
                                    Spacer()
                                    Image(systemName: viewModel.arrowImageName(for: index, totalPlayers: viewModel.players.count))
                                        .foregroundColor(.black) // Set arrow color
                                }
                            }
                            .onDelete(perform: viewModel.removePlayer)
                            .listRowBackground(Color(red: 175 / 255, green: 200 / 255, blue: 198 / 255).overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            ).overlay(
                                RoundedRectangle(cornerRadius: 1)
                                    .stroke(Color.black, lineWidth: 1)
                            ))
                        }
                    }.padding(.horizontal, 70)
                        .padding(.vertical, 30)
                        .scrollContentBackground(.hidden)
                }.frame(height: 600)

                
                Spacer()
                
                NavigationLink(destination: QuizView(viewModel: QuizViewModel(
                    duration: viewModel.durations[viewModel.selectedDurationIndex],
                    continent: viewModel.continents[viewModel.selectedContinentIndex],
                    numberOfRounds: viewModel.rounds[viewModel.selectedRoundIndex],
                    players: viewModel.players))) {
                        Text("START")
                    }
                    .buttonStyle(CustomButtonStyle())
                    .opacity(viewModel.players.count >= 2 ? 1 : 0.3)
                    .disabled(viewModel.players.count < 2)
                    .padding(.bottom, 50)
                
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SettingsView()
}
