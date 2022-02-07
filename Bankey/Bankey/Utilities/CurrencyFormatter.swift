//
//  CurrencyFormatter.swift
//  Bankey
//
//  Created by Tinku István on 2022. 02. 08..
//

import UIKit


struct CurrencyFormatter {
    
    func makeAttributedCurrency(_ amount: Decimal) -> NSMutableAttributedString {
        let tuple = breakIntoDollarsAndCents(amount)
        return makeFormattedBalance(dollars: tuple.0, cents: tuple.1)
    }
    
    //Converts 934,32.621 -> "934,32" and "62"
    func breakIntoDollarsAndCents(_ amount: Decimal) -> (String, String) {
        let tuple = modf(amount.doubleValue)
        
        let dollars = convertDollar(tuple.0)
        let cents = convertCents(tuple.1)
        
        return (dollars, cents)
    }
    
    //Convert 934321 -> 934,321
    private func convertDollar(_ dollarPart: Double) -> String {
        let dollarsWithDecimal = dollarsFormatted(dollarPart)
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        let decimalSeparator = formatter.decimalSeparator!
        let dollarComponents = dollarsWithDecimal.components(separatedBy: decimalSeparator)
        
        var dollars = dollarComponents.first! //$934,321
        dollars.removeFirst() //934,321
        
        return dollars
    }
    
    //Convert 934321 -> $934,321.00
    func dollarsFormatted(_ dollars: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        
        if let result = formatter.string(from: dollars as NSNumber) {
            return result
        }
        
        return ""
    }
    
    //Converts 0.62 -> "62"
    private func convertCents(_ centPart: Double) -> String {
        let cents: String
        if centPart == 0 {
            cents = "00"
        } else {
            cents = String(format: "%.0f", centPart * 100)
        }
        return cents
    }
    
    
    private func makeFormattedBalance(dollars: String, cents: String) -> NSMutableAttributedString {
        let dollarSignAttribute: [NSMutableAttributedString.Key : Any] = [.font : UIFont.preferredFont(forTextStyle: .callout), .baselineOffset : 8]
        let dollarAttribute: [NSMutableAttributedString.Key : Any] = [.font : UIFont.preferredFont(forTextStyle: .title1)]
        let centAttribute: [NSMutableAttributedString.Key : Any] = [.font : UIFont.preferredFont(forTextStyle: .footnote), .baselineOffset : 8]
        
        let rootString = NSMutableAttributedString(string: "$", attributes: dollarSignAttribute)
        let dollarString = NSMutableAttributedString(string: dollars, attributes: dollarAttribute)
        let centString = NSMutableAttributedString(string: cents, attributes: centAttribute)
        
        rootString.append(dollarString)
        rootString.append(centString)
        
        return rootString
    }
}
