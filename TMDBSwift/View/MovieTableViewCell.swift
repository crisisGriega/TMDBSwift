//
//  MovieTableViewCell.swift
//  TMDBSwift
//
//  Created by Gerardo on 02/01/2018.
//  Copyright © 2018 crisisGriega. All rights reserved.
//

import UIKit
import AlamofireImage


class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbYear: UILabel!
    @IBOutlet weak var lbOverview: UILabel!
    
    private let viewModel: MovieCellViewModel = MovieCellViewModel();
    
    var movie: Movie? {
        get {
            return self.viewModel.movie;
        }
        set {
            self.viewModel.movie = newValue;
            self.updateUI();
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.separatorInset = .zero;
    }
}


// MARK: Private
private extension MovieTableViewCell {
    func updateUI() {
        self.lbTitle.text = self.viewModel.title;
        self.lbTitle.sizeToFit();
        self.lbYear.text = self.viewModel.year;
        self.lbYear.sizeToFit();
        self.lbOverview.text = self.viewModel.overview;
        self.lbOverview.sizeToFit();
        
        self.imgPoster.af_cancelImageRequest();
        self.imgPoster.image = #imageLiteral(resourceName: "placeholder-movie");
        if let url = self.viewModel.imageURL {
            self.spinner.startAnimating();
            self.imgPoster.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "placeholder-movie"), imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false, completion: { (image) in
                self.spinner.stopAnimating();
            });
        }
    }
}
