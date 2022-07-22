//
//  ViewController.swift
//  BrowserTest
//
//  Created by 上條栞汰 on 2022/07/22.
//

import UIKit
import WebKit
import SnapKit

protocol CustomTabBarDelegate: AnyObject {
    func backButtonDidTap()
    func forwardButtonDidTap()
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    var web = WKWebView()
    var textFiled = UITextField()
    var custom = CustomTabBar(frame: .zero)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
        guard let url = URL(string: "https://google.com") else { return }
        let request = URLRequest(url: url)
        web.load(request)
        // Do any additional setup after loading the view.
    }
    
    func search(search: String) {
        guard let url = URL(string: "https://www.google.com/search?q=\(search)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        let request = URLRequest(url: url)
        web.load(request)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search(search: textField.text ?? "")
        return true
    }
    
    func layout() {
        view.addSubview(web)
        view.addSubview(textFiled)
        view.addSubview(custom)
        textFiled.delegate = self
        custom.delgate = self
        
        textFiled.snp.makeConstraints{
            $0.height.equalTo(30)
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        web.snp.makeConstraints{
            $0.top.equalTo(textFiled.snp.bottom)
            $0.right.left.equalTo(view.safeAreaLayoutGuide)
        }
        
        custom.snp.makeConstraints{
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(web.snp.bottom)
        }
    }
    
}

extension ViewController: CustomTabBarDelegate {
    func backButtonDidTap() {
        web.goBack()
    }
    
    func forwardButtonDidTap() {
        web.goForward()
    }
    
    
}

class CustomTabBar: UIView {
    
    weak var delgate: CustomTabBarDelegate!
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [backButton, forwardButton])
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        return button
    }()
    
    lazy var forwardButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(forwardDidTap), for: .touchUpInside)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.transform = CGAffineTransform(scaleX: -1, y: 1)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    func layout() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints{
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
    
    @objc func backButtonDidTap() {
//        print("タップされました")
        delgate.backButtonDidTap()
    }
    
    @objc func forwardDidTap() {
        delgate.forwardButtonDidTap()
//        print("タップされました")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

