//
//  SwiftUICell.swift
//  SwiftUITableView
//
//  Created by insub on 2023/05/22.
//

import SwiftUI

struct CellView: View {
    
    let person: Person
    
    var body: some View {
        HStack(spacing: 8) {
            Text(person.emoji)
            Text(person.name)
            Spacer()
            Text("\(person.age)")
        }
        .frame(height: 60)
        .padding(.horizontal)
        .font(.title2)
    }
}

class SwiftUICell<T: View>: UITableViewCell {
    
    private let hController = UIHostingController<T?>(rootView: nil)
    
    func set(rooteView: T) {
        hController.rootView = rooteView
        
        contentView.addSubview(hController.view)
        hController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            hController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hController.view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            hController.view.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
}
