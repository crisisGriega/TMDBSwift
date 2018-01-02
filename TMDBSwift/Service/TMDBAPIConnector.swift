//
//  TMDBAPIConnector.swift
//  TMDBSwift
//
//  Created by Gerardo on 02/01/2018.
//  Copyright © 2018 crisisGriega. All rights reserved.
//

import Foundation


enum APIOperation: String {
    case find;
    case search;
    case discover;
}

enum TMDBEntityType: String {
    case movie;
    case tv;
}

enum ImageSize: String {
    case small = "w342";
    case medium = "w500";
    case large = "w780";
    case fullSize = "original";
}

class TMDBAPIConnector {
    static let `default`: TMDBAPIConnector = TMDBAPIConnector();
    
    lazy private var configuration: NSDictionary = {
        guard
            let envConfig = Bundle.main.infoDictionary?["Configuration"] as? String,
            let apiConfigFilePath = Bundle.main.path(forResource: "APIConfiguration", ofType: "plist"),
            let apiConfigFile = NSDictionary(contentsOfFile: apiConfigFilePath),
            let apiConfigDict = apiConfigFile.value(forKey: envConfig) as? NSDictionary else
        {
            fatalError("Couldn't read API configuration file");
        }
        
        return apiConfigDict;
    }();
    
    func urlFor(_ operation: APIOperation, resource: TMDBEntityType, page: Int = 1, args: [String: String]? = nil) -> String {
        var baseURL: String =  self.baseURL.appending("/\(self.version)/\(operation.rawValue)/\(resource.rawValue)?page=\(page)");
        baseURL.append(self.argsToString(args));
        baseURL.append(self.auth);
        
        return baseURL;
    }
    
    func urlForImagewithPath(_ path: String, size: ImageSize = .medium) -> String {
        return self.imageURL.appending("/\(size.rawValue)/\(path)");
    }
    
}

// MARK: Private
private extension TMDBAPIConnector {
    var baseURL: String {
        return self.configurationValue("url");
    }
    
    var imageURL: String {
        return self.configurationValue("imageUrl");
    }
    
    var version: String {
        return self.configurationValue("version")
    }
    
    var key: String {
        return self.configurationValue("key");
    }
    
    var auth: String {
        return "&api_key=\(self.key)";
    }
    
    func configurationValue(_ value: String) -> String {
        guard let _value = self.configuration.value(forKey: value) as? String else {
            fatalError("Couldn't read API \(value)");
        }
        
        return _value;
    }
    
    func argsToString(_ args: [String: String]?) -> String {
        var value: String = "";
        if let _args = args {
            for arg in _args {
                value.append("&\(arg.key)=\(arg.value)");
            }
        }
        
        return value;
    }
}
