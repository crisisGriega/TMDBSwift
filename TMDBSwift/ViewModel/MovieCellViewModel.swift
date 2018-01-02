//
//  MovieCellViewModel.swift
//  TMDBSwift
//
//  Created by Gerardo on 02/01/2018.
//  Copyright © 2018 crisisGriega. All rights reserved.
//

import UIKit


class MovieCellViewModel {
    
    var movie: Movie?
    
    var title: String {
        return self.movie?.title ?? "No title available";
    }
    
    var year: String {
        return self.movie?.year ?? "Unknkown year";
    }
    
    var overview: String {
        return self.movie?.overview ?? "No information available";
    }
    
    var imageURL: URL? {
        let value = UIScreen.main.scale == 3.0 ? self.movie?.mediumImageURL : self.movie?.smallImageURL;
        
        guard let _value = value else { return nil; }
        return URL(string: _value)
    }
}
