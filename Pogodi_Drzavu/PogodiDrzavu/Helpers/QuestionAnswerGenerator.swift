//
//  GameLogic.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 29.04.2024..
//

import Foundation

class QuestionAnswerGenerator {
    var countries: [Country]
    var currentQuestion: Country?
    var answers: [String] = []
    var usedCountries: [String] = []
    let continent: String
    var firebaseStorageService = FirebaseStorageService()

    init(countries: [Country], continent: String) {
        self.countries = countries
        self.continent = continent
    }

    func generateNewQuestion() {
            var potentialQuestion: Country?
            repeat {
                potentialQuestion = countries.randomElement()
            } while potentialQuestion != nil 
                    && usedCountries.contains(potentialQuestion!.name)

            if let newQuestion = potentialQuestion {
                currentQuestion = newQuestion
                usedCountries.append(newQuestion.name)
                generateAnswers()
            }
        }

    private func generateAnswers() {
        guard let correctAnswer = currentQuestion else { return
        }
        
        var potentialAnswers = countries.shuffled().prefix(4)
        if !potentialAnswers.contains(where: { $0.name == correctAnswer.name }) {
            potentialAnswers.removeLast()
            potentialAnswers.append(correctAnswer)
        }
        
        answers = potentialAnswers.shuffled().map { $0.name
        }
    }
    
    func fetchCountryNames(completion: @escaping ([String]) -> Void) {
            firebaseStorageService.fetchCountryNames(continent: continent) { result in
                switch result {
                case .success(let countryNames):
                    completion(countryNames)
                case .failure(let error):
                    print("Error fetching country names: \(error)")
                    completion([])
                }
            }
        }
    
    }

