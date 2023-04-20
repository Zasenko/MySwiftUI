//
//  Multi-line-TextField.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 12.02.23.
//

import SwiftUI

struct MultilineTextField: View {
    @State var text = ""
    @State var email = ""
    
    var body: some View {
        Form {
          Section("Your details") {
            TextField("email", text: $email)
              .textInputAutocapitalization(.never)
              .autocorrectionDisabled(true)
          }
          Section("Feedback") {
              TextField("text", text: $text, axis: .vertical)
                .lineLimit(4)
          }
        }
    }
}

struct MultilineTextField_Previews: PreviewProvider {
    static var previews: some View {
        MultilineTextField()
    }
}
