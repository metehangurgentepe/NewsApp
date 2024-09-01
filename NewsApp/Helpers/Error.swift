//
//  Error.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 30.08.2024.
//

import Foundation

enum NetworkError: Error, Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.badRequest, .badRequest),
            (.unauthorized, .unauthorized),
            (.forbidden, .forbidden),
            (.notFound, .notFound),
            (.invalidResponse, .invalidResponse):
            return true
        case (.serverError(let lhsMessage), .serverError(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.decodingError(let lhsError), .decodingError(let rhsError)):
            return (lhsError as NSError) == (rhsError as NSError)
        case (.unknownStatusCode(let lhsCode), .unknownStatusCode(let rhsCode)):
            return lhsCode == rhsCode
        default:
            return false
        }
    }
    
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError(String)
    case decodingError(Error)
    case invalidResponse
    case unknownStatusCode(Int)
}

extension NetworkError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return LocaleKeys.Error.badRequest.rawValue.locale()
        case .unauthorized:
            return LocaleKeys.Error.unauthorized.rawValue.locale()
        case .forbidden:
            return LocaleKeys.Error.forbidden.rawValue.locale()
        case .notFound:
            return LocaleKeys.Error.notFound.rawValue.locale()
        case .serverError(let errorMessage):
            return errorMessage
        case .decodingError:
            return LocaleKeys.Error.decodingError.rawValue.locale()
        case .invalidResponse:
            return LocaleKeys.Error.invalidResponse.rawValue.locale()
        case .unknownStatusCode(let statusCode):
            return "\(LocaleKeys.Error.unknownStatusCode.rawValue.locale()): \(statusCode)"
        }
    }
}
