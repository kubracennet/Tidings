//
//  APICaller.swift
//  Tidings
//
//  Created by Kübra Cennet Yavaşoğlu on 14.03.2023.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: //"https://newsapi.org/v2/top-headlines?country=tr&apiKey=5bec51a7bafb4db4836f5c6b3a8cf33c")
                                         "https://newsapi.org/v2/top-headlines?country=us&apiKey=5bec51a7bafb4db4836f5c6b3a8cf33c")
        static let searchUrlString = "https://newsapi.org/v2/everything?sortBy=popularity&apiKey=5bec51a7bafb4db4836f5c6b3a8cf33c&q="
                                        
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                    catch {
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }

    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
      guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
          return
      }
      
     let urltring = Constants.searchUrlString + query
     guard let url = URL(string: urltring) else {
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
        if let error = error {
            completion(.failure(error))
        }
        else if let data = data {
            
            do {
                let result = try JSONDecoder().decode(APIResponse.self, from: data)
                
                print("Articles: \(result.articles.count)")
                completion(.success(result.articles))
            }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

//Models-Api içerisindeki title'lar.

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}

