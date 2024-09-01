//
//  NetworkLayerUnitTest.swift
//  NewsAppTests
//
//  Created by Metehan Gürgentepe on 1.09.2024.
//

import XCTest
@testable import NewsApp

// Mock URLSession and URLProtocol
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Request handler is not set.")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}

final class HTTPClientTests: XCTestCase {
    
    var httpClient: HTTPClient!
    var mockSession: URLSession!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
        httpClient = HTTPClient(session: mockSession)
    }

    override func tearDownWithError() throws {
        httpClient = nil
        mockSession = nil
    }

    func test_load_successfulResponse() async throws {
        let expectedData = """
        {
          "status": "ok",
          "totalResults": 74,
          "articles": [
            {
                  "source": {
                    "id": null,
                    "name": "Macitynet.it"
                  },
                  "author": "Antonio Dini",
                  "title": "Steve Jobs e il collasso del mercato delle fotocamere",
                  "description": "Il co-fondatore di Apple vide qualcosa che forse nessun altro aveva visto. E lo vide molto, molto tempo prima\n- su macitynet.it Steve Jobs e il collasso del mercato delle fotocamere",
                  "url": "https://www.macitynet.it/steve-jobs-e-il-collasso-del-mercato-delle-fotocamere/",
                  "urlToImage": "https://www.macitynet.it/wp-content/uploads/2024/08/fotocamerainmano.jpg",
                  "publishedAt": "2024-08-31T09:14:06Z",
                  "content": "Sono passati molti anni dalla scomparsa di Steve Jobs. Sono stati scritti altri libri su di lui, è stata aperta una fondazione online a suo nome grazie alla vedova, e in generale il ricordo del co-fo… [+5727 chars]"
                }
        ]
        }
        """.data(using: .utf8)!
        
        let expectedResponse = HTTPURLResponse(url: URL(string: Constants.mockURL)!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)!
        
        MockURLProtocol.requestHandler = { _ in
            return (expectedResponse, expectedData)
        }
        
        let resource = Resource(url: URL(string: Constants.mockURL)!,
                                path: .headlines,
                                modelType: Article.self)
        
        // When
        let result = try await httpClient.load(resource)
        
        // Then
        XCTAssertEqual(result.articles.first?.title, "Steve Jobs e il collasso del mercato delle fotocamer")
    }
    
    func test_load_unauthorizedResponse() async throws {
        // Given
        let expectedResponse = HTTPURLResponse(url: URL(string: Constants.mockURL)!,
                                               statusCode: 401,
                                               httpVersion: nil,
                                               headerFields: nil)!

        MockURLProtocol.requestHandler = { _ in
            return (expectedResponse, Data())
        }

        let resource = Resource(url: URL(string: Constants.mockURL)!,
                                path: .headlines,
                                modelType: Article.self)

        // When
        do {
            _ = try await httpClient.load(resource)
            XCTFail("Expected to throw, but succeeded.")
        } catch {
            // Then
            XCTAssertEqual(error as? NetworkError, NetworkError.unauthorized)
        }
    }

    
    func test_load_decodingError() async throws {
        // Given
        let invalidData = "Invalid JSON".data(using: .utf8)!
        
        let expectedResponse = HTTPURLResponse(url: URL(string: Constants.mockURL)!,
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)!
        
        MockURLProtocol.requestHandler = { _ in
            return (expectedResponse, invalidData)
        }
        
        let resource = Resource(url: URL(string: Constants.mockURL)!,
                                path: .headlines,
                                modelType: Article.self)
        
        // When
        do {
            _ = try await httpClient.load(resource)
            XCTFail("Expected decodingError, but succeeded.")
        } catch {
            // Then
            if case NetworkError.decodingError(_) = error {
                // Success
            } else {
                XCTFail("Expected decodingError, but got \(error)")
            }
        }
    }

}

