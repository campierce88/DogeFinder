//
//  APIClient.swift
//  DogeFinder
//
//  Created by Cameron Pierce on 2/4/18.
//  Copyright © 2018 Cameron Pierce. All rights reserved.
//

import Foundation
import Alamofire

public typealias CompletionBlock = (JSONObject?) -> Void
public typealias FailureBlock = (URLResponse?, Error?) -> Void
public typealias ProgressBlock = (Float) -> Void

struct APIError: Error {
    let message: String
    let code: String
}

public class APIClient: NSObject {

    class var swiftSharedInstance: APIClient {
        struct Singleton {
            static let instance = APIClient()
        }
        return Singleton.instance
    }

    class var shared: APIClient {
        get {
            return APIClient.swiftSharedInstance
        }
    }

    var urlComponents: URLComponents {
        get {
            var components = URLComponents()
            components.scheme = "https"
            components.host = apiBaseUrl
            return components
        }
    }

    func requestUrl(for endpoint: String, withQueryParams params: [URLQueryItem]? = nil) -> URL {
        var urlComponents = self.urlComponents
        urlComponents.path = endpoint
        urlComponents.queryItems = params
        return urlComponents.url!
    }

    func sendRequest(withURL url: URL, requestMethod method: HTTPMethod, parameters: JSONDictionary? = nil, encoding: ParameterEncoding? = URLEncoding.default, completion: @escaping CompletionBlock, failure: @escaping FailureBlock) {

        var headers: HTTPHeaders = ["content-type": "application/x-www-form-urlencoded"]
        if let _ = encoding as? JSONEncoding {
            headers = ["content-type": "application/json; charset: utf-8"]
        }

        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .response { response in
                if let error = response.error {
                    failure(response.response, error)
                }
            }.responseJSON { response in
                if let error = response.result.error {
                    failure(response.response, error)
                } else if let responseJSON = response.result.value as? JSONDictionary, let error = responseJSON["error"] as? JSONDictionary, let description = error["description"] as? String, let code = error["code"] as? String {
                    failure(response.response, APIError(message: description, code: code))
                } else {
                    completion(response.result.value)
                }
        }
    }
}

