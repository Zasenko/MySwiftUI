//
//  Filtering-List-By-Date.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 03.04.23.
//

import SwiftUI

struct Filtering_List_By_Date: View {
    @State private var selectedDate: Date = Date()
    @State private var filteredBooks: [Book] = []
    
    @State private var books = [
        Book(title: "Introduction to JavaScript", datePublished: Date.from(year: 2023, month: 05, day: 10)),
        Book(title: "Mastering Swift", datePublished: Date.from(year: 2023, month: 04, day: 11)),
        Book(title: "Beginning SQL", datePublished: Date.from(year: 2023, month: 04, day: 12)),
        Book(title: "Professional Git", datePublished: Date.from(year: 2023, month: 04, day: 11)),
    ]
    
    var body: some View {
        VStack {
            DatePicker("Search by date", selection: $selectedDate, displayedComponents: .date)
            
            Button("Clear Filters") {
                filteredBooks = books
            }
            
            Spacer()
            
            if filteredBooks.isEmpty {
                HStack {
                    Spacer()
                    Text("No books found.")
                    Spacer()
                }
            } else {
                List(filteredBooks) { book in
                    VStack(alignment: .leading) {
                        Text(book.title)
                        Text(book.datePublished, style: .date)
                    }
                }
            }
            Spacer()
            
        }.padding()
            .onChange(of: selectedDate) { value in
                filteredBooks = books.filter { Calendar.current.compare($0.datePublished, to: selectedDate, toGranularity: .day) == .orderedSame }
            }.onAppear {
                filteredBooks = books
            }
    }
}

struct Filtering_List_By_Date_Previews: PreviewProvider {
    static var previews: some View {
        Filtering_List_By_Date()
    }
}

extension Date {
    
    static func from(year: Int, month: Int, day: Int) -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents) ?? Date()
    }
    
}

struct Book: Identifiable {
    let id = UUID()
    let title: String
    let datePublished: Date
}
