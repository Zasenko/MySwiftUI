//
//  BaseColors.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 04.04.23.
//

import SwiftUI

struct BaseColors: View {

    let colors: [Color] = appColors
        
        var body: some View {
            ScrollView {

                ForEach(colors, id: \.self) { color in
                    Text("\(color.description)")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                                .padding()
                                .frame(width: 300, height: 100)
                                .background(color)
                                .cornerRadius(8)
                  
                    }
                }
                .padding()

        }

}

struct BaseColors_Previews: PreviewProvider {
    static var previews: some View {
        BaseColors()
    }
}

let appColors: [Color] = [
    
    Color(.red),
    Color(.systemRed),
    Color(.systemPink),

    
    Color(.orange),
    Color(.systemOrange),
    
    Color(.yellow),
    Color(.systemYellow),
    
    Color(.green),
    Color(.systemGreen),
    
    Color(.blue),
    Color(.systemBlue),
    Color(.link),
    Color(.tintColor),
    

    Color(.cyan),
    Color(.systemCyan),
    
    Color(.systemIndigo),
    Color(.systemTeal),
    Color(.systemMint),
    
    Color(.magenta),
    Color(.purple),
    
    Color(.systemPurple),
    
    Color(.black),
    Color(.gray),
    

    Color(.brown),
    Color(.systemBrown),
    
    
    Color(.darkGray),
    Color(.darkText),
    Color(.label),
    Color(.lightGray),
    
    
    Color(.opaqueSeparator),
    
    Color(.placeholderText),
    
    Color(.quaternaryLabel),
    Color(.quaternarySystemFill),
    
    Color(.secondaryLabel),
    Color(.secondarySystemBackground),
    Color(.secondarySystemFill),
    Color(.secondarySystemGroupedBackground),
    Color(.separator),
    Color(.systemBackground),
    
    Color(.systemFill),
    Color(.systemGray),
    Color(.systemGray2),
    Color(.systemGray3),
    Color(.systemGray4),
    Color(.systemGray5),
    Color(.systemGray6),
    Color(.systemGroupedBackground),
    
    

    
    Color(.tertiaryLabel),
    Color(.tertiarySystemBackground),
    Color(.tertiarySystemFill),
    Color(.tertiarySystemGroupedBackground),
    

]
