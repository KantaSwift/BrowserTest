//
//  CustomButton.swift
//  BrowserTest
//
//  Created by 上條栞汰 on 2022/08/20.
//

import UIKit

class CustomButton: UIButton {
    
    init(imageName: String) {
        super.init(frame: .zero)
        
        setImage(UIImage(systemName: imageName), for: .normal)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
