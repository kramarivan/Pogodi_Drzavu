//
//  CustomButtonStyle.swift
//  PogodiDrzavu
//
//  Created by Ivan Kramar on 24.04.2024..
//

import Foundation
import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.semibold)
            .frame(maxWidth: 200)
            .padding()
            .foregroundColor(.black)
            .background(Color(red: 175 / 255, green: 200 / 255, blue: 198 / 255))
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}
