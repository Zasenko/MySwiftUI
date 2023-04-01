//
//  HideWhenScrolling.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 01.04.23.
//

import SwiftUI

struct HideWhenScrolling: View {
    var body: some View {
        NavigationView {
            List(0...100, id: \.self) { i in
                Text("Item \(i)")
            }
            .background(NavigationConfigurator { navigationConfigurator in
                navigationConfigurator.hidesBarsOnSwipe = true     // << here !!
                navigationConfigurator.hidesBottomBarWhenPushed = true
                
                navigationConfigurator.isToolbarHidden = false
                navigationConfigurator.toolbar.backgroundColor = .orange
                
                navigationConfigurator.hidesBarsWhenKeyboardAppears = true
                navigationConfigurator.hidesBarsWhenVerticallyCompact = true
            })
            .navigationBarTitle(Text("Person"), displayMode: .inline)
        }
    }
}

struct HideWhenScrolling_Previews: PreviewProvider {
    static var previews: some View {
        HideWhenScrolling()
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            if let navigationController = controller.navigationController {
                self.configure(navigationController)
                print("Successfully obtained navigation controller")
            } else {
                print("Failed to obtain navigation controller")
            }
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController,
                                context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
    }
}

