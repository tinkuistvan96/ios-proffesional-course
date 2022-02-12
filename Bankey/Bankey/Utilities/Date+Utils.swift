//
//  Date+Utils.swift
//  Bankey
//
//  Created by Tinku István on 2022. 02. 12..
//

import Foundation


extension Date {
    var monthDayYearString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM d, yyyy"
        return dateFormatter.string(from: self)
    }
}
