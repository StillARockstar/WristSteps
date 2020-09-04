//
//  SetColorView.swift
//  WristSteps WatchKit Extension
//
//  Created by Michael Schoder on 03.09.20.
//

import SwiftUI

struct SetColorView: View {
    let data = ["1", "2", "3", "4", "5", "6"]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack {
            Text("App Color".uppercased())
                .foregroundColor(.appTint)
            Text("App & Complication color")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            Spacer()

            LazyVGrid(columns: columns, spacing: 5){
                ForEach(data, id: \.self) { item in
                    Button(
                        action: { },
                        label: { Image(systemName: "checkmark.circle.fill") }
                    )
                        .padding()
                        .font(.title)
                        .foregroundColor(.blue)
                        .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct SetColorView_Previews: PreviewProvider {
    static var previews: some View {
        SetColorView()
    }
}
