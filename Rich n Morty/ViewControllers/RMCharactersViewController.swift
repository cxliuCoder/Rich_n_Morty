//
//  RMCharactersViewController.swift
//  Rich n Morty
//
//  Created by Kevin on 2022-04-06.
//

import UIKit

class RMCharactersViewController: UIViewController {
    
    var tableView: UITableView?
    var viewModel: RMListViewModel?
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCharacters = [CharacterModel]()
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && isSearchBarEmpty == false
    }
    
    let emptyTableLabel = UILabel()
    
    init(_ vm: RMListViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel = vm
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup Nav bar
        setNaviBar()
        
        self.view.backgroundColor = .white
        
        // bind with VM so character list change will
        // trigger and updateHanlder
        viewModel?.stateUpdateHandler = { [weak self] state in
            guard let self = self else {
                print("[RMCharactersViewController] self was destroyed")
                return
            }
            self.didReceiveNewState(state)
        }
        
        // empty table label
        setupEmptyTableLabel()
        
        // init tableView
        let table = UITableView(frame: CGRect.zero)
        table.delegate = self
        table.dataSource = self
        tableView = table
        
        // setup table
        setupTable()
        
        // setup searchBar
        setupSearchBar()
        
        // first fetch data
        fetchCharacters()
    }
    
    func fetchCharacters(with count: Int = Constants.fetchCharactersCount) {
        performTaskOnMainThread { [weak self] in
            if let tableView = self?.tableView,
               let viewModel = self?.viewModel {
                // unhide the tableview so user can see the loading progress
                tableView.isHidden = false
                
                viewModel.fetchCharacters(count: count)
            }
        }
    }
    
    /// Display error message with only OK button
    func displayErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // toggle for display tableview when whether tableView is empty or not
    private func setEmptyTableView(isEmpty: Bool) {
        if isEmpty {
            self.emptyTableLabel.isHidden = false
            self.tableView?.isHidden = true
        } else {
            self.emptyTableLabel.isHidden = true
            self.tableView?.isHidden = false
        }
    }
}
    
// MARK: private methods
extension RMCharactersViewController {
    private func setupTable() {
        if let tableView = tableView {
            // init tableView
            tableView.frame = view.frame
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            
            // register cells
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
            
            // hide separator
            tableView.separatorStyle = .none
        }
    }
    
    /// Navigation bar items with action menu
    private func setNaviBar() {
        // Set title
        navigationItem.title = "Characters"
        
        // set background color
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        
        navigationController?.navigationBar.tintColor = .label
        
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        
    }
    
    // setup empty table label
    private func setupEmptyTableLabel() {
        emptyTableLabel.frame = CGRect(x: 0,
                                       y: 0,
                                       width: view.frame.size.width - (Constants.emptyTableLabelSidePadding * 2),
                                       height: Constants.emptyTableLabelHeight)
        emptyTableLabel.center = view.center
        emptyTableLabel.autoresizingMask = .flexibleWidth
        emptyTableLabel.text = Constants.emptyTableLabelText
        emptyTableLabel.numberOfLines = 0
        emptyTableLabel.lineBreakMode = .byWordWrapping
        emptyTableLabel.isHidden = true
        emptyTableLabel.textAlignment = .center
        view.addSubview(emptyTableLabel)
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchBarHint
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func didReceiveNewState(_ state: RMListViewModel.RMListStates) {
        // refresh UI in the end
        defer {
            self.performTaskOnMainThread { [weak self] in
                if let self = self,
                   let tableView = self.tableView {
                    tableView.reloadData()
                }
            }
        }
        // reset emptyTableLabel visibility
        self.performTaskOnMainThread { [weak self] in
            self?.setEmptyTableView(isEmpty: false)
        }
        
        switch state {
        case .charactersUpdated(let characters):
            if characters.count > 0 {
                print("[RMCharactersViewController] State updated with [\(characters.count)] characters")
            } else {
                fallthrough
            }
        case .emptyList:
            print("[RMCharactersViewController] State updated with empty characters")
            self.performTaskOnMainThread { [weak self] in
                self?.setEmptyTableView(isEmpty: true)
            }
        case .displayAlert(let errorMessage):
            print("[RMCharactersViewController] State updated with error:\n\(errorMessage)")
            self.performTaskOnMainThread { [weak self] in
                self?.setEmptyTableView(isEmpty: true)
                self?.displayErrorAlert(title: Constants.defaultErrorTitle, message: errorMessage)
            }
        }
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        if let viewModel = viewModel {
            filteredCharacters = viewModel.characters.filter { (character: CharacterModel) -> Bool in
                return character.name.lowercased().contains(searchText.lowercased())
            }
            
            // display empty table if no result after filtering
            if filteredCharacters.isEmpty && searchText.count > 0 {
                print("[RMCharactersViewController] No characters was found based on searchText")
                setEmptyTableView(isEmpty: true)
            } else {
                if searchText.count > 0 {
                    print("[RMCharactersViewController] [\(filteredCharacters.count)] characters was found based on searchText")
                } else {print("[RMCharactersViewController] Original characters list displayed")
                }
                setEmptyTableView(isEmpty: false)
                self.tableView?.reloadData()
            }
        }
    }
}

// MARK: TableView delegate methods

extension RMCharactersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredCharacters.count : (viewModel?.characters.count ?? 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var characterCell: RMCharacterTableViewCell
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? RMCharacterTableViewCell {
            characterCell = cell
        } else {
            characterCell = RMCharacterTableViewCell(style: .subtitle, reuseIdentifier: Constants.cellIdentifier)
        }
        
        // render cell with model
        if let characters = isFiltering ? filteredCharacters : viewModel?.characters,
           characters.isEmpty == false {
            let characterModel = characters[indexPath.row]
            characterCell.apply(with: characterModel)
        }
        
        return characterCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // get character model
        if let characters = isFiltering ? filteredCharacters : viewModel?.characters,
           characters.isEmpty == false {
            let characterModel = characters[indexPath.row]
            
            // display detail VC
            let detailVC = RMDetailViewController(with: characterModel)
            let navController = UINavigationController(rootViewController: detailVC)
            
            self.present(navController, animated: true)
        }
        
    }
}

extension RMCharactersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let searchText = searchBar.text {
            filterContentForSearchText(searchText)
        }
    }
}

extension RMCharactersViewController {
    struct Constants {
        static let cellIdentifier = "characterCell"
        static let emptyViewCellIdentifier = "emptyViewCell"
        
        static let fetchCharactersCount = 20
        static let defaultErrorTitle = "An error has occured"
        static let emptyTableLabelSidePadding: CGFloat = 40
        static let emptyTableLabelHeight: CGFloat = 100
        static let emptyTableLabelText = "There is no character found."
        
        static let searchBarHint = "Search Characters by Name"
    }
}
