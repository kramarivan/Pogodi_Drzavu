//
//  WelcomeViewModel.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 14.05.2024..
//

import Foundation
import Combine

class WelcomeViewModel: ObservableObject {
    @Published var isButtonVisible: Bool = false

    init() {
        showButtonWithDelay()
    }
    
    private func showButtonWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isButtonVisible = true
        }
    }
}
