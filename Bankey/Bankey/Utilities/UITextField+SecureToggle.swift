//
//  UITextField+SecureToggle.swift
//  Bankey
//
//  Created by Tinku István on 2022. 02. 08..
//

import Foundation
import UIKit

let showPasswordButton = UIButton(type: .system)

extension UITextField {
    func enablePasswordToggle() {
        showPasswordButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        showPasswordButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        showPasswordButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
        rightView = showPasswordButton
        rightViewMode = .always
    }
    
    @objc func togglePasswordView() {
        isSecureTextEntry.toggle()
        showPasswordButton.isSelected.toggle()
    }
}
