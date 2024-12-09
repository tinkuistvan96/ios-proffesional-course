//
//  PasswordStatusView.swift
//  Password
//
//  Created by Tinku István on 09/12/2024.
//

import UIKit

class PasswordStatusView: UIView {
    
    private let stackView = UIStackView()
    private let criteriaLabel = UILabel()
    private let lengthCriteriaView = PasswordCriteriaView(text: "8-32 characters (no spaces)")
    private let uppercaseCriteriaView = PasswordCriteriaView(text: "uppercase letter (A-Z)")
    private let lowercaseCriteriaView = PasswordCriteriaView(text: "lowercase letter (a-z)")
    private let numberCriteriaView = PasswordCriteriaView(text: "digit (0-9)")
    private let specialCharacterCriteriaView = PasswordCriteriaView(text: "special character (e.g. !@#$%^)")
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
}

extension PasswordStatusView {
    private func style() {
        backgroundColor = .tertiarySystemFill
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 5
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalCentering
        
        criteriaLabel.attributedText = makeCriteriaAttributedText()
        criteriaLabel.numberOfLines = 0
        criteriaLabel.lineBreakMode = .byWordWrapping
    }
    
    private func makeCriteriaAttributedText() -> NSAttributedString {
        let plainTextAttributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.preferredFont(forTextStyle: .subheadline),
            .foregroundColor : UIColor.secondaryLabel
        ]
        
        let boldTextAttributes: [NSAttributedString.Key : Any] = [
            .font : UIFont.preferredFont(forTextStyle: .subheadline),
            .foregroundColor : UIColor.label
        ]
        
        let mutableAttributedText = NSMutableAttributedString()
        mutableAttributedText.append(NSAttributedString(string: "Use at least ", attributes: plainTextAttributes))
        mutableAttributedText.append(NSAttributedString(string: "3 of these 4", attributes: boldTextAttributes))
        mutableAttributedText.append(NSAttributedString(string: " criteria when setting your password:", attributes: plainTextAttributes))
        
        return mutableAttributedText
    }
    
    private func layout() {
        stackView.addArrangedSubview(lengthCriteriaView)
        stackView.addArrangedSubview(criteriaLabel)
        stackView.addArrangedSubview(uppercaseCriteriaView)
        stackView.addArrangedSubview(lowercaseCriteriaView)
        stackView.addArrangedSubview(numberCriteriaView)
        stackView.addArrangedSubview(specialCharacterCriteriaView)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 2)
        ])
    }
}
