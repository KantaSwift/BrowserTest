//
//  HomeViewController.swift
//  BrowserTest
//
//  Created by 上條栞汰 on 2022/08/20.
//

import UIKit
import WebKit

class HomeViewController: UIViewController {
    
// MARK: Views
    
    private var searchBar: UISearchBar!
    private var webView: WKWebView!
    private let api = GoogleSuggestion()
    private var suggest = [String]()
    
    private let SearchListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

// MARK: LifeCicleMethods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    
        SearchListTableView.delegate = self
        SearchListTableView.dataSource = self
        
        NavConfigure()
        setupWebView()
    }
    
    
// MARK: Methods
    
    private func googleSearch(search: String) {
        
        guard let url = URL(string: "https://www.google.com/search?q=\(search)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func setupWebView() {
        
        webView = WKWebView()
        
        view.addSubview(webView)
        
        webView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
    
    }
    
    private func setupSearchTableView() {
        
        view.addSubview(SearchListTableView)
        
        SearchListTableView.anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
    }
    
    private func NavConfigure() {
        
        searchBar = UISearchBar()
        searchBar.placeholder = "検索/webサイト名を入力"
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        navigationItem.titleView?.frame = searchBar.frame
    }
    
}


// MARK: - Extensions
extension HomeViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    
        searchBar.showsCancelButton = true
        return true
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        setupSearchTableView()
        
        Task {
            guard let suggestion = try? await api.getSuggestions(searchText: searchBar.text ?? "" ) else { return }
            self.suggest = suggestion
            SearchListTableView.reloadData()
        }
        
        print(suggest)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()  // <- あまりよくわかっていない
        
    }
    
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = suggest[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}
