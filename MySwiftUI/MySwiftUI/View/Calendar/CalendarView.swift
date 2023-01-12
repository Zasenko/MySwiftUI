//
//  CalendarView.swift
//  MySwiftUI
//
//  Created by Dmitry Zasenko on 11.01.23.
//

import SwiftUI

struct CalendarView: View {
    
    @State private var date = Date()
    @State private var dates: Set<DateComponents> = []

    var body: some View {
        VStack {
            DatePicker(
                   "Start Date",
                   selection: $date,
                   displayedComponents: [.date]
               )
               .datePickerStyle(.graphical)
            
            MultiDatePicker("Dates Available", selection: $dates)
                .background(.yellow.gradient)
                .fixedSize()
            
            Text(date.formatted(
                .dateTime
                    //.locale(locale)
                    .minute()
                    .hour()
                    .day()
                    .weekday(.wide)
                    .month(.wide)
                    .attributed
            ))
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
