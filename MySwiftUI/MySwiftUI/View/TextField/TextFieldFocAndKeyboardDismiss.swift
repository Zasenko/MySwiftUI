//
//  TextFieldFocAndKeyboardDismiss.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 27.03.23.
//

import SwiftUI

struct TextFieldFocAndKeyboardDismiss: View {
    enum Field: Hashable {
        case email
        case text
      }
      
      @FocusState private var focus: Field?
      @State private var email = ""
      @State private var text = ""

      var body: some View {
        Form {
          Section("Your details") {
            TextField("email", text: $email)
              .focused($focus, equals: .email)
          }
          Section("Feedback") {
            TextEditor(text: $text)
                  .focused($focus, equals: .text)
          }
        }
        .onTapGesture {
          focus = nil
        }
        .onSubmit {
            if focus == .email {
                focus = .text
            }// else if checkoutInFocus == .address {
//              checkoutInFocus = .phone
//            } else if checkoutInFocus == .phone {
//              checkoutInFocus = nil
//            }
        }

      }
}

struct TextFieldFocAndKeyboardDismiss_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldFocAndKeyboardDismiss()
    }
}
