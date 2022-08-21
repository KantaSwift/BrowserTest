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
    private var progressBar: UIProgressView!
    private let customTabBar = CustomTabBar()
    private var observation: NSKeyValueObservation?
    
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
        
        customTabBar.delegate = self
        
        NavConfigure()
        setupViews()
    }
    
    
    // MARK: Methods
    
    private func googleSearch(search: String) {
        
        guard let url = URL(string: "https://www.google.com/search?q=\(search)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        
        setupProgressBar()
        reloadObservation()
    }
    
    
    private func reloadObservation() {
        observation = webView.observe(\.estimatedProgress, options: .new){_, change in
            //            print("\(String(describing: change.newValue))")
            self.progressBar.setProgress(Float(change.newValue!), animated: true)

            if change.newValue == 1.0 {
                UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseIn], animations: { self.progressBar.alpha = 0.0 }, completion: { (finished: Bool) in
                    self.progressBar.setProgress(0.0, animated: true) } )
            }
            else {
                self.progressBar.alpha = 1.0
            }
        }
        
    }
    
    private func setupProgressBar() {
        
        progressBar = UIProgressView()
        view.addSubview(progressBar)
        
        progressBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
    }
    
    private func setupViews() {
        
        webView = WKWebView()
        
        view.addSubview(webView)
        view.addSubview(customTabBar)

        webView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        customTabBar.anchor(height: 50)
        customTabBar.anchor(top: webView.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
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


// MARK: - DelegateMethods
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
        searchBar.resignFirstResponder() // <- あまりよくわかっていない
        SearchListTableView.removeFromSuperview()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        googleSearch(search: searchBar.text ?? "")
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        SearchListTableView.removeFromSuperview()
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
        googleSearch(search: suggest[indexPath.row])
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        SearchListTableView.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 20))
        label.textAlignment = .center
        label.text = "Google検索"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }
    
}


extension HomeViewController: CustomTabBarButtonDelegate {
    
    func backButtonDidTap() {
        webView.goBack()
    }
    
    func forwardButtonDidTap() {
        webView.goForward()
    }
    
    func shareButtonDidTap() {
        print("タップされました")
    }
    
    func logButtonDidTap() {
        print("タップされました")
    }
    
    func addTabButtonDidTap() {
        print("タップされました")
    }
    
}
