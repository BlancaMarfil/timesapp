//
//  TimerView.swift
//  Timer
//
//  Created by Blanca Serrano Marfil on 20/11/21.
//

import SwiftUI

//Ver como actualizar los 5 min adicionales

struct TimerView: View {
    
    // Timer variables
    var timerName: String
    var timerValue: Double
    
    @State var timeRemaining: Double = 0
    @State var timer = Timer.publish(every: 1.0, on: .main, in: .common)
    
    // Percentage Variables
    @State var totalValue: TimeInterval = 0
    @State var percentage: CGFloat = 1
    
    // Set/Pause/Resume Button
    @State var currentButtonText: String = "Set"
    @State var showSetSheet: Bool = false
    
    //Alarm sound
    @State var isSoundPlaying: Bool = false
    
    init(timerName: String = "", timerValue: Double = 0) {
        self.timerName = timerName
        self.timerValue = timerValue
    }
    
    var body: some View {
        
        ZStack {
            Color("BackgroundColor").ignoresSafeArea(.all)
            
            VStack {
                //Spacer()
                upperSatelliteButtons
                mainCircle
                bottomSatelliteButtons
                Spacer()
                NavigationLink {
                    TimerListView()
                } label: {
                    Text("All Timers")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 320, height: 55)
                        .background(
                            Capsule()
                                .fill(Color("Mint"))
                        )
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .onAppear(perform: {
            timeRemaining = timerValue
            totalValue = timeRemaining
            if timeRemaining > 0 {
                _ = timer.connect()
            }
            SoundManager.instance.stopSound()
        })
        .onReceive(timer) { _ in
            updateTimeRemaining()
        }
    }
    
    //MARK: - Satellite Buttons
    
    var upperSatelliteButtons: some View {
        HStack {
            Button {
                addAdditionalValue(10)
                stopAlarmSound()
            } label: {SatelliteButton(text: "+10 s", color: Color.yellow)}
            Spacer()
            Button {
                addAdditionalValue(5 * 60)
                stopAlarmSound()
            } label: {SatelliteButton(text: "+5 min", color: Color.yellow)}
        }
        .padding()
        .padding(.top, 70)
    }
    
    var bottomSatelliteButtons: some View {
        HStack {
            Button {
                performStop()
            } label: {SatelliteButton(text: "Stop", color: Color("Pink"))}
            Spacer()
            Button {
                performSetPause()
                stopAlarmSound()
            } label: {SatelliteButton(text: currentButtonText, color: Color("LightBlue"))}
            .sheet(isPresented: $showSetSheet) {
                // On dismiss
                totalValue = timeRemaining
                reconnectTimer()
            } content: {
                SetTimerView(timeRemaining: $timeRemaining)
            }

        }
        .padding()
    }
    
    //MARK: - Main Circle
    
    var mainCircle: some View {
        ZStack {
            CircleTimerView(percentage: $percentage)
            VStack {
                if timeRemaining > 0 {
                    Text(timerName)
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(Color("LightGrey"))
                        .padding(.bottom, 4)
                    
                }
                Text(getTimeDsiplay(value: timeRemaining))
                    .font(.system(size: 72, weight: .light))
                    .foregroundColor(Color.white)
                    .padding(4)
                if timeRemaining > 0 {
                    Label(getOffDisplayTime(), systemImage: "bell.fill")
                        .foregroundColor(Color("LightGrey"))
                }
            }
        }
    }
    
    //MARK: - Timer Functions
    
    /// Starts a timer
    ///
    func reconnectTimer() {
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
        _ = timer.connect()
    }
    
    /// Updating specific parameters
    ///
    /// The parameter update occurs each time the timers updates:
    ///  - The time remaining decreases in 1
    ///  - The percentage of the filled stroke circle is updated
    ///  - The Set/Pause/Resume button is updated to Pause.
    ///
    ///In case the time remaining is 0, timer is disconnected, the stroke circle is filled again and the button is set to Set
    func updateTimeRemaining() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            percentage = timeRemaining / totalValue
            currentButtonText = "Pause"
            stopAlarmSound()
        } else {
            timer.connect().cancel()
            percentage = 1
            totalValue = 0
            currentButtonText = "Set"
            triggerAlarmSound()
        }
    }
    
    //MARK: - Display Functions
    
    /// Formats main timer display
    ///
    /// Always two figures are shown.
    /// If the timer does not reach the hour, the hour padding disappears.
    /// Even if the timer consists of seconds, minutes padding still shows.
    /// ```
    /// getTimeDisplay(value: 130) -> "02:10"
    /// getTimeDisplay(value: 3720) -> "01:02:00"
    /// ```
    ///
    /// - Parameter Double: The value in seconds to be displayed
    /// - Returns: Formatted string
    func getTimeDsiplay(value: Double) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.hour, .minute, .second]
        
        let fullString = formatter.string(from: value) ?? ""
        var formattedString = fullString
        
        let array = fullString.split(separator: ":")
        if array[0] == "00" {
            formattedString = array[1...].joined(separator: ":")
        }
        return formattedString
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    /// Retuers the formatted time when the timer ends.
    ///
    /// The format will be of type "HH:mm"
    /// ```
    /// getOffDisplayTime() -> "09:43"
    /// ```
    ///
    /// - Returns: Formatted time
    func getOffDisplayTime() -> String {
        let offTime = Date().addingTimeInterval(timeRemaining)
        return dateFormatter.string(from: offTime)
    }
    
    
    //MARK: - Satellite buttons functions
    
    /// Top satellite buttons functionality
    ///
    /// The function always makes sure the timer is connected or initialized.
    /// - Parameter Double: Possible options 10 s or 5 min
    func addAdditionalValue(_ value: Double) {
        reconnectTimer()
        timeRemaining += value
        totalValue += value
    }
    
    /// Stop the timer
    ///
    /// Stops the timer and updates the corresponding parameters
    func performStop() {
        timer.connect().cancel()
        percentage = 1
        timeRemaining = 0
        totalValue = 0
        currentButtonText = "Set"
        stopAlarmSound()
    }
    
    /// Set/Pause/Resume Button
    ///
    /// The button has 3 functions

    func performSetPause() {
        switch currentButtonText {
        case "Set":
            showSetSheet.toggle()
            return
        case "Pause":
            timer.connect().cancel()
            currentButtonText = "Resume"
        case "Resume":
            reconnectTimer()
            currentButtonText = "Pause"
        default:
            return
        }
    }
    
    //MARK: - Alarm functions

    func triggerAlarmSound() {
        SoundManager.instance.playSound()
        isSoundPlaying = true
    }
    
    func stopAlarmSound() {
        SoundManager.instance.stopSound()
        isSoundPlaying = false
    }
}



//MARK: - Extracted Subviews

struct CircleTimerView: View {
    
    @Binding var percentage: CGFloat
    
    var body: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 300, height: 300)
            .overlay(
                Circle()
                    .trim(from: 0, to: percentage)
                    .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                    .fill(Color("Mint"))
                    .rotationEffect(.degrees(-90))
            ).animation(
                .spring(response: 1.0, dampingFraction: 1.0, blendDuration: 1.0),
                value: percentage)
    }
}

struct SatelliteButton: View {
    
    var text: String = ""
    var color: Color = Color.yellow
 
    var body: some View {
        Text(text)
            .font(.system(size: 25))
            .frame(width: 100, height: 100)
            .foregroundColor(color)
            .overlay(
                Circle()
                    .stroke(color, lineWidth: 2))
    }
}

struct TimerView_Previews: PreviewProvider {
    
    static var viewContext = CoreDataManager.instance.container.viewContext
    
    static var previews: some View {
        return TimerView(timerName: "Overnight", timerValue: 0)
    }
}

