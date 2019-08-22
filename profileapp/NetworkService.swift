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
    let getProfileEndpoint = URL(string: "https://gist.githubusercontent.com/mirekp/afb5bf6c4b843dae279845bf85036a26/raw")!
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func getProfile(_ completion: @escaping (Result<Profile, Errors>) -> Void) {
        session.dataTask(with: getProfileEndpoint) { (data, response, error) in
            // let's call the receiver on the main thread as this is what they likely expect
            DispatchQueue.main.async {
                guard let data = data, error == nil, let response = response else {
                    completion(.failure(.networkError(error)))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                        completion(.failure(.httpError))
                        return
                }
                do {
                    let profile = try JSONDecoder().decode(Profile.self, from: data)
                    completion(.success(profile))
                } catch(let exception) {
                    completion(.failure(.unparseableData(exception)))
                }
            }
            }.resume()
    }
}
