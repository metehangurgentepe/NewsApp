//
//  HTTPClients+Extensions.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 30.08.2024.
//

import Foundation

extension HTTPClient {
    static var development: HTTPClient {
        return HTTPClient(session: URLSession.shared)
    }
}
