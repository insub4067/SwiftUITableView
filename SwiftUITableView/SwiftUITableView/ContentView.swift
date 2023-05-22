//
//  ContentView.swift
//  SwiftUITableView
//
//  Created by insub on 2023/05/22.
//

import SwiftUI

struct ContentView: View {
    
    let people: [Person] = [
        .init(emoji: "🤔", name: "Kim", age: 12),
        .init(emoji: "😊", name: "Lee", age: 22),
        .init(emoji: "😃", name: "Park", age: 21),
        .init(emoji: "😇", name: "Woo", age: 18),
        .init(emoji: "😂", name: "Leo", age: 32),
        .init(emoji: "😁", name: "Cho", age: 43),
        .init(emoji: "🥹", name: "Mark", age: 11),
        .init(emoji: "😃", name: "Woody", age: 8)
    ]
    
    var body: some View {
        SwiftUITableView<Person>(items: people)
    }
}

struct Person: Identifiable {
    let id = UUID()
    let emoji: String
    let name: String
    let age: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
