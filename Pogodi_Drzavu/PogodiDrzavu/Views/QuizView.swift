//
//  QuizScreenView.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 27.04.2024..
//

import SwiftUI

struct QuizView: View {
    @StateObject var viewModel: QuizViewModel
    let playerBackgroundColors: [Color] = [Color(red: 145/255, green: 167/255, blue: 248/255), Color(red: 234/255, green: 181/255, blue: 208/255), Color(red: 246/255, green: 220/255, blue: 182/255), Color(red: 184/255, green: 221/255, blue: 229/255)]
    
    var rotationAngles: [Double] {
        if viewModel.players.count == 2 {
            return [180.0, 0.0]
        } else {
            return [180.0, 180.0, 0.0, 0.0]
        }
    }
    
    var gridColumns: [GridItem] {
        if viewModel.players.count == 2 {
            return [GridItem(.flexible())]
        } else {
            return Array(repeating: GridItem(.flexible()), count: 2)
        }
    }
    
    var body: some View {
                ZStack {
                    if viewModel.showAnswers {
                        playersGrid
                    } else {
                        if let bordersFile = viewModel.currentCountry {
                            MapView(viewModel: MapViewModel(country: bordersFile, continent: viewModel.continent)).rotation3DEffect(.degrees(viewModel.rotateMap ? 180 : 0), axis: (x: 1, y: 0, z: 0))
                                .scaleEffect(viewModel.rotateMap ? CGSize(width: -1, height: 1) : CGSize(width: 1, height: 1))
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)
                .navigationDestination(isPresented: $viewModel.navigateToResults) {
                    ResultsView(viewModel: ResultsViewModel(players: viewModel.players))
                    }
        }
        
    var playersGrid: some View {
        ZStack{
            Color(red: 202 / 255, green: 203 / 255, blue: 250 / 255).edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("Runda \(viewModel.currentRound) od \(viewModel.numberOfRounds)")
                    .font(.custom("PoetsenOne", size: 20))
                Spacer()
                if viewModel.players.count == 3 {
                    VStack(spacing: 90) {
                        HStack(spacing: 40){
                            ForEach(0..<2) { index in
                                answersGrid(playerIndex: index)
                                    .rotationEffect(.degrees(rotationAngles[index % rotationAngles.count]), anchor: .center)
                                    .border(Color.black)
                                    .frame(width: 450)
                                    .background(playerBackgroundColors[index % playerBackgroundColors.count])
                            }
                        }
                        answersGrid(playerIndex: 2)
                            .rotationEffect(.degrees(rotationAngles[2 % rotationAngles.count]), anchor: .center)
                            .border(Color.black)
                            .frame(width: 450)
                            .background(playerBackgroundColors[2 % playerBackgroundColors.count])
                    }
                } else {
                    LazyVGrid(columns: gridColumns, spacing: 90) {
                        ForEach(0..<viewModel.players.count, id: \.self) { index in
                            answersGrid(playerIndex: index)
                                .rotationEffect(.degrees(rotationAngles[index % rotationAngles.count]), anchor: .center)
                                .border(Color.black)
                                .frame(width: 450)
                                .background(playerBackgroundColors[index % playerBackgroundColors.count])
                        }
                    }
                }
                Spacer()
                Text("Runda \(viewModel.currentRound) od \(viewModel.numberOfRounds)")
                    .font(.custom("PoetsenOne", size: 20))
                    .rotationEffect(.degrees(180))
                }
            HStack{
            Text("\(viewModel.timeRemaining)")
                    .font(.title).bold()
                
            Text("|")
            
            Text("\(viewModel.timeRemaining)")
                    .font(.title).bold()
                .rotationEffect(.degrees(180))
            }
        }
    }
    
    
    func answersGrid(playerIndex: Int) -> some View {
        let player = viewModel.players[playerIndex]
        let pointsGained = player.score - viewModel.startOfRoundScores[playerIndex]
        return VStack {
            Spacer()
            HStack{
                Text("     ")
                Text(player.name.capitalized)
                    .font(.custom("PoetsenOne", size: 25))
                Text("+\(pointsGained)").font(.title2).bold().opacity(viewModel.allAnswersSubmitted ? 1 : 0)
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                ForEach(viewModel.questionAnswerGenerator.answers, id: \.self) { answer in
                    Button(action: {
                        viewModel.selectAnswer(for: playerIndex, answer: answer)
                    }) {
                        Text(answer)
                            .padding()
                            .frame(minWidth: 150, maxWidth: 180, maxHeight: 50)
                            .background(determineBackgroundColor(for: answer, in: player))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 5, y: 5)
                            .lineLimit(1) 
                            .minimumScaleFactor(0.6)
                    }

                    .disabled(player.selectedAnswer != nil || viewModel.allAnswersSubmitted)
                    
                }
                
            }

            Group {
                if viewModel.currentRound < viewModel.numberOfRounds {
                    Button(action: {viewModel.markPlayerReady(playerIndex: playerIndex)}) {
                        Image(systemName: "checkmark.circle.fill")
                    }
                } else {
                    Button(action: {viewModel.markPlayerReady(playerIndex: playerIndex)}) {
                        Image(systemName: "checkmark.circle.fill")
                    }
                }
            }
            .font(.largeTitle)
            .disabled(viewModel.allAnswersSubmitted == false || player.playerReady == true)
            .opacity(viewModel.allAnswersSubmitted ? 1 : 0)
            .foregroundColor(player.playerReady ? Color.green : Color.gray)
            .padding(.top, 20)

        }.padding(.horizontal, 30)
            .padding(.vertical, 10)
    }
    
    private func determineBackgroundColor(for answer: String, in player: Player) -> Color {
        if viewModel.allAnswersSubmitted {
            if player.selectedAnswer != nil {
                if answer == player.selectedAnswer {
                    return (player.isAnswerCorrect ?? false) ? Color.green : Color.red
                } else if answer == viewModel.questionAnswerGenerator.currentQuestion?.name {
                    return Color.green
                }
            }
            return Color(red: 175 / 255, green: 200 / 255, blue: 198 / 255)
        } else {
            return (player.selectedAnswer == answer && player.selectedAnswer != nil) ? Color.gray : Color(red: 175 / 255, green: 200 / 255, blue: 198 / 255)
        }
    }
    
}


#Preview {
    QuizView(viewModel: QuizViewModel(duration: 10, continent: "Europa", numberOfRounds: 10, players: [.init(name: "dufeo", score: 0), .init(name: "eefw", score: 0), .init(name: "eefw", score: 0)]))
}
