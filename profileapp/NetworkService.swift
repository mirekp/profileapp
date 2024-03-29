//
//  NetworkService.swift
//  profileapp
//
//  Created by Mirek Petricek on 21/08/2019.
//  Copyright © 2019 Dependency Injection. All rights reserved.
//

import Foundation

class NetworkService {
    enum Errors: Error {
        case unparseableData(_ underlyingError: Error?)
        case httpError
        case networkError(_ underlyingError: Error?)
    }
    
    let session: URLSession
    let getProfileEndpoint: URL
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
        guard let getProfileEndpoint = URL(string: "https://gist.githubusercontent.com/mirekp/afb5bf6c4b843dae279845bf85036a26/raw") else {
            fatalError("API endpoint not configured correctly")
        }
        self.getProfileEndpoint = getProfileEndpoint
    }
    
    func getProfile(_ completion: @escaping (Result<Profile, Errors>) -> Void) {
        // hook for data injection in UI test mode
        if let reply = ProcessInfo.processInfo.environment["getProfile-reply"], let data = Data(base64Encoded: reply) {
            do {
                let profile = try decodeProfile(data)
                completion(.success(profile))
            } catch(let error) {
                completion(.failure(.unparseableData(error)))
            }
            return
        }
        
        session.dataTask(with: getProfileEndpoint) { (data, response, error) in
            // let's call the receiver on the main thread as this is what they likely expect
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(.networkError(error)))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        completion(.failure(.httpError))
                        return
                }
                do {
                    let profile = try self.decodeProfile(data)
                    completion(.success(profile))
                } catch(let error) {
                    completion(.failure(.unparseableData(error)))
                }
            }
            }.resume()
    }
    
    private func decodeProfile(_ data: Data) throws -> Profile {
        return try JSONDecoder().decode(Profile.self, from: data)
    }
}
