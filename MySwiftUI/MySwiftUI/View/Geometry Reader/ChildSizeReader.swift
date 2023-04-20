//
//  ChildSizeReader.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 20.04.23.
//

import SwiftUI

struct ChildSizeReader: View {
    var body: some View {
        childView
          .readSize { newSize in
            print("4 The new child size is: \(newSize)")
          }
    }
    var childView: some View {
            Text("2 The new child size isThe new child size isThe new child size isThe new child size isThe new child size isThe new child size isThe new child size is The new child size isThe new child size isThe new child size isThe new child size isThe new child size isThe new child size isThe new child size is")
    }
}

struct ChildSizeReader_Previews: PreviewProvider {
    static var previews: some View {
        ChildSizeReader()
    }
}
extension View {
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
