//
//  Networking.swift
//  UserAuthTask
//
//  Created by Lukasz Dziwosz on 22/08/2021.
//
protocol UserDataDelegate {
    func didGetData (_ userData: User)
}
import Foundation


class Networking {
    
    var delegate: UserDataDelegate?
    
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
        
        handleTokenResponse(for: request, completion: completion)
    }
    func handleTokenResponse(for request: URLRequest,
                        completion: @escaping (Result<Tokens, Error>) -> Void) {
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                
                guard let unwrappedResponse = response as? HTTPURLResponse else {
                    completion(.failure(NetworkingError.badResponse))
                    return
                }
                //  print(unwrappedResponse.statusCode)
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
    func requestUser(endpoint: String, token: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(NetworkingError.badUrl))
            return
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        handleUserResponse(for: request, completion: completion)
    }
    func handleUserResponse(for request: URLRequest,
                        completion: @escaping (Result<User, Error>) -> Void) {
        
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
                    print("failure")// send refresh token here
                }
               
                if let unwrappedError = error {
                    completion(.failure(unwrappedError))
                  
                    return
                }
                
                if let unwrappedData = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                        print(json)
                        
                        if let userData = try? JSONDecoder().decode(User.self, from: unwrappedData) {
                            completion(.success(userData))
                            self.delegate?.didGetData(userData)
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
