//
//  SwiftUITableView.swift
//  SwiftUITableView
//
//  Created by insub on 2023/05/22.
//

import SwiftUI

struct SwiftUITableView<T: Identifiable>: UIViewRepresentable {
    
    typealias UIViewType = UITableView
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    func makeUIView(context: Context) -> UITableView {
        context.coordinator.set()
        return context.coordinator.tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator<T> {
        Coordinator.init(parent: self)
    }
    
    @MainActor
    class Coordinator<T: Identifiable>: NSObject, UITableViewDataSource, UITableViewDelegate {

        let parent: SwiftUITableView
        
        var tableView: UITableView!
        let refreshControl = UIRefreshControl()
        
        init(parent: SwiftUITableView) {
            self.parent = parent
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
                self.parent.viewModel.getMorePeople()
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            parent.viewModel.people.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwiftUICell<CellView>", for: indexPath) as! SwiftUICell<CellView>
            let person = parent.viewModel.people[indexPath.row]
            let view = CellView(person: person)
            cell.set(rooteView: view)
            return cell
        }
    }
}
