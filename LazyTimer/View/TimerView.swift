//
//  TimerView.swift
//  LazyTimer
//
//  Created by knp on 28/11/2023.
//

import SwiftUI

struct TimerView: View {
    var stopWatch: StopWatch
    @State private var duration = "---"
    @State private var timeStarted = Date()
    private var timeEnd: Date {return timeStarted.addingTimeInterval(stopWatch.length)}
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Binding var scrollID: StopWatch.ID?
    @Binding var stopWatchCompleted: Bool
    
    private func updateDuration(_ time: Date) {
        if stopWatch.isCountUp {
            duration = secondFormatter(timeInterval: time.timeIntervalSince(timeStarted))
        }
        else {
            duration = secondFormatter(timeInterval: timeEnd.timeIntervalSince(time))
        }
    }
    
    private func secondFormatter(timeInterval: Double) -> String {
        let seconds = Int(timeInterval.rounded())
        let (h,m,s) = (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        return "\(String(format: "%02d",h)):\(String(format: "%02d",m)):\(String(format: "%02d",s))"
    }
    
    private func startTimer(){
        timeStarted = Date()
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        updateDuration(timeStarted)
        stopWatchCompleted = false
    }
    
    private func stopTimer(){
        timer.upstream.connect().cancel()
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("\(stopWatch.name)")
                Text("own ID: \(stopWatch.id)")
                Text("scroll ID: \(scrollID ?? UUID())")
                Text("\(duration)")
                    .font(Font.custom("Quicksand", size: 60))
                    .padding()
                Spacer()
            }
            Spacer()
        }
        .containerRelativeFrame(.vertical)
        .background(Color.teal)
        .onReceive(timer){ time in
            if scrollID != stopWatch.id{
                stopTimer()
                return
            }
            updateDuration(time)
            if time >= timeEnd {
//                print("\(stopWatch.name):completed")
                stopWatchCompleted = true
                stopTimer()
                return
            }
        }
        .onChange(of: scrollID) { oldValue, newValue in
            if newValue == stopWatch.id{
                startTimer()
            } else {
                stopTimer()
            }
        }
    }
}

#Preview {
    TimerView(stopWatch: StopWatch(time: "One", length:10.0), scrollID: .constant(UUID()), stopWatchCompleted: .constant(false))
}
