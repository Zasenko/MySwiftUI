//
//  SnapCarouselSliderView.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 20.07.23.
//

import SwiftUI

struct SnapCarouselSliderView: View {
    
    @State private var currentIndex: Int = 0
    @State private var posts: [Post] = []
    
    var body: some View {
        VStack {
            VStack {
                SnapCarousel(spacing: 30, trailingSpace: 100, index: $currentIndex, items: posts) { post in
                    GeometryReader { proxy in
                        let size = proxy.size
                        Image(post.postImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: size.width)
                            .cornerRadius(12)
                    }
                }
                .padding(.vertical, 40)
                
                // Indicator
                HStack(spacing: 10) {
                    ForEach(posts.indices, id: \.self) { index in
                        Circle()
                            .fill(Color.black.opacity(currentIndex == index ? 1 : 0.1))
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentIndex == index ? 1.4 : 1)
                            .animation(.spring(), value: currentIndex == index)
                    }
                }
                .padding(.bottom, 100)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.red)
            //.padding()
            .onAppear {
                for index in 1...5 {
                    posts.append(Post(postImage: "poster\(index)"))
                }
            }
        }
       //
    }
}

struct SnapCarouselSliderView_Previews: PreviewProvider {
    static var previews: some View {
        SnapCarouselSliderView()
    }
}

struct Post: Identifiable {
    var id = UUID().uuidString
    var postImage: String
}

struct SnapCarousel <Content: View, T: Identifiable>: View {
    
    var content: (T) -> Content
    var list: [T]
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    init(spacing: CGFloat = 15,
         trailingSpace: CGFloat = 100,
         index: Binding<Int>,
         items: [T],
         @ViewBuilder content: @escaping (T)->Content){
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    //Offset
    @GestureState var offset: CGFloat = 0
    @State private var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            
            //setting correct Width for cnap carousel...
            
            //one sided snap courusel...
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustmentWidrh  = (trailingSpace / 2) - spacing
            HStack(spacing: spacing) {
                ForEach(list) { item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            //spasing will be horizontal padding
            .padding(.horizontal, spacing)
            //setting only after 0th index...
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustmentWidrh : 0) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        //updating currwnt index
                        let offsetX = value.translation.width
                        
                        // were going to convert the tranlsation into progress (0 - 1)
                        // and round the value...
                        // based on the progress increasing or decreasing the currentIndex
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        //setting max...
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        currentIndex = index
                    })
                    .onChanged({ value in
                        //updating only index
                        //updating currwnt index
                        let offsetX = value.translation.width
                        
                        // were going to convert the tranlsation into progress (0 - 1)
                        // and round the value...
                        // based on the progress increasing or decreasing the currentIndex
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        //setting max...
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
            )
        }
        //Animating when offset = 0
        .animation(.easeInOut, value: offset == 0)
        
    }
}
