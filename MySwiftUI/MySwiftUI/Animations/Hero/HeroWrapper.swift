//
//  HeroWrapper.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 25.02.24.
//

import SwiftUI

struct HeroWrapper<Content: View>: View {
    
    @ViewBuilder var content: Content
    
    @Environment(\.scenePhase) private var scene
    @State private var overlayWindow: PassthroughWindow?
    @StateObject private var heroModel: HeroModel = .init()
    
    var body: some View {
        content
            .customOnChange(value: scene) { newValue in
                if newValue == .active {
                    addOverlayWindow()
                }
            }
            .environmentObject(heroModel)
    }
    
    /// Adding Overlay Window
    func addOverlayWindow() {
        for scene in UIApplication.shared.connectedScenes {
            /// Finding Active Scene
            if let windowScene = scene as? UIWindowScene,
               scene.activationState == .foregroundActive,
               overlayWindow == nil {
                let window = PassthroughWindow(windowScene: windowScene)
                window.backgroundColor = .clear
                window.isUserInteractionEnabled = false
                window.isHidden = false
                let rootController = UIHostingController(rootView: HeroLayerView().environmentObject(heroModel))
                rootController.view.frame = windowScene.screen.bounds
                rootController.view.backgroundColor = .clear
                window.rootViewController = rootController
                self.overlayWindow = window
            }
        }
        if overlayWindow == nil {
            print ("NO WINDOW SCENE")
        }
    }
                   
}

struct SourceView<Content: View>: View {
    let id: String
    @ViewBuilder var content: Content
    @EnvironmentObject private var heroModel: HeroModel
    var index: Int? {
        if let index = heroModel.info.firstIndex(where: { $0.infoID == id }) {
            return index
        }
        return nil
    }
    
    var opacity: CGFloat {
        if let index {
            return heroModel.info[index].isActive ? 0 : 1
        }
        return 1
    }
    
    var body: some View {
        content
            .opacity(opacity)
            .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { anchor in
                if let index, heroModel.info[index].isActive {
                    return [id: anchor]
                }
                return [:]
            })
            .onPreferenceChange(AnchorKey.self, perform: { value in
                if let index,
                   heroModel.info[index].isActive,
                   heroModel.info[index].sourceAnchor == nil {
                    heroModel.info[index].sourceAnchor = value[id]
                }
            })
    }
}
struct DestinationView<Content: View>: View {
    var id: String  // let id ?
    @ViewBuilder var content: Content
    @EnvironmentObject private var heroModel: HeroModel
    var index: Int? {
        if let index = heroModel.info.firstIndex(where: { $0.infoID == id }) {
            return index
        }
        return nil
    }
    var opacity: CGFloat {
        if let index {
            return heroModel.info[index].isActive ? (heroModel.info[index].hideView ? 1 : 0) : 0 // 1 : 0) : 0
        }
        return 1
    }
    
    var body: some View {
        content
            .opacity(opacity)
            .anchorPreference(key: AnchorKey.self, value: .bounds, transform: { anchor in
                if let index, heroModel.info[index].isActive {
                    return ["\(id)DESTINATION": anchor]
                }
                return [:]
            })
            .onPreferenceChange(AnchorKey.self, perform: { value in
                if let index,
                   heroModel.info[index].isActive {
                    heroModel.info[index].destinationAnchor = value["\(id)DESTINATION"]
                    
                }
            })
    }
}

fileprivate struct HeroLayerView: View {
    @EnvironmentObject private var heroModel: HeroModel
    
    var body: some View {
        GeometryReader { proxy in
            ForEach($heroModel.info) { $info in
                ZStack {
                    if let sourceAnchor = info.sourceAnchor,
                       let destinationAnchor = info.destinationAnchor,
                       let layerView = info.layerView,
                       !info.hideView {
                        ///Retreving Bounds data from the anchor values
                        let sRect = proxy[sourceAnchor]
                        let dRect = proxy[destinationAnchor]
                        let animateView = info.animateView
                        
                        let size = CGSize(
                            width: animateView ? dRect.size.width : sRect.size.width,
                            height: animateView ? dRect.size.height : sRect.size.height
                        )
                        
                        ///Position
                        let offset = CGSize (
                            width: animateView ? dRect.minX : sRect.minX,
                            height: animateView ? dRect.minY : sRect.minY
                        )
                        
                        layerView
                            .frame(width: size.width, height: size.height)
                            .clipShape(.rect(cornerRadius: animateView ? info.dCornerRadius : info.sCornerRadius))
                            .offset(offset)
                            .transition(.identity)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }
                }
                .customOnChange(value: info.animateView) { newValue in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { ///You can update this delay as per your animation duration. I gave an extra 0.1s for the animation to complete.
                        if !newValue {
                            ///Resetting All data once the view goes back to it's source state
                            info.isActive = false
                            info.layerView = nil
                            info.sourceAnchor = nil
                            info.destinationAnchor = nil
                            info.sCornerRadius = 0
                            info.dCornerRadius = 0
                            
                            info.completion(false)
                        } else {
                            info.hideView = true
                            info.completion(true)
                        }
                    }
                }
            }
        }
    }
}

fileprivate class HeroModel: ObservableObject {
    @Published var info: [HeroInfo] = []
}

/// Indiviudal Hero Animation View Info
fileprivate struct HeroInfo: Identifiable {
    private(set) var id: UUID = .init()
    private(set) var infoID: String
    var isActive: Bool = false
    var layerView: AnyView?
    var animateView: Bool = false
    var hideView: Bool = false
    var sourceAnchor: Anchor<CGRect>?
    var destinationAnchor: Anchor<CGRect>?
    var sCornerRadius: CGFloat = 0
    var dCornerRadius: CGFloat = 0
    var completion: (Bool) -> () = { _ in }
    
    init(id: String) {
        self.infoID = id
    }
}

fileprivate struct AnchorKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge (nextValue()) { $1 }
    }
}

extension View {
    @ViewBuilder func customOnChange<Value: Equatable>(value: Value, completion: @escaping (Value) -> ()) -> some View {
        if #available (iOS 17, *) {
            self
                .onChange(of: value) { oldValue, newValue in
                    completion(newValue)
                    
                }
        } else {
            self
                . onChange(of: value, perform: { value in
                    completion(value)
                })
        }
    }
}

extension View {
    @ViewBuilder func heroLayer<Content: View>(
        id: String,
        animate: Binding<Bool>,
        sourceCornerRadius: CGFloat = 0, 
        destinationCornerRadius: CGFloat = 0, 
        @ViewBuilder content: @escaping () -> Content,
        completion: @escaping (Bool) -> ()
    ) -> some View {
        self
            .modifier(HeroLayerViewModifier(id: id,
                                            animate: animate,
                                            sourceCornerRadius: sourceCornerRadius,
                                            destinationCornerRadius: destinationCornerRadius,
                                            layer: content,
                                            completion: completion))
    }
}

fileprivate struct HeroLayerViewModifier<Layer: View>: ViewModifier {
    
    let id: String
    @Binding var animate: Bool
    var sourceCornerRadius: CGFloat = 0
    var destinationCornerRadius: CGFloat = 0
    @ViewBuilder var layer: Layer
    var completion: (Bool) -> ()
    
    @EnvironmentObject private var heroModel: HeroModel
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !heroModel.info.contains(where: { $0.infoID == id }) {
                    heroModel.info.append(.init(id: id))
                }
            }
            .customOnChange(value: animate) { newValue in
                if let index = heroModel.info.firstIndex(where: { $0.infoID == id }) {
                    heroModel.info[index].isActive = true
                    heroModel.info[index].layerView = AnyView(layer)
                    heroModel.info[index].sCornerRadius = sourceCornerRadius
                    heroModel.info[index].dCornerRadius = destinationCornerRadius
                    heroModel.info[index].completion = completion
                    
                    if newValue {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                            withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                                heroModel.info[index].animateView = true
                            }
                        }
                    } else {
                        heroModel.info[index].hideView = false
                        withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                            heroModel.info[index].animateView = false
                        }
                    }
                }
                
            }
        
    }
}

fileprivate class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == view ? nil : view
    }
}

//---------------------------------------------

struct HeroHomeView: View {
    @State private var showView: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(itemsH) { item in
                    CardView(item: item)
                }
            }
            .navigationTitle("Hero effect")
        }
            
            
//            VStack {
//                SourceView(id: "View 1") {
//                    Circle()
//                        .fill(.red)
//                        .frame(width: 50, height: 50)
//                        .onTapGesture {
//                            showView.toggle()
//                        }
//                }
//            }
//            .padding()
//            .navigationTitle("Hero")
//            .navigationDestination(isPresented: $showView) {
//                DestinationView(id: "View 1") {
//                    Circle()
//                        .fill(.red)
//                        .frame(width: 150, height: 150)
//                        .onTapGesture {
//                            showView.toggle()
//                        }
//                }
//                .padding(15)
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
//                .navigationBarBackButtonHidden()
//                .navigationTitle("Detail View")
//            }
//        }
////        .fullScreenCover(isPresented: $showView, content: {
////      //  .sheet(isPresented: $showView, content: {
////            DestinationView(id: "View 1") {
////                Circle()
////                    .fill(.red)
////                    .frame(width: 150, height: 150)
////                    .onTapGesture {
////                        showView.toggle()
////                    }
////            }
////            .padding(15)
////            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
////            .interactiveDismissDisabled()
////        })
//        .heroLayer(id: "View 1", animate: $showView) {
//            Circle()
//                .fill(.red)
//        } completion: { status in
//            print(status ? "Open" : "Close")
//        }
    }
}

struct CardView: View {
    
    var item:  ItemH
    @State private var expandSheet: Bool = false
    var body: some View {
        HStack(spacing: 12) {
            SourceView(id: item.id.uuidString) {
                ImageView()
            }
            Text(item.title)
            Spacer(minLength: 0)
                
        }
        .contentShape(.rect)
        .onTapGesture {
            expandSheet.toggle()
        }
        .sheet(isPresented: $expandSheet, content: {
            DestinationView(id: item.id.uuidString) {
                ImageView()
                    .onTapGesture {
                        expandSheet.toggle()
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding()
            .interactiveDismissDisabled()
        })
        .heroLayer(id: item.id.uuidString, animate: $expandSheet) {
            ImageView()
        } completion: { _ in
            
        }

    }
    
    @ViewBuilder func ImageView() -> some View {
        Image(systemName: item.symbol)
            .font(.title2)
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(item.color.gradient, in: .circle)
    }
}

/// Demo Item Model
struct ItemH: Identifiable {
    var id: UUID = .init()
    var title: String
    var color: Color
    var symbol: String
}

var itemsH: [ItemH] = [
    .init(title: "Book Icon", color: .red, symbol: "book.fill"),
    .init(title: "Stack Icon", color: .green, symbol: "square.stack.3d.up"),
    .init(title: "Rectangle Icon", color: .orange, symbol: "rectangle.portrait")
]
