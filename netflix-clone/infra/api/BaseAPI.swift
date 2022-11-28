//
//  BaseAPI.swift
//  netflix-clone
//
//  Created by Rony on 17/11/22.
//

import Foundation

class BaseAPI {
    private let baseURL: String;
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    internal func prepareRequest(path: String, queryItems: [URLQueryItem] = []) -> URLRequest {
        var url = URL(string: self.baseURL)!
        url.append(path: path)
        url.append(queryItems: queryItems)
        return URLRequest(url: url)
    }

    internal func executeRequest(request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        try self.handleResponse(response: response as! HTTPURLResponse, data: data)
        return data
    }

    private func handleResponse(response: HTTPURLResponse, data: Data) throws {
        let statusCode = response.statusCode
        if statusCode >= 400 {
            let dict = try JSONSerialization.jsonObject(
                with: data,
                options: .allowFragments
            ) as! [String: Any]
            if let reason = dict["status_message"] {
                throw Error(message: "\(reason)")
            }
            throw Error.unexpectedError()
        }
    }
}
