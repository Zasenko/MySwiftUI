//
//  OutlineGroupSimple.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 13.07.23.
//

import SwiftUI

struct OutlineGroupSimple: View {
    
    
    ///вариант 1
    ///
    ///
//    OutlineGroup(data, children: \.children) { item in
//        Text("\(item.description)")
//    }
    
    
    ///вариант 2
    ///
    ///
//    var body: some View {
//        OutlineGroup(categories, id: \.value, children: \.children) { tree in
//            Text(tree.value).font(.subheadline)
//        }
//    }
    
    ///вариант 3
    ///
    ///
//    var body: some View {
//        List(categories, id: \.value, children: \.children) { tree in
//            Text(tree.value).font(.subheadline)
//        }.listStyle(SidebarListStyle())
//    }
    
    ///вариант 4
    ///
    ///
    var body: some View {
        List {
            ForEach(categories, id: \.self) { section in
                Section(header: Text(section.value)) {
                    OutlineGroup(
                        section.children ?? [],
                        id: \.value,
                        children: \.children
                    ) { tree in
                        Text(tree.value)
                            .font(.subheadline)
                    }
                }
            }
        }.listStyle(SidebarListStyle())
    }
    
    ///вариант 5
    ///
    ///
//    @State private var showContent = false
//
//        var body: some View {
//            DisclosureGroup("Message", isExpanded: $showContent) {
//                Text("Hello World!")
//            }
//        }
}

struct OutlineGroup_Previews: PreviewProvider {
    static var previews: some View {
        OutlineGroupSimple()
    }
}

struct Tree<Value: Hashable>: Hashable {
    let value: Value
    var children: [Tree]? = nil
}

let categories: [Tree<String>] = [
    .init(
        value: "Clothing",
        children: [
            .init(value: "Hoodies"),
            .init(value: "Jackets"),
            .init(value: "Joggers"),
            .init(value: "Jumpers"),
            .init(
                value: "Jeans",
                children: [
                    .init(value: "Regular"),
                    .init(value: "Slim")
                ]
            ),
        ]
    ),
    .init(
        value: "Shoes",
        children: [
            .init(value: "Boots"),
            .init(value: "Sliders"),
            .init(value: "Sandals"),
            .init(value: "Trainers"),
        ]
    )
]

struct FileItem: Hashable, Identifiable, CustomStringConvertible {
    var id: Self { self }
    var name: String
    var children: [FileItem]? = nil
    var description: String {
        switch children {
        case nil:
            return "📄 \(name)"
        case .some(let children):
            return children.isEmpty ? "📂 \(name)" : "📁 \(name)"
        }
    }
}

let data =
  FileItem(name: "users", children:
    [FileItem(name: "user1234", children:
      [FileItem(name: "Photos", children:
        [FileItem(name: "photo001.jpg"),
         FileItem(name: "photo002.jpg")]),
       FileItem(name: "Movies", children:
         [FileItem(name: "movie001.mp4")]),
          FileItem(name: "Documents", children: [])
      ]),
     FileItem(name: "newuser", children:
       [FileItem(name: "Documents", children: [])
       ])
    ])


