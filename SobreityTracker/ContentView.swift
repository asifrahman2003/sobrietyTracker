//
//  ContentView.swift
//  SobreityTracker
//
//  Created by Muhammad Asifur Rahman on 3/6/25.
//

import SwiftUI

struct ContentView: View {
    // uses a date picker that allows the user to choose their milestone date
    @State private var targetDate: Date = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    
    // this variable will store the remaining time (in seconds) until the target date
    @State private var timeRemaining: TimeInterval = 0
    
    // a timer publisher that fires every second to update the countdown
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // toggle between Reverse Countdown and Elapsed time modes
    @State private var isReversedMode: Bool = true
    
    // motivational quote state and list of quotes
    @State private var motivationalQuote: String = "Believe in yourself and all that you are!"
    let quotes = [
        "Believe in yourself and all that you are!",
        "Every step forward is a step towards success.",
        "The journey of a thousand miles begins with one step.",
        "You are stronger than you think.",
        "Your future is created by what you do today."
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // modern gradient background
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack (spacing: 20) {
                        // header for the app
                        Text("Sobriety Tracker")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.top, 40)
                        
                        // datePicker for milestone date selection
                        DatePicker("Select your milestone date", selection: $targetDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding(25)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        
                        // picker to toggle between reverse countdown and elapsed time
                        Picker("Mode", selection: $isReversedMode) {
                            Text("Countdown").tag(true)
                            Text("Elapsed").tag(false)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        
                        // display timer based on selected mode
                        VStack {
                            Text(isReversedMode ? "Time until milestone: " : "Time since milestone: ")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(formattedTime())
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .onReceive(timer) { _ in
                                    updateTime()
                                }
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // motivational quote section
                        VStack(spacing: 10) {
                            Text(motivationalQuote)
                                .font(.system(size: 15, design: .rounded))
                                .italic()
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Button(action: {
                                // update quote with a random one from the list
                                motivationalQuote = quotes.randomElement() ?? motivationalQuote
                            }) {
                                Text("New Quote")
                                    .font(.subheadline)
                                    .padding(10)
                                    .background(Color.white)
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(25)
                        .background(Color.black.opacity(1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Milestone steps")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Day 1: Detox begins - your body starts to heal.")
                                Text("Day 3: Cravings may peak - stay strong!")
                                Text("Day 7: One week sober – celebrate your progress!")
                                Text("Day 14: Noticeable improvements in breathing and energy.")
                                Text("Day 30: One month milestone – significant physical and mental improvements!")
                            }
                            .font(.subheadline)
                            .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarTitle("Sobriety Tracker", displayMode: .inline)
    }
    // updates the timeRemaining variable with the difference between the curr time and the target time
    func updateTime() {
        let currentTime = Date()
        if isReversedMode {
            timeRemaining = targetDate.timeIntervalSince(currentTime)
        } else {
            timeRemaining = currentTime.timeIntervalSince(targetDate)
        }
        
    }
    func formattedTime() -> String {
        // ensure that value is never negative
        let remaining = max(0, Int(timeRemaining))
        let days = remaining / (24 * 3600)
        let hours = (remaining % (24 * 3600)) / 3600
        let minutes = (remaining % 3600) / 60
        let seconds = remaining % 60
        return "\(days) days \(hours) hours \(minutes) minutes \(seconds) seconds"
        
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
