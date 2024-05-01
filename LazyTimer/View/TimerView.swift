//
//  TimerView.swift
//  LazyTimer
//
//  Created by knp on 28/11/2023.
//

import SwiftUI

struct TimerView: View {
    var stopWatch: StopWatch
    @State private var countUpDuration = "---"
    @State private var countDownDuration = "---"
    @State private var timeStarted = Date()
    private var timeEnd: Date {return timeStarted.addingTimeInterval(stopWatch.length)}
    @State private var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var isTimerRunning = false
    
    @Binding var scrollID: StopWatch.ID?
    @Binding var stopWatchCompleted: Bool
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("\(stopWatch.name)")
                Text("own ID: \(stopWatch.id)")
                Text("scroll ID: \(scrollID ?? UUID())")
                Text("\(countUpDuration)")
                    .font(Font.custom("Quicksand", size: 40))
                    .padding()
                Text("\(countDownDuration)")
                    .font(Font.custom("Quicksand", size: 20))
                    .foregroundStyle(.white)
                    .padding()
                Spacer()
            }
            Spacer()
        }
        .containerRelativeFrame(.vertical)
        .background(Color.teal)
        .onReceive(timer){ time in
            if isTimerRunning {
                if time >= timeEnd {
                    stopWatchCompleted = true
                    stopTimer()
                    return
                }
                countUpDuration = secondFormatter(timeInterval: time.timeIntervalSince(timeStarted))
                countDownDuration = secondFormatter(timeInterval: timeEnd.timeIntervalSince(time))
            }
            
        }
        .onChange(of: scrollID) { oldValue, newValue in
            if newValue == stopWatch.id{
                startTimer()
            } else {
                if isTimerRunning{
                    stopTimer()
                }
            }
        }
    }
    
    private func secondFormatter(timeInterval: Double) -> String {
        let seconds = Int(timeInterval)
        let (h,m,s) = (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        return "\(String(format: "%02d",h)):\(String(format: "%02d",m)):\(String(format: "%02d",s))"
    }
    
    private func startTimer(){
        timeStarted = Date()
        timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
        isTimerRunning = true
    }
    private func stopTimer(){
        timer.upstream.connect().cancel()
        countUpDuration = "---"
        countDownDuration = "---"
        isTimerRunning = false
    }
}

#Preview {
    TimerView(stopWatch: StopWatch(name: "One", length:10.0), scrollID: .constant(UUID()), stopWatchCompleted: .constant(false))
}
