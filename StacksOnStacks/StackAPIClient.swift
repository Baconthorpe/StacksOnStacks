//
//  StackAPIClient.swift
//  StacksOnStacks
//
//  Created by Ezekiel Abuhoff on 1/11/18.
//  Copyright © 2018 Ezekiel Abuhoff. All rights reserved.
//

import Foundation

class StackAPIClient {
    
    // MARK: Constants
    static let baseURLString = "https://api.stackexchange.com/2.2"
    
    // MARK: Getting Questions
    static func getQuestions(count: Int, completion: @escaping ([Item]) -> ()) {
        
        let urlString = "\(baseURLString)/questions?page=1&pagesize=\(count)&order=desc&sort=activity&site=stackoverflow"
        guard let url = URL(string: urlString) else { report(error: StackAPIError.invalidURL); return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { report(error: error!); return }
            guard let response = response as? HTTPURLResponse else { report(error: StackAPIError.badResponse); return }
            guard let data = data else { report(error: StackAPIError.noData); return }
            
            print(response.statusCode)
            
            let decoder = JSONDecoder()
            do {
                let json = try decoder.decode(ResponseJSON.self, from: data)
                guard let items = json.items else { throw StackAPIError.invalidFormat }
                completion(items)
            } catch {
                report(error: StackAPIError.invalidFormat)
            }
        }.resume()
    }
    
    // MARK: Error Handling
    static func report(error: Error) {
        print("Stack Exchange API Client Error: \(error)")
    }
    
    // MARK: Types
    enum StackAPIError: Error {
        case invalidURL
        case badResponse
        case noData
        case invalidFormat
    }
    
    struct ResponseJSON: Codable {
        let items: [Item]?
    }
    
    struct Item: Codable {
        let title: String?
    }
}
