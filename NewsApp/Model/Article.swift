//
//  Article.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 30.08.2024.
//

import Foundation


struct Article: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleElement]
}


struct ArticleElement: Codable, Equatable {
    let author: String?
    let title: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}
