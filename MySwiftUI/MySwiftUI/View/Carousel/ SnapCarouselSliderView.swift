//
//  SnapCarouselSliderView.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 20.07.23.
//

import SwiftUI

// Post Model And Sample Data...
struct Post: Identifiable{
    var id = UUID().uuidString
    var postImage: String
}

struct SnapCarouselHome: View {
    
    @State private var currentIndex: Int = 0
    @State private var posts: [Post] = [Post(postImage: "1"), Post(postImage: "2"), Post(postImage: "3"), Post(postImage: "4")]
    
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0) {
            SnapCarousel(spacing: 25, trailingSpace: 100, index: $currentIndex, items: $posts) { post in
                GeometryReader { proxy in
                    let size =  proxy.size
                    Image(post.postImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: size.width)
                        .clipShape(Rectangle())
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 500, alignment: .top)
            // Indicator..
            HStack(spacing: 10) {
                ForEach (posts.indices, id: \.self) { index in
                    Circle()
                        .fill(Color.black.opacity(currentIndex == index ? 1: 0.1))
                        .frame(width: 10, height: 10)
                        .scaleEffect(currentIndex == index ? 1.4 : 1)
                        .animation(.spring(), value: currentIndex == index)
                }
            }
            .padding()
            
        }
        .onAppear() {
            test()
        }
    }
    
    func test() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let a: [Post] = [Post(postImage: "poster1"), Post(postImage: "poster2"), Post(postImage: "poster3")]
            
            
            self.posts.append(contentsOf: a)
        }
    }
}

/// To for Accepting List.
struct SnapCarousel<Content: View, T: Identifiable>: View {
    
    var content: (T) -> Content
    @Binding var list: [T]
    
    /// Properties...
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    init (spacing: CGFloat = 10,
          trailingSpace: CGFloat = 100,
          index: Binding<Int>,
          items: Binding<[T]>,
          @ViewBuilder content: @escaping (T) -> Content) {
        self._list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    @GestureState var offset: CGFloat = 0
    @State private var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            
            /// Settings correct Width for snap Carousel
           // let width = (proxy.size.width - trailingSpace)
            
            /// one side snap caorusel
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustmentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(list) { item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            .padding(.horizontal, spacing)
            
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustmentWidth : 0) + offset)
            .gesture(
                DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    })
                    .onEnded({ value in
                        /// Updating Current Index...
                        let offsetX = value.translation.width
                        /// were going to convert the tranisation into progress (0 - 1)
                        /// and round the value..
                        /// based on the progress increasing or decreasing the currentIndex
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        /// settings min...
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        
                        /// updating index
                        currentIndex = index
                    
                    })
                    .onChanged({ value in
                        /// updating nly index
                        ///
                        /// Updating Current Index...
                        let offsetX = value.translation.width
                        /// were going to convert the tranisation into progress (0 - 1)
                        /// and round the value..
                        /// based on the progress increasing or decreasing the currentIndex
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        /// settings min...
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
            )
        }
        /// Animatiing when offset = 0
        .animation(.easeInOut, value: offset == 0)
    }
}
struct SnapCarouselHome_Previews: PreviewProvider {
    static var previews: some View {
        SnapCarouselHome()
    }
}

//struct SnapCarousel: View {
//    var UIState: UIStateModel
//    
//    @GestureState var translation: CGFloat = 0
//    
//    var body: some View
//        {
//            let spacing:            CGFloat = 16
//            let widthOfHiddenCards: CGFloat = 32    // UIScreen.main.bounds.width - 10
//            let cardHeight:         CGFloat = 279
//
//            let items = [
//                            Card( id: 0, name: "Hey" ),
//                            Card( id: 1, name: "Ho" ),
//                            Card( id: 2, name: "Lets" ),
//                            Card( id: 3, name: "Go" )
//                        ]
//            
//            return  Canvas {
//                        //
//                        // TODO: find a way to avoid passing same arguments to Carousel and Item
//                        //
//                        Carousel( numberOfItems: CGFloat( items.count ), spacing: spacing, widthOfHiddenCards: widthOfHiddenCards )
//                        {
//                            ForEach( items, id: \.self.id ) { item in
//                                Item( _id:                  Int(item.id),
//                                      spacing:              spacing,
//                                      widthOfHiddenCards:   widthOfHiddenCards,
//                                      cardHeight:           cardHeight )
//                                {
//                                    Text("\(item.name)")
//                                }
//                                .foregroundColor( Color.red )
//                                .background( Color.black )
//                                .cornerRadius( 8 )
//                                .shadow( color: Color( "shadow1" ), radius: 4, x: 0, y: 4 )
//                                .transition( AnyTransition.slide )
//                                .animation(.spring())//, value: UIState.activeCard)
//                            }
//                        }
//                        .environmentObject( self.UIState )
//                       
//                    }
//    
//        }
//}
//
//struct Card: Decodable, Hashable, Identifiable {
//    var id: Int
//    var name: String = ""
//}
//
//public class UIStateModel: ObservableObject {
//    @Published var activeCard: Int = 0
//    @Published var screenDrag: Float = 0.0
//}
//
//struct Carousel<Items : View> : View {
//    let items: Items
//    let numberOfItems: CGFloat //= 8
//    let spacing: CGFloat //= 16
//    let widthOfHiddenCards: CGFloat //= 32
//    let totalSpacing: CGFloat
//    let cardWidth: CGFloat
//    
//    @GestureState var isDetectingLongPress = false
//    
//    @EnvironmentObject var UIState: UIStateModel
//        
//    @inlinable public init(
//        numberOfItems: CGFloat,
//        spacing: CGFloat,
//        widthOfHiddenCards: CGFloat,
//        @ViewBuilder _ items: () -> Items) {
//        
//        self.items = items()
//        self.numberOfItems = numberOfItems
//        self.spacing = spacing
//        self.widthOfHiddenCards = widthOfHiddenCards
//        self.totalSpacing = (numberOfItems - 1) * spacing
//        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2) //279
//        
//    }
//    
//    var body: some View {
//        let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
//        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
//        let leftPadding = widthOfHiddenCards + spacing
//        let totalMovement = cardWidth + spacing
//                
//        let activeOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard))
//        let nextOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard) + 1)
//
//        var calcOffset = Float(activeOffset)
//        
//        if (calcOffset != Float(nextOffset)) {
//            calcOffset = Float(activeOffset) + UIState.screenDrag
//        }
//        
//        return HStack(alignment: .center, spacing: spacing) {
//            items
//        }
//        .offset(x: CGFloat(calcOffset), y: 0)
//        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, transaction in
//            self.UIState.screenDrag = Float(currentState.translation.width)
//            
//        }.onEnded { value in
//            self.UIState.screenDrag = 0
//            
//            if (value.translation.width < -50) &&  self.UIState.activeCard < Int(numberOfItems) - 1 {
//                          self.UIState.activeCard = self.UIState.activeCard + 1
//                          let impactMed = UIImpactFeedbackGenerator(style: .medium)
//                          impactMed.impactOccurred()
//                    }
//                    
//                    if (value.translation.width > 50) && self.UIState.activeCard > 0 {
//                          self.UIState.activeCard = self.UIState.activeCard - 1
//                          let impactMed = UIImpactFeedbackGenerator(style: .medium)
//                          impactMed.impactOccurred()
//                    }
//        })
//    }
//}
//
//struct Canvas<Content : View> : View {
//    let content: Content
//    @EnvironmentObject var UIState: UIStateModel
//    
//    @inlinable init(@ViewBuilder _ content: () -> Content) {
//        self.content = content()
//    }
//    
//    var body: some View {
//        content
//            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
//            .background(Color.white.edgesIgnoringSafeArea(.all))
//    }
//}
//
//struct Item<Content: View>: View {
//    @EnvironmentObject var UIState: UIStateModel
//    let cardWidth: CGFloat
//    let cardHeight: CGFloat
//
//    var _id: Int
//    var content: Content
//
//    @inlinable public init(
//        _id: Int,
//        spacing: CGFloat,
//        widthOfHiddenCards: CGFloat,
//        cardHeight: CGFloat,
//        @ViewBuilder _ content: () -> Content
//    ) {
//        self.content = content()
//        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2) //279
//        self.cardHeight = cardHeight
//        self._id = _id
//    }
//
//    var body: some View {
//        content
//            .frame(width: cardWidth, height: _id == UIState.activeCard ? cardHeight : cardHeight - 60, alignment: .center)
//    }
//}







//struct SnapCarousel: View {
//    
//    var colors: [Color] = [.blue, .green, .red, .orange]
//    
//    var body: some View {
//        HStack(alignment: .center, spacing: 30) {
//            ForEach(0..<colors.count, id: \.self) { i in
//                 colors[i]
//                     .frame(width: 250, height: 400, alignment: .center)
//                     .cornerRadius(10)
//            }
//        }.modifier(ScrollingHStackModifier(items: colors.count, itemWidth: 250, itemSpacing: 30))
//    }
//}
//
//struct ScrollingHStackModifier: ViewModifier {
//    
//    @State private var scrollOffset: CGFloat
//    @State private var dragOffset: CGFloat
//    
//    var items: Int
//    var itemWidth: CGFloat
//    var itemSpacing: CGFloat
//    
//    init(items: Int, itemWidth: CGFloat, itemSpacing: CGFloat) {
//        self.items = items
//        self.itemWidth = itemWidth
//        self.itemSpacing = itemSpacing
//        
//        // Calculate Total Content Width
//        let contentWidth: CGFloat = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
//        let screenWidth = UIScreen.main.bounds.width
//        
//        // Set Initial Offset to first Item
//        let initialOffset = (contentWidth/2.0) - (screenWidth/2.0) + ((screenWidth - itemWidth) / 2.0)
//        
//        self._scrollOffset = State(initialValue: initialOffset)
//        self._dragOffset = State(initialValue: 0)
//    }
//    
//    func body(content: Content) -> some View {
//        content
//            .offset(x: scrollOffset + dragOffset, y: 0)
//            .gesture(DragGesture()
//                .onChanged({ event in
//                    dragOffset = event.translation.width
//                })
//                .onEnded({ event in
//                    // Scroll to where user dragged
//                    scrollOffset += event.translation.width
//                    dragOffset = 0
//                    
//                    // Now calculate which item to snap to
//                    let contentWidth: CGFloat = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
//                    let screenWidth = UIScreen.main.bounds.width
//                    
//                    // Center position of current offset
//                    let center = scrollOffset + (screenWidth / 2.0) + (contentWidth / 2.0)
//                    
//                    // Calculate which item we are closest to using the defined size
//                    var index = (center - (screenWidth / 2.0)) / (itemWidth + itemSpacing)
//                    
//                    // Should we stay at current index or are we closer to the next item...
//                    if index.remainder(dividingBy: 1) > 0.5 {
//                        index += 1
//                    } else {
//                        index = CGFloat(Int(index))
//                    }
//                    
//                    // Protect from scrolling out of bounds
//                    index = min(index, CGFloat(items) - 1)
//                    index = max(index, 0)
//                    
//                    // Set final offset (snapping to item)
//                    let newOffset = index * itemWidth + (index - 1) * itemSpacing - (contentWidth / 2.0) + (screenWidth / 2.0) - ((screenWidth - itemWidth) / 2.0) + itemSpacing
//                    
//                    // Animate snapping
//                    withAnimation(.spring) {
//                        scrollOffset = newOffset
//                    }
//                    
//                })
//            )
//    }
//}

//struct Item: Identifiable {
//    var id: Int
//    var title: String
//    var color: Color
//}
//
//class Store: ObservableObject {
//    @Published var items: [Item]
//    
//    let colors: [Color] = [.red, .orange, .blue, .teal, .mint, .green, .gray, .indigo, .black]
//
//    // dummy data
//    init() {
//        items = []
//        for i in 0...7 {
//            let new = Item(id: i, title: "Item \(i)", color: colors[i])
//            items.append(new)
//        }
//    }
//}
//
//
//struct SnapCarousel: View {
//    
//    @StateObject var store = Store()
//    @State private var snappedItem = 0.0
//    @State private var draggingItem = 0.0
//    
//    var body: some View {
//        
//        ZStack {
//            ForEach(store.items) { item in
//                
//                // article view
//                ZStack {
//                    RoundedRectangle(cornerRadius: 18)
//                        .fill(item.color)
//                    Text(item.title)
//                        .padding()
//                }
//                .frame(width: 250, height: 350)
//
//              //  .scaleEffect(1.0 - abs(distance(item.id)) * 0.2 )
//                .opacity(1.0 - abs(distance(item.id)) * 0.3 )
//                .offset(x: myXOffset(item.id), y: 0)
//                .zIndex(1.0 - abs(distance(item.id)) * 0.1)
//            }
//        }
//        .gesture(
//            DragGesture()
//                .onChanged { value in
//                    draggingItem = snappedItem + value.translation.width / 100
//                }
//                .onEnded { value in
//                    withAnimation {
//                        draggingItem = snappedItem + value.predictedEndTranslation.width / 100
//                        draggingItem = round(draggingItem).remainder(dividingBy: Double(store.items.count))
//                        snappedItem = draggingItem
//                    }
//                }
//        )
//    }
//    
//    func distance(_ item: Int) -> Double {
//        return (draggingItem - Double(item)).remainder(dividingBy: Double(store.items.count))
//    }
//    
//    func myXOffset(_ item: Int) -> Double {
//        let angle = Double.pi * 2 / Double(store.items.count) * distance(item)
//        return sin(angle) * 200
//    }
//    
//}
