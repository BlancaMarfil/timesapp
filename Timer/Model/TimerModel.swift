//
//  Timer.swift
//  Timer
//
//  Created by Blanca Serrano Marfil on 5/12/21.
//

import Foundation

//CHECK IF ALL INITS ARE USED IN THE PROJECT

struct TimerModelOld: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    var value: TimeInterval
    
    init(name: String = "", value: Double) {
        self.name = name
        self.value = value
    }
    
    init(name: String = "", hours: Double, minutes: Double, seconds: Double) {
        self.name = name
        self.value = hours * 3600 + minutes * 60 + seconds
    }
    
    func getTimeString() -> String {
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: value) ?? "00:00"
    }
    
    mutating func setValue(_ value: TimeInterval) {
        self.value = value
    }
}
