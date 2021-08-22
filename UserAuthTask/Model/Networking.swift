//
//  Networking.swift
//  UserAuthTask
//
//  Created by Lukasz Dziwosz on 22/08/2021.
//

import Foundation


class Networking {
    
    let baseUrl = "https://vidqjclbhmef.herokuapp.com"
    
    func requestToken(endpoint: String,
                 parameters: [String: Any],
                 completion: @escaping (Result<Tokens, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        
        var request = URLRequest(url: url)
        
        var components = URLComponents()
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            
            let queryItem = URLQueryItem(name: key, value: String(describing: value))
            queryItems.append(queryItem)
        }
        
        components.queryItems = queryItems
        
        // username = john.doe@nfq.lt & password = johndoe
        
        let queryItemData = components.query?.data(using: .utf8)
        
        request.httpBody = queryItemData
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        handleResponse(for: request, completion: completion)
    }
    func handleResponse(for request: URLRequest,
                        completion: @escaping (Result<Tokens, Error>) -> Void) {
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                guard let unwrappedResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkingError.badResponse))
                    return
                }
                
                print(unwrappedResponse.statusCode)
                
                switch unwrappedResponse.statusCode {
                    
                case 200 ..< 300:
                    print("success")
                    
                default:
                    print("failure")
                }
                
                if let unwrappedError = error {
                    completion(.failure(unwrappedError))
                    return
                }
                
                if let unwrappedData = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                        print(json)
                        
                        if let tokens = try? JSONDecoder().decode(Tokens.self, from: unwrappedData) {
                            completion(.success(tokens))
                            
                        } else {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: unwrappedData)
                            completion(.failure(errorResponse))
                        }
                        
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        
        task.resume()
    }
}
enum NetworkingError: Error {
    case badUrl
    case badResponse
    case badEncoding
}
