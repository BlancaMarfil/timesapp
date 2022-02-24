//
//  SetTimerValuesView.swift
//  Timer
//
//  Created by Blanca Serrano Marfil on 16/12/21.
//

import SwiftUI
import Combine

struct SetTimerValuesView: View {
    
    @Binding var hoursSelected: String
    @Binding var minutesSelected: String
    @Binding var secondsSelected: String
    
    var body: some View {
        
        HStack() {
            TextInsert(placeholder: "hours", timeInsert: $hoursSelected)
            semicolonView
            TextInsert(placeholder: "min", timeInsert: $minutesSelected)
            semicolonView
            TextInsert(placeholder: "sec", timeInsert: $secondsSelected)
        }
    }
    
    var semicolonView: some View {
        Text(":")
            .font(.title)
            .foregroundColor(Color(.systemGray))
    }
}

struct TextInsert: View {
    
    var placeholder: String
    @Binding var timeInsert: String
    
    var body: some View {
        TextField(placeholder, text: $timeInsert)
            .frame(width: 90, height: 90, alignment: .center)
            .background(Color(.systemGray5))
            .cornerRadius(15)
            .foregroundColor(Color(.systemGray))
            .font(.title2)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onChange(of: timeInsert, perform: { value in
                if value.count > 2 {
                    timeInsert = String(value.prefix(2))
                }
            })
            .onReceive(Just(timeInsert)) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                    self.timeInsert = filtered
                }
            }
    }
}

struct SetTimerValuesView_Previews: PreviewProvider {
    static var previews: some View {
        SetTimerValuesView(hoursSelected: Binding.constant("0"), minutesSelected: Binding.constant("0"), secondsSelected: Binding.constant("0"))
            .previewLayout(.sizeThatFits)
    }
}
