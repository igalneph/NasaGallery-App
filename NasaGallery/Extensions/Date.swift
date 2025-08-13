//
//  Date.swift
//  NasaGallery
//
//  Created by Igal on 21/11/2021.
//

import Foundation

extension Date {
    func isEqual(to date: Date) -> Bool {
        let firstComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let secondComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        
        if firstComponents.year == secondComponents.year, firstComponents.month == secondComponents.month, firstComponents.day == secondComponents.day {
            return true
        } else {
            return false
        }
    }
    func convertToString(inFormat format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}
