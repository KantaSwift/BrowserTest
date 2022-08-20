//
//  HomeViewController.swift
//  BrowserTest
//
//  Created by 上條栞汰 on 2022/08/20.
//

import UIKit
import WebKit

class HomeViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "検索/Webサイト名を入力"
        return searchBar
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        return webView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        searchBar.delegate = self
        
        NavConfigure()
        setupLayout()
    }
    
    
    private func setupLayout() {
        
        view.addSubview(webView)
        webView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
    }
    
    private func NavConfigure() {
        
        navigationItem.titleView = searchBar
        navigationItem.titleView?.frame = searchBar.frame
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()  // <- あまりよくわかっていない
    }
    
    
}
