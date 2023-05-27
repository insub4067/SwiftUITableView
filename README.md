# SwiftUITableView

## ⚠️ WARNING
TableViewCell 에 Controller 인 HostingController 를 넣는 시도는 좋지 못한 아이디어였습니다.  
라이프사이클에 혼란을 주고 예측하지 못한 버그를 발생 시킵니다.  

## 💡 Why and What?
SwiftUI 의 List 는 실제로 사용해보면 rows 가 많아질수록 불안하고 예상하기 어려운 버그가 많이 발생합니다.  
그렇기 때문에 List 를 사용하지 않고 RefreshControl, SwipeAction 등을 구현하기 위해서 UIKit 를 래핑한 형태로 SwiftUI 에서 사용할 수 있도록 구현했습니다.

## 📱 Screenshot
<img src="https://github.com/insub4067/SwiftUITableView/assets/85481204/35b42e9b-c9d9-468e-9188-7ed35bb2b339" width="250">
<img src="https://github.com/insub4067/SwiftUITableView/assets/85481204/3302858a-5ac2-4b5e-9891-e4f0895c72a9" width="250">

## 💻 Code
### ✓ SwiftUI Side
```Swift
struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        SwiftUITableView<Person>()
            .environmentObject(viewModel)
            .onAppear {
                viewModel.getPeople()
            }
    }
}
```

### ✓ UIKit Side
```Swift
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
```
