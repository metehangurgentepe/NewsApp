//
//  UserDefaultsManager.swift
//  NewsApp
//
//  Created by Metehan Gürgentepe on 31.08.2024.
//

import Foundation

class UserDefaultsManager {
    let defaults = UserDefaults.standard
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    static let shared = UserDefaultsManager()
    
    func addToFav(news: ArticleElement) throws{
        if let savedNews = defaults.object(forKey: "news") as? Data {
            do {
                var arr = try decoder.decode([ArticleElement].self, from: savedNews)
                arr.append(news)
                let data = try encoder.encode(arr)
                defaults.setValue(data, forKey: "news")
            } catch {
                throw(NetworkError.decodingError(error))
            }
        } else {
            var arr = [ArticleElement]()
            arr.append(news)
            let data = try encoder.encode(arr)
            defaults.setValue(data, forKey: "news")
        }
    }
    
    func removeToFav(news: ArticleElement) throws{
        if let savedNews = defaults.object(forKey: "news") as? Data {
            do {
                var arr = try decoder.decode([ArticleElement].self, from: savedNews)
                if let index = arr.firstIndex(of: news) {
                    arr.remove(at: index)
                    let data = try encoder.encode(arr)
                    defaults.setValue(data, forKey: "news")
                }
            } catch {
                throw(NetworkError.decodingError(error))
            }
        }
    }
    
    func checkIsAddedToFav(news: ArticleElement) throws -> Bool {
        if let savedNews = defaults.object(forKey: "news") as? Data {
            do {
                let arr = try decoder.decode([ArticleElement].self, from: savedNews)
                
                for element in arr {
                    if element == news {
                        return true
                    }
                }
                return false
            } catch {
                throw(NetworkError.decodingError(error))
            }
        }
        
        return false
    }
    
    func getFavNews() throws -> [ArticleElement]? {
        if let savedNews = defaults.object(forKey: "news") as? Data {
            do {
                return try decoder.decode([ArticleElement].self, from: savedNews)
            } catch {
                throw(NetworkError.decodingError(error))
            }
        }
        return nil
    }
}
