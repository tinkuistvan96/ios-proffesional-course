//
//  AccountSummaryCell.swift
//  Bankey
//
//  Created by Tinku István on 2022. 02. 07..
//

import UIKit


class AccountSummaryCell: UITableViewCell {
    
    enum AccountType: String {
        case Banking, CreditCard, Investment
    }
    
    struct ViewModel {
        let accountType: AccountType
        let accountName: String
        let balance: Decimal
        
        var balanceAsAttributedString: NSAttributedString {
            return CurrencyFormatter().makeAttributedCurrency(balance)
        }
    }
    
    let viewModel: ViewModel? = nil
    
    let typeLabel = UILabel()
    let underlineView = UIView()
    let nameLabel = UILabel()
    let balancedStackView = UIStackView()
    let balanceLabel = UILabel()
    let balanceAmountLabel = UILabel()
    let chevronImageView = UIImageView()
    
    static let reuseIdentifier = "AccountSummaryCell"
    static let rowHeight: CGFloat = 112
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AccountSummaryCell {
    
    private func setup() {
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        typeLabel.adjustsFontForContentSizeCategory = true
        typeLabel.text = "Account Type"
        
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = appColor
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.text = "Account name"
        
        balancedStackView.translatesAutoresizingMaskIntoConstraints = false
        balancedStackView.axis = .vertical
        balancedStackView.spacing = 0
        
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.text = "Some balance"
        balanceLabel.textAlignment = .right
        balanceLabel.font = UIFont.preferredFont(forTextStyle: .body)
        balanceLabel.adjustsFontForContentSizeCategory = true
        
        balanceAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceAmountLabel.text = "$XXX,XXX.XX"
        balanceAmountLabel.textAlignment = .right
        balanceAmountLabel.adjustsFontForContentSizeCategory = true
        
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        let chevronImage = UIImage(systemName: "chevron.right")!.withTintColor(appColor, renderingMode: .alwaysOriginal)
        chevronImageView.image = chevronImage
        
        contentView.addSubview(typeLabel)
        contentView.addSubview(underlineView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(balancedStackView)
        balancedStackView.addArrangedSubview(balanceLabel)
        balancedStackView.addArrangedSubview(balanceAmountLabel)
        contentView.addSubview(chevronImageView)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            typeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            
            underlineView.heightAnchor.constraint(equalToConstant: 4),
            underlineView.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor),
            underlineView.topAnchor.constraint(equalToSystemSpacingBelow: typeLabel.bottomAnchor, multiplier: 1),
            underlineView.widthAnchor.constraint(equalToConstant: 60),
            
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: underlineView.bottomAnchor, multiplier: 2),
            nameLabel.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor),
            
            trailingAnchor.constraint(equalToSystemSpacingAfter: balancedStackView.trailingAnchor, multiplier: 4),
            balancedStackView.leadingAnchor.constraint(equalToSystemSpacingAfter: nameLabel.trailingAnchor, multiplier: 4),
            balancedStackView.topAnchor.constraint(equalToSystemSpacingBelow: underlineView.bottomAnchor, multiplier: 0),
            
            trailingAnchor.constraint(equalToSystemSpacingAfter: chevronImageView.trailingAnchor, multiplier: 1),
            chevronImageView.topAnchor.constraint(equalToSystemSpacingBelow: underlineView.bottomAnchor, multiplier: 1)
        ])
    }
}

extension AccountSummaryCell {
    func configure(with vm: ViewModel) {
        typeLabel.text = vm.accountType.rawValue
        nameLabel.text = vm.accountName
        balanceAmountLabel.attributedText = vm.balanceAsAttributedString
        
        switch vm.accountType {
            
        case .Banking:
            underlineView.backgroundColor = appColor
            balanceLabel.text = "Current balance"
        case .CreditCard:
            underlineView.backgroundColor = .systemOrange
            balanceLabel.text = "Current balance"
        case .Investment:
            underlineView.backgroundColor = .systemPurple
            balanceLabel.text = "Value"
        }
    }
}
