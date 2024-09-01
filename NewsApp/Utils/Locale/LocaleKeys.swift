//
//  LocaleKeys.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 1.09.2024.
//

import Foundation

struct LocaleKeys {
    
    enum Home: String {
        case selectDate = "home_select_date"
        case from = "home_from"
        case to = "home_to"
        case done = "home_done"
        case cancel = "home_cancel"
        case searchField = "home_search_field"
    }
    
    enum Tab: String {
        case Home = "tab_home"
        case Favorites = "tab_favorites"
    }
    
    enum Error: String {
        case error = "error"
        case okButton = "okButton"
        case badRequest = "badRequestError"
        case unauthorized = "unauthorizedError"
        case forbidden = "forbiddenError"
        case notFound = "notFoundError"
        case serverError = "serverError"
        case decodingError = "decodingError"
        case invalidResponse = "invalidResponse"
        case unknownStatusCode = "unknownStatusCodeError"
    }
    
    enum Favorites: String{
        case favorites = "favorites_title"
    }
}

extension String{
    func locale() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
