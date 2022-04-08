//
//  URLSession+RM.swift
//  Rich n Morty
//
//  Created by Kevin on 2022-04-06.
//

import UIKit

extension URLSession {
    typealias URLSessionCompletionHandler = (Result<Data, URLSessionError>) -> ()
    
    enum URLSessionError: Error {
        case connectionError(Error)
        case responseMissing
        case invalidStatusCode(Int)
        case dataMissing
        
        var errorMessage: String {
            var message = ""
            switch self {
            case .connectionError(let error):
                message = "Connection error: (\(error.localizedDescription)"
            case .responseMissing,
                    .dataMissing:
                message = "URLRequest failed to receive any data"
            case .invalidStatusCode(let code):
                message = "URLRequest received status code: (\(code)"
            }
            return message
        }
    }
    
    func request(with request: URLRequest, completionHandler: URLSessionCompletionHandler?) {
        let task = self.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler?(.failure(.connectionError(error)))
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler?(.failure(.responseMissing))
                return
            }
            
            guard (200...299) ~= response.statusCode else {
                completionHandler?(.failure(.invalidStatusCode(response.statusCode)))
                return
            }
            
            guard let data = data else {
                completionHandler?(.failure(.dataMissing))
                return
            }

            completionHandler?(.success(data))
        }
        task.resume()
    }
}
