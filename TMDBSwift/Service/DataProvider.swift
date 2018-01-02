//
//  DataProvider.swift
//  TMDBSwift
//
//  Created by Gerardo on 02/01/2018.
//  Copyright © 2018 crisisGriega. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper


class DataProvider {
    
    static let `default`: DataProvider = DataProvider();
    
    private let apiConnector: TMDBAPIConnector = TMDBAPIConnector();
    
    @discardableResult func discover(page: Int = 1, completion: @escaping (Result<[Movie]>) -> Void) -> DataRequest {
        let args: [String: String] = ["sort_by": "popularity.desc"];
        
        let url = self.apiConnector.urlFor(.discover, resource: .movie, page: page, args: args);
        let request = Alamofire.request(url).responseArray(keyPath: "results") { (response: DataResponse<[Movie]>) in
            completion(response.result);
        }
        
        return request;
    }
    
    @discardableResult func search(_ query: String, page: Int = 1, completion: @escaping (Result<[Movie]>) -> Void) -> DataRequest {
        let args: [String: String] = ["query": query, "sort_by": "popularity.desc"];
        
        let url = self.apiConnector.urlFor(.search, resource: .movie, page: page, args: args);
        let request = Alamofire.request(url).responseArray(keyPath: "results") { (response: DataResponse<[Movie]>) in
            completion(response.result);
        }
        
        return request;
    }
    
    func urlForImagewithPath(_ path: String, size: ImageSize = .medium) -> String {
        return self.apiConnector.urlForImagewithPath(path, size: size);
    }
    
    
}
