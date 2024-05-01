//
//  ContentView.swift
//  LazyTimer
//
//  Created by knp on 28/11/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var stopWatches: [StopWatch] = [
        StopWatch(name: "One", length:5.0),
        StopWatch(name: "Two", length:10.0),
        StopWatch(name: "Three", length:20.0),
    ]
    
    @State private var scrollID: StopWatch.ID?
    @State private var stopWatchCompleted: Bool = false
    
    var body: some View {
//        Text("\(scrollID ?? UUID())")
        ScrollView(.vertical){
            LazyVStack{
                ForEach(stopWatches){ stopWatch in
                    TimerView(stopWatch: stopWatch, scrollID: $scrollID, stopWatchCompleted: $stopWatchCompleted)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $scrollID)
//        .defaultScrollAnchor(.top) //it doesn't update the scrollPosition value
        .onAppear{
            scrollID = stopWatches.first?.id
        }
        .onChange(of: stopWatchCompleted) { oldValue, newValue in
            if newValue {
                scrollToNextID()
                stopWatchCompleted = false
            }
        }
    }
    
    private func scrollToNextID() {
        guard let id = scrollID, id != stopWatches.last?.id,
              let index = stopWatches.firstIndex(where: { $0.id == id })
        else { return }
        
        withAnimation {
            scrollID = stopWatches[index + 1].id
        }
    }
}

struct StopWatch: Identifiable {
    let id = UUID()
    var name: String
    var length = 0.0
}

#Preview {
    ContentView()
}
