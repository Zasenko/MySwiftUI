//
//  CustomCarouselSliderWithPanging.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 27.09.23.
//

import SwiftUI

/// Paging Slider Data Model
struct Item: Identifiable {
    private(set) var id: UUID = .init()
    var color: Color
    var title: String
    var subTitle: String
}

struct CustomCarouselSliderWithPangingTEST: View {
    
    @State private var items: [Item] = [Item(color: .red, title: "World Clock City Digital City Digital", subTitle: "View the time in multiple cities around the world."),
                                       Item(color: .blue, title: "City Digital", subTitle: "Add a clock for a city to check the time at that location.")]
    var body: some View {
        CustomCarouselSliderWithPanging(items: $items)
            .onAppear() {
                test()
            }
    }
    
    func test() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            let a: [Item] = [.init(color: .green, title: "City Analouge", subTitle: "Add a clock for a city to check the time at that location. Add a clock for a city to check the time at that location. Add a clock for a city to check the time at that location."),
                       .init(color: .yellow, title: "Next Alarm", subTitle: "Display upcoming alarm."),
                       .init(color: .pink, title: "Alarm", subTitle: "Display upcoming alarm."),
                       .init(color: .green, title: "Borer Strasse", subTitle: "Display upcoming alarm."), .init(color: .green, title: "City Analouge", subTitle: "Add a clock for a city to check the time at that location. Add a clock for a city to check the time at that location. Add a clock for a city to check the time at that location."),
                             .init(color: .yellow, title: "Next Alarm", subTitle: "Display upcoming alarm."),
                             .init(color: .pink, title: "Alarm", subTitle: "Display upcoming alarm."),
                             .init(color: .green, title: "Borer Strasse", subTitle: "Display upcoming alarm."), .init(color: .green, title: "City Analouge", subTitle: "Add a clock for a city to check the time at that location. Add a clock for a city to check the time at that location. Add a clock for a city to check the time at that location."),
                             .init(color: .yellow, title: "Next Alarm", subTitle: "Display upcoming alarm."),
                             .init(color: .pink, title: "Alarm", subTitle: "Display upcoming alarm."),
                             .init(color: .green, title: "Borer Strasse", subTitle: "Display upcoming alarm.")
                             ]
            self.items.append(contentsOf: a)
        }
    }
}

struct CustomCarouselSliderWithPanging: View {
    
    // View Properties
    @Binding var items: [Item]
    
    // Customization Properties
    @State private var showIndicator: ScrollIndicatorVisibility = .hidden
    @State private var showPagingControl: Bool = false
    @State private var disablePagingInteraction: Bool = false
    @State private var pagingSpacing: CGFloat = 20
    @State private var titleScrollSpeed: CGFloat = 0.6
    @State private var stretchContent: Bool = false
           
    var body: some View {
        
        VStack {
            CustomPagingSlider(showPagingControl: showPagingControl, disablePagingInteraction: disablePagingInteraction, titleScrollSpeed: titleScrollSpeed, pagingControlSpacing: pagingSpacing, data: $items) { $item in
                RoundedRectangle(cornerRadius: 15)
                    .fill(item.color.gradient)
                    .frame(width: stretchContent ? nil : 150, height: stretchContent ? 300 : 120)
            } titleContent: { $item in
                VStack(spacing: 5) {
                    Text(item.title)
                        .font(.largeTitle.bold())
                    Text(item.subTitle)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .frame(height: 45)
                }
                .padding(.bottom, 35)
            }
            .safeAreaPadding([.horizontal, .top], 20)
            
            List {
                Toggle ("Show Paging Control", isOn: $showPagingControl)
                Toggle ("Disable Page Interaction", isOn: $disablePagingInteraction)
                Toggle("Stretch Content", isOn: $stretchContent)
                Section ("Title Scroll Speed") {
                    Slider (value: $titleScrollSpeed)
                }
                Section ( "Paging Spacing") {
                    Slider (value: $pagingSpacing, in: 20...40)
                }
            }
            .clipShape(.rect(cornerRadius: 15))
            .padding (15)
            
        }

    }
}

/// Custom View

struct CustomPagingSlider<Content: View, TitleContent: View, Item: RandomAccessCollection>: View where Item: MutableCollection, Item.Element: Identifiable {
    
    /// Customization Properties
    var showsIndicator: ScrollIndicatorVisibility = .hidden
    var showPagingControl: Bool = true
    var disablePagingInteraction: Bool = false
    var titleScrollSpeed: CGFloat = 0.6
    var pagingControlSpacing: CGFloat = 20
    var spacing: CGFloat = 10
    
    @Binding var data: Item
    @ViewBuilder var content: (Binding<Item.Element>) -> Content
    @ViewBuilder var titleContent: (Binding<Item.Element>) -> TitleContent
    
    /// View Properties
    @State private var activeId: UUID?
    
    
    var body: some View {
        VStack(spacing: pagingControlSpacing) {
            ScrollView(.horizontal) {
                HStack(spacing: spacing) {
                    ForEach ($data) { item in
                        VStack (spacing: 0) {
                            
                            content(item)
                            titleContent(item)
                                .frame(maxWidth: .infinity)
                                .visualEffect { content, geometryProxy in
                                    content.offset(x: scrollOffset(geometryProxy))
                                }
                                .padding(.top)
                        }
                        .containerRelativeFrame(.horizontal)
                    }
                }
                /// Adding Paging
                .scrollTargetLayout()
            }
            .scrollIndicators(showsIndicator)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $activeId)
            if showPagingControl {
                PagingControl(numberOfPages: data.count, activePage: activePage) { value in
                    // Updating to current Page
                    if let index = value as? Item.Index, data.indices.contains (index) {
                        if let id = data[index].id as? UUID {
                            withAnimation(.snappy (duration: 0.35, extraBounce: 0)) {
                                activeId = id
                            }
                        }
                    }
                }
                .disabled(disablePagingInteraction)
            }
        }
    }
    
    var activePage: Int {
        if let index = data.firstIndex (where: { $0.id as? UUID == activeId }) as? Int {
            return index
        }
        return 0
    }
    
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.bounds(of: .scrollView)?.minX ?? 0
        return -minX * min(titleScrollSpeed, 1.0)
    }
}

/// Let's Add Paging Control
struct PagingControl: UIViewRepresentable {
    
    var numberOfPages: Int
    var activePage: Int
    var onPageChange: (Int) -> ()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPageChange: onPageChange)
    }
    
    func makeUIView(context: Context) -> UIPageControl {
        let view = UIPageControl ()
        view.currentPage = activePage
        view.numberOfPages = numberOfPages
        view.backgroundStyle = .prominent
        view.currentPageIndicatorTintColor = UIColor(Color.primary)
        view.pageIndicatorTintColor = UIColor.placeholderText
        view.addTarget(context.coordinator, action: #selector(Coordinator.onPageUpdate(control:)), for: .valueChanged)
        return view
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.numberOfPages = numberOfPages
        uiView.currentPage = activePage
    }
    
    class Coordinator: NSObject {
        
        var onPageChange: (Int) -> ()
        
        init (onPageChange: @escaping (Int) -> Void) {
            self.onPageChange = onPageChange
        }
        
        @objc func onPageUpdate(control: UIPageControl) {
            onPageChange(control.currentPage)
        }
    }
}

#Preview {
    CustomCarouselSliderWithPangingTEST()
}
