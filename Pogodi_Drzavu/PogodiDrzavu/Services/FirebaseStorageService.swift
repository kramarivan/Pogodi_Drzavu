//
//  FirebaseStorageService.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 22.06.2024..
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

class FirebaseStorageService {
    private let storage = Storage.storage()
    private let db = Firestore.firestore()
    
    // Funkcija za preuzimanje imena država iz .json datoteka sa Firebase-a
    func fetchCountryNames(continent: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let countriesRef = storage.reference(withPath: continent)
        
        countriesRef.listAll { result, error in
            if let error = error {
                completion(.failure(error))
            } else if let result = result {
                let countryNames = result.items.map { $0.name.replacingOccurrences(of: ".json", with: "") }
                completion(.success(countryNames))
            } else {
                completion(.failure(NSError(domain: "FirebaseStorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found"])))
            }
        }
    }

    // Funkcija za preuzimanje granica država iz .json datoteka sa Firebase-a
    func fetchGeoJsonData(continent: String, country: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let jsonRef = storage.reference(withPath: "\(continent)/\(country).json")
        
        jsonRef.getData(maxSize: 10 * 1024 * 1024) { 
            data, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NSError(domain: "FirebaseStorageService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found"])))
            }
        }
    }

    // Funkcija za slanje rezultata na Firebase
    func saveResults(players: [Player], completion: @escaping (Result<Void, Error>) -> Void) {
        let resultsData = players.map { player in
            return ["name": player.name, "score": player.score]
        }
        
        db.collection("quizResults").addDocument(data: ["results": resultsData, "timestamp": Timestamp()]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
