//
//  Map17.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 18.10.23.
//

import SwiftUI
import MapKit

struct Map17: View {
    @ObservedObject var locationManager: LocationManager
    
    //  @Namespace var mapScope
    
    @State private var position: MapCameraPosition = .automatic
    
    @State private var visibleRegion: MKCoordinateRegion?
    
    @State private var searchResults: [MKMapItem] = []
    
    @State private var selectedResult: MKMapItem? /// только для Marker
    @State private var selectedTag: Int? ///можно использовать .tag для Annotation и Marker
    
    @State private var route: MKRoute?
    
    let gradient = LinearGradient(colors: [.red, .yellow, .green], startPoint: .leading, endPoint: .trailing)
    let stroke = StrokeStyle(lineWidth: 5,
                             lineCap: .round,
                             lineJoin: .round,
                             // miterLimit: <#T##CGFloat#>,
                             dash: [10, 10])
    // dashPhase: <#T##CGFloat#>)
    
    var body: some View {
        Map(position: $position, selection: $selectedResult) {
            Annotation("Parking", coordinate: .parking, anchor: .bottom) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.orange)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.black, lineWidth: 3)
                    Image("1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .padding(4)
                }
            }
            .annotationTitles(.hidden)
            .tag(1225544)
            
            ForEach(searchResults, id: \.self) { result in
                Marker(item: result)
                    .tint(.mint)
            }
            .annotationTitles(.hidden)
            
            UserAnnotation()
            if let route {
                MapPolyline(route)
                //.stroke(.blue, lineWidth: 5)
                    .stroke(gradient, style: stroke)
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .safeAreaInset(edge: .top) {
            HStack {
                Spacer()
                VStack(spacing: 0) {
                    if let selectedResult {
                        ItemInfoView(selectedResult: $selectedResult, route: $route)
                            .frame(height: 128)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding([.top, .horizontal])
                    }
                    Map17Buttons(position: $position, searchResults: $searchResults, visibleRegion: visibleRegion)
                        .padding(.top)
                }
                
                Spacer()
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                VStack(spacing: 0) {
                    if let selectedResult {
                        ItemInfoView(selectedResult: $selectedResult, route: $route)
                            .frame(height: 128)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding([.top, .horizontal])
                    }
                    Map17Buttons(position: $position, searchResults: $searchResults, visibleRegion: visibleRegion)
                        .padding(.top)
                }
                
                Spacer()
            }
            .background(.thinMaterial)
        }
        .onChange(of: searchResults) {
            position = .automatic
        }
        .onChange(of: selectedResult) {
            getDirections()
        }
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
        .mapControlVisibility(.hidden)
        //        .mapControls {
        //            MapUserLocationButton()
        //            MapCompass()
        //        }
        // .mapScope(mapScope)
    }
    func getDirections() {
        route = nil
        guard let selectedResult else { return }
        let request = MKDirections.Request()
        request.source = .forCurrentLocation()
        request.transportType = .walking
        request.destination = selectedResult
        
        Task {
            let directions = MKDirections(request: request)
            let response = try? await directions.calculate()
            route = response?.routes.first
        }
    }
}

#Preview {
    Map17()
}

extension CLLocationCoordinate2D {
    static let parking = CLLocationCoordinate2D(latitude: 42.354528, longitude: -71.068369)
}

extension MKCoordinateRegion {
    static let boston = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.360256, longitude: -71.057279),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    static let northShore = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.547408, longitude: -70.870085),
        span: MKCoordinateSpan( latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
}

struct Map17Buttons: View {
    
    @Binding var position: MapCameraPosition
    @Binding var searchResults: [MKMapItem]
    
    var visibleRegion: MKCoordinateRegion?
    
    var body: some View {
        HStack {
            Button {
                search(for: "playground")
            } label: {
                Label("Playgrounds", systemImage: "figure.and.child.holdinghands")
            }
            .buttonStyle(.borderedProminent)
            Button {
                search(for: "beach")
            } label: {
                Label("Beaches", systemImage: "beach.umbrella")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                withAnimation {
                    position = .region(.boston)
                }
            } label: {
                Label("Boston", systemImage: "building.2")
            }
            .buttonStyle(.bordered)
            Button {
                withAnimation {
                    position = .region(.northShore)
                }
                
            } label: {
                Label("North Shore", systemImage: "water.waves")
            }
            .buttonStyle(.bordered)
            
            Button {
                withAnimation {
                    position = .camera(
                        MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 48.24608899975663, longitude: 16.43973750035735),
                                  distance: 980,
                                  heading: 242,
                                  pitch: 60)
                    )
                }
                
            } label: {
                Label("My", systemImage: "heart")
            }
            .buttonStyle(.bordered)
            
            Button {
                withAnimation {
                    position =  .userLocation(followsHeading: true, fallback: .automatic)
                      //  .userLocation(fallback: .automatic)
                }
            } label: {
                Label("My", systemImage: "person")
            }
            .buttonStyle(.bordered)
            
            Button {
                withAnimation {
                    position = .item(MKMapItem(placemark: MKPlacemark(coordinate: .parking)))
                }
            } label: {
                Label("My", systemImage: "mappin")
            }
            .buttonStyle(.bordered)
        }
        .labelStyle(.iconOnly)
    }
    
    func search(for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = visibleRegion ??  MKCoordinateRegion(
            center: .parking,
            span: MKCoordinateSpan(latitudeDelta: 0.0125, longitudeDelta: 0.0125))
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
}

struct ItemInfoView: View {
    
    @Binding var selectedResult: MKMapItem?
    @Binding var route: MKRoute?
    @State private var lookAroundScene: MKLookAroundScene?
    
    private var travelTime: String? {
        guard let route else { return nil }
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: route.expectedTravelTime)
    }
        
    var body: some View {
        LookAroundPreview(initialScene: lookAroundScene)
            .overlay(alignment: .bottomTrailing) {
                HStack {
                    Text("\(selectedResult?.name ?? "")")
                    if let travelTime {
                        Text(travelTime)
                    }
                }
                .font(.caption)
                .foregroundStyle(.white)
                .padding(10)
            }
            .onAppear {
                getLookAroundScene()
            }
            .onChange(of: selectedResult) {
                getLookAroundScene()
            }
    }
    
    func getLookAroundScene() {
        lookAroundScene = nil
        Task {
            if let selectedResult = selectedResult {
                let request = MKLookAroundSceneRequest(mapItem: selectedResult)
                lookAroundScene = try? await request.scene
            }
        }
    }
}
