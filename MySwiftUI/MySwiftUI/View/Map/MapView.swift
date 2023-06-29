//
//  MapView.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 23.06.23.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State private var selectedAnnotation: AnnotationItem?

    var body: some View {
        ZStack {
                    Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
                        MapAnnotation(coordinate: annotation.coordinate) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .opacity(0.3)
                                    .frame(width: 40, height: 40)
                                
                                Image(uiImage: annotation.photo)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .scaleEffect(selectedAnnotation == annotation ? 2 : 1)
                        
                                    .onTapGesture {
                                        selectedAnnotation = annotation
                                    }
                            }
                        }
                    }
                    
//                    if let selectedAnnotation = selectedAnnotation {
//                        VStack {
//                            Spacer()
//                            Text(selectedAnnotation.title)
//                                .font(.headline)
//                                .padding()
//                                .background(Color.white)
//                                .cornerRadius(10)
//                                .padding(.horizontal)
//                                .transition(.move(edge: .bottom))
//                                .animation(.easeInOut)
//                        }
//                    }
                }
        .onAppear {
            viewModel.fetchLocations()
        }
        .onChange(of: viewModel.places) { places in
            if let firstPlaceCoordinate = places.first?.coordinate {
                region = MKCoordinateRegion(center: firstPlaceCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            }
        }
    }
    
    private var annotations: [AnnotationItem] {
        var items: [AnnotationItem] = []
        
        for place in viewModel.places {
            let annotation = AnnotationItem(title: place.name, coordinate: place.coordinate, photo: place.photo, type: .place)
            items.append(annotation)
        }
        
        for event in viewModel.events {
            let annotation = AnnotationItem(title: event.name, coordinate: event.coordinate, photo: event.photo, type: .event)
            items.append(annotation)
        }
        
        return items
    }
}

struct AnnotationItem: Identifiable, Equatable  {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
    let photo: UIImage
    let type: AnnotationType
    
    static func ==(lhs: AnnotationItem, rhs: AnnotationItem) -> Bool {
            // Сравнивайте свойства, которые определяют уникальность места
            return lhs.id == rhs.id // Пример сравнения по имени
        }
}

enum AnnotationType {
    case place
    case event
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

struct Place: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let about: String
    let coordinate: CLLocationCoordinate2D
    let photo: UIImage
    let address: String
    let openTime: String
    let type: String
    
    static func ==(lhs: Place, rhs: Place) -> Bool {
            // Сравнивайте свойства, которые определяют уникальность места
            return lhs.id == rhs.id // Пример сравнения по имени
        }
}

struct Event: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let about: String
    let coordinate: CLLocationCoordinate2D
    let photo: UIImage
    let address: String
    let startTime: String
    let finishTime: String
    
    static func ==(lhs: Event, rhs: Event) -> Bool {
            // Сравнивайте свойства, которые определяют уникальность события
            return lhs.id == rhs.id // Пример сравнения по имени
        }
}

class MapViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var events: [Event] = []
    
    func fetchLocations() {
        let place1 = Place(name: "Cafe ABC", about: "Cozy cafe with delicious food", coordinate: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278), photo: UIImage(named: "1")!, address: "123 Main St", openTime: "8:00 AM", type: "Cafe")
            let place2 = Place(name: "Bar XYZ", about: "Hip bar with live music", coordinate: CLLocationCoordinate2D(latitude: 51.5111, longitude: -0.1234), photo: UIImage(named: "2")!, address: "456 Elm St", openTime: "6:00 PM", type: "Bar")
            
            let event1 = Event(name: "Concert", about: "Live music concert", coordinate: CLLocationCoordinate2D(latitude: 51.5151, longitude: -0.1299), photo: UIImage(named: "3")!, address: "789 Oak St", startTime: "7:00 PM", finishTime: "10:00 PM")
            let event2 = Event(name: "Art Exhibition", about: "Contemporary art exhibition", coordinate: CLLocationCoordinate2D(latitude: 51.5132, longitude: -0.1212), photo: UIImage(named: "4")!, address: "234 Pine St", startTime: "10:00 AM", finishTime: "5:00 PM")
            
            // Заполняем свойства places и events
            places = [place1, place2]
            events = [event1, event2]
    }
}

