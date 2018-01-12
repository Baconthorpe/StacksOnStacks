//
//  StackAPIClient.swift
//  StacksOnStacks
//
//  Created by Ezekiel Abuhoff on 1/11/18.
//  Copyright © 2018 Ezekiel Abuhoff. All rights reserved.
//

import Foundation

class StackAPIClient {
    
    static let baseURL = "https://api.stackexchange.com/2.2"
    static let getQuestionsEndpoint = "/questions?page=1&pagesize=20&order=desc&sort=activity&site=stackoverflow"
    
    static func getQuestions(completion: @escaping ([Item]) -> ()) {
        guard let url = URL(string: "\(baseURL)\(getQuestionsEndpoint)") else { return }
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
    
    static func report(error: Error) {
        
    }
}

enum StackAPIError: Error {
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
