//
//  CallButton.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 28.12.22.
//

import SwiftUI

struct CallButton: View {
    var phoneNumber = "718-555-5555"
    var body: some View {
        Button {
            let phone = "tel://"
            let phoneNumberformatted = phone + phoneNumber
            guard let url = URL(string: phoneNumberformatted) else { return }
            UIApplication.shared.open(url)
        } label: {
            Text("Call")
                .foregroundColor(.blue)
        }
    }
}

struct CallButton_Previews: PreviewProvider {
    static var previews: some View {
        CallButton()
    }
}
