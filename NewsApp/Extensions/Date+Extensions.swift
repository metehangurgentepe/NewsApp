//
//  Date+Extensions.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 31.08.2024.
//

import Foundation


extension Date {
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
