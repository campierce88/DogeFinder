//
//  BreedsAPI.swift
//  DogeFinder
//
//  Created by Cameron Pierce on 2/4/18.
//  Copyright © 2018 Cameron Pierce. All rights reserved.
//

import Foundation
import Alamofire

class BreedsAPI: APIClient {

    internal func getBreeds(completion: @escaping ([Breed]) -> Void, failure: @escaping FailureBlock) {
        let url = requestUrl(for: "\(BreedsUrl)/list/all")

        super.sendRequest(withURL: url, requestMethod: HTTPMethod.get, completion: { json in
            if let responseJSON = json as? JSONDictionary, let status = responseJSON["status"] as? String, status == "success", let breedsJSON = responseJSON["message"] as? JSONDictionary {
                var breeds = [Breed]()
                for (key, value) in breedsJSON {
                    let subBreeds = value as? [String] ?? [""]
                    for subBreed in subBreeds {
                        let breed = Breed(with: key, and: subBreed)
                        breeds.append(breed)
                    }
                }
                completion(breeds)
            }
        }) { (response, error) in
            print("error getting dog breeds: \(String(describing: error?.localizedDescription))")
            failure(response, error)
        }
    }

    internal func getBreedImages(for breed: Breed, completion: @escaping (Breed) -> Void, failure: @escaping FailureBlock) {
        var urlRequestString = BreedUrl + "/"
        if let name = breed.name {
            urlRequestString += "\(name)/"
        }
        if let subname = breed.subname {
            urlRequestString += "\(subname)/"
        }
        urlRequestString += "images"
        let url = requestUrl(for: urlRequestString)

        super.sendRequest(withURL: url, requestMethod: HTTPMethod.get, completion: { json in
            if let responseJSON = json as? JSONDictionary, let status = responseJSON["status"] as? String, status == "success", let imagesJSON = responseJSON["message"] as? [String] {
                breed.imageUrls = imagesJSON
                completion(breed)
            }
        }) { (response, error) in
            print("error getting breed images: \(String(describing: error?.localizedDescription))")
            failure(response, error)
        }
    }
}

