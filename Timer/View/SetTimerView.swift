//
//  SetTimerView.swift
//  Timer
//
//  Created by Blanca Serrano Marfil on 13/12/21.
//

import SwiftUI

struct SetTimerView: View {
    
    @Environment(\.presentationMode) var presentationMode
    //@Binding var showSetTimer: Bool
    
    @State var hoursSelected: String = ""
    @State var minutesSelected: String = ""
    @State var secondsSelected: String = ""
    
    //@State var newTimer: TimerModel = TimerModel(name: "", value: 0)
    //@Binding var timerSelected: TimerModel
    @Binding var timeRemaining: Double
    
    var body: some View {
    
        ZStack {
            
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        //showSetTimer.toggle()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Color("Mint"))
                            .font(.largeTitle)
                            .padding(20)
                    })
                    Spacer()
                }
                
                Text("New Timer")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(.bottom, 35)
                
                SetTimerValuesView(hoursSelected: $hoursSelected,
                               minutesSelected: $minutesSelected,
                               secondsSelected: $secondsSelected)
                
                Button {
                    setTimer()
                } label: {
                    Text("Set")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 140)
                        .background(
                            Capsule()
                                .fill(Color("Mint"))
                        )
                        .padding(30)
                }
                Spacer()
            }
        }
        .mask {
            RoundedRectangle(cornerRadius: 30)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    func setTimer() {
        let hours = Double(hoursSelected) ?? 0
        let minutes = Double(minutesSelected) ?? 0
        let seconds = Double(secondsSelected) ?? 0
        
        //timerSelected = TimerModel(hours: hours, minutes: minutes, seconds: seconds)
        timeRemaining = hours * 3600 + minutes * 60 + seconds
        
        //showSetTimer.toggle()
        presentationMode.wrappedValue.dismiss()
    }
}

struct SetTimerView_Previews: PreviewProvider {
    
    static var previews: some View {
//        SetTimerView(showSetTimer: Binding.constant(false), timeRemaining: Binding.constant(0))
        //SetTimerView()
        SetTimerView(timeRemaining: Binding.constant(0))
    }
}
