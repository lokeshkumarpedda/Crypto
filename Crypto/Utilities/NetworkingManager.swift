//
//  NetworkingManager.swift
//  Crypto
//
//  Created by Lokesh on 30/01/22.
//

import Foundation
import Combine

class NetworkingManager{
    
    enum NetworkingError: LocalizedError{
        case badURLResponse
        case unknown
        
        var errorDescription: String?{
            switch self{
            case .badURLResponse: return "[🔥] Bad response from server"
            case .unknown: return "[⚠️] Unknown error"
            }
        }
    }
    
    
    static func makeApiCall(url: URL) -> AnyPublisher<Data,Error>{
         URLSession.shared.dataTaskPublisher(for: url)
//             .tryMap { (output) -> Data in
//                 guard let response = output.response as? HTTPURLResponse,
//                         response.statusCode >= 200,
//                         response.statusCode < 300 else{
//                     throw URLError(.badServerResponse)
//                 }
//                 return output.data
//             }
             .tryMap({ try handleUrlResponse(output:$0, url: url)})
             .retry(2)
             .eraseToAnyPublisher()
    }
    
    static func handleUrlResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
                response.statusCode >= 200,
                response.statusCode < 300 else{
                    throw NetworkingError.badURLResponse
        }
        return output.data
    }
    
    static func handleCompletion(_ completion: Subscribers.Completion<Error>){
        switch completion{
        case .finished:
            break;
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
