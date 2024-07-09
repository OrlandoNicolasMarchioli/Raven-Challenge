//
//  SpinnerView.swift
//  RavenChallenge
//
//  Created by Nico on 09/07/2024.
//

import SwiftUI

struct SpinnerView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
            .scaleEffect(2.0, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SpinnerView()
}
