//
//  ContentView.swift
//  LazyTimer
//
//  Created by knp on 28/11/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var stopWatches: [StopWatch] = [
        StopWatch(time: "One- time", length:3.0),
        StopWatch(rep: "Two - rep", length:5.0),
        StopWatch(break: "Three - break", length:8.0),
        StopWatch(break: "Four - break", length:10.0)
    ]
    
    @State private var scrollID: StopWatch.ID?
    @State private var stopWatchCompleted: Bool = false
    
    var body: some View {
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
                guard let id = scrollID,
                      let index = stopWatches.firstIndex(where: { $0.id == id })
                else { return }
                if stopWatches[index].isAutoNext {
                    scrollToNextID()
                }
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
    var length: Double
    var isCountUp: Bool
    var isAutoNext: Bool
    var prepTime: Double
    
    init(rep name: String, length: Double){
        self.name = name
        self.length = length
        isCountUp = true
        isAutoNext = false
        prepTime = 0.0
    }
    
    init(time name: String, length: Double){
        self.name = name
        self.length = length
        isCountUp = false
        isAutoNext = true
        prepTime = 3.0
    }
    
    init(break name: String, length: Double){
        self.name = name
        self.length = length
        isCountUp = false
        isAutoNext = true
        prepTime = 0.0
    }
}

#Preview {
    ContentView()
}
