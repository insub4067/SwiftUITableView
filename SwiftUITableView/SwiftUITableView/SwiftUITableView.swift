//
//  SwiftUITableView.swift
//  SwiftUITableView
//
//  Created by insub on 2023/05/22.
//

import SwiftUI

struct SwiftUITableView<T: Identifiable>: UIViewRepresentable {
    
    typealias UIViewType = UITableView
    
    var items: [T]
    let refreshControl = UIRefreshControl()
    
    func makeUIView(context: Context) -> UITableView {
        context.coordinator.set()
        return context.coordinator.tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator<T> {
        Coordinator.init(items: items)
    }
    
    @MainActor
    class Coordinator<T: Identifiable>: NSObject, UITableViewDataSource, UITableViewDelegate {

        var tableView: UITableView!
        let refreshControl = UIRefreshControl()
        var items: [T]
        
        init(items: [T]) {
            self.items = items
        }
        
        func set() {
            tableView = UITableView(frame: .zero, style: .plain)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            tableView.register(SwiftUICell<CellView>.self, forCellReuseIdentifier: "SwiftUICell<CellView>")
            tableView.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(didPullRefresh), for: .valueChanged)
        }
        
        @objc func didPullRefresh() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.items.append(Person(emoji: "🥰", name: "Love", age: 99) as! T)
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            self.items.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwiftUICell<CellView>", for: indexPath) as! SwiftUICell<CellView>
            let view = CellView(person: items[indexPath.row] as! Person)
            cell.set(rooteView: view)
            return cell
        }
    }
}
