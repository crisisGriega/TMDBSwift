//
//  Movie.swift
//  TMDBSwift
//
//  Created by Gerardo on 02/01/2018.
//  Copyright © 2018 crisisGriega. All rights reserved.
//

import Foundation
import ObjectMapper


class Movie: Mappable {
    
    var id: String?;
    var title: String?;
    var year: String?;
    var overview: String?;
    var posterPath: String?;
    
    // MARK: Mappable
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.id <- map["id"];
        self.title <- map["title"];
        self.overview <- map["overview"];
        self.posterPath <- map["poster_path"];
        let dateFormatter = DateFormatter(withFormat: "yyyy-MM-dd", locale: "en_US");
        self.year <- (map["release_date"], TransformOf<String, String>(fromJSON: { (value) -> String? in
            guard
                let _value = value,
                let date = dateFormatter.date(from: _value) else
            {
                return nil;
            }
            
            return String(describing:Calendar.current.component(.year, from: date));
            
        }, toJSON: { (value) -> String? in
            guard let _value = value else { return nil }
            return String(describing: _value);
        }));
    }
}
