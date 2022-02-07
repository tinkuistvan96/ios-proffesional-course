//
//  DecimalUtils.swift
//  Bankey
//
//  Created by Tinku István on 2022. 02. 08..
//

import Foundation

extension Decimal {
    var doubleValue : Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
