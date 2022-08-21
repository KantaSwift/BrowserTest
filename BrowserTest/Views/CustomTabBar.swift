//
//  CustomTabBar.swift
//  BrowserTest
//
//  Created by 上條栞汰 on 2022/08/20.
//

import UIKit

protocol CustomTabBarButtonDelegate {
    func backButtonDidTap()
    func forwardButtonDidTap()
    func shareButtonDidTap()
    func logButtonDidTap()
    func addTabButtonDidTap()
}

class CustomTabBar: UIView {
    
    var delegate: CustomTabBarButtonDelegate?
    
    private let backButton: UIButton = CustomButton(imageName: "chevron.backward")
    private let forwardButton: UIButton = CustomButton(imageName: "chevron.right")
    private let shareButton: UIButton = CustomButton(imageName: "square.and.arrow.up")
    private let logButton: UIButton = CustomButton(imageName: "book")
    private let addTabButton: UIButton = CustomButton(imageName: "square.on.square")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        setupStackView()
        buttonDidTap()
    }
    
    private func buttonDidTap() {
        backButton.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(forwardButtonDidTap), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonDidTap), for: .touchUpInside)
        logButton.addTarget(self, action: #selector(logButtonDidTap), for: .touchUpInside)
        addTabButton.addTarget(self, action: #selector(addTabButtonDidTap), for: .touchUpInside)
    }
    
    
    @objc private func backButtonDidTap() {
        delegate?.backButtonDidTap()
    }
    
    @objc private func forwardButtonDidTap() {
        delegate?.forwardButtonDidTap()
    }
    
    @objc private func shareButtonDidTap() {
        delegate?.shareButtonDidTap()
    }
    
    @objc private func logButtonDidTap() {
        delegate?.logButtonDidTap()
    }
    
    @objc private func addTabButtonDidTap() {
        delegate?.addTabButtonDidTap()
    }
    
    
    private func setupStackView() {
        
        let baseStackView = UIStackView(arrangedSubviews: [backButton, forwardButton, shareButton, logButton, addTabButton])
        baseStackView.axis = .horizontal
        baseStackView.distribution = .fillEqually
        
        addSubview(baseStackView)
        
        baseStackView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
