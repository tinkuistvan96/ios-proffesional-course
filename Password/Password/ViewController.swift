//
//  ViewController.swift
//  Password
//
//  Created by Tinku István on 2022. 03. 01..
//

import UIKit

class ViewController: UIViewController {

    let newPasswordTextField = PasswordTextField(placeholderText: "New password")
    let statusView = PasswordStatusView()
    let stackView = UIStackView()
    let confirmPasswordTextField = PasswordTextField(placeholderText: "Re-enter new password")
    let resetButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }

    private func style() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        resetButton.setTitle("Reset Password", for: [])
        resetButton.configuration = .filled()
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    }
    
    private func layout() {
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(newPasswordTextField)
        stackView.addArrangedSubview(statusView)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(resetButton)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func resetButtonTapped() {
        //TODO
    }
}

