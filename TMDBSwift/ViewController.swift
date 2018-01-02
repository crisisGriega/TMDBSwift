//
//  ViewController.swift
//  TMDBSwift
//
//  Created by Gerardo on 02/01/2018.
//  Copyright © 2018 crisisGriega. All rights reserved.
//

import UIKit
import DSGradientProgressView

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingBar: DSGradientProgressView!
    
    private let viewModel: ListViewModel = ListViewModel();
    private let cellViewModel: MovieCellViewModel = MovieCellViewModel();
    private var reloadWorkItem: DispatchWorkItem?;
    
    private let searchController: UISearchController = UISearchController(searchResultsController: nil);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTableView();
        self.setUpSearechController();
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.retrieveData();
    }
}


// MARK: Private
private extension ViewController {
    func retrieveData() {
        self.loadingBar.wait();
        self.viewModel.retrieveData { (items) in
            self.tableView.reloadData();
            self.loadingBar.signal();
        }
    }
    
    func setUpTableView() {
        let reuseId = MovieTableViewCell.reuseIdentifier;
        let cellNib = UINib.init(nibName: reuseId, bundle: nil);
        self.tableView.register(cellNib, forCellReuseIdentifier: reuseId);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    
    func setUpSearechController() {
        self.searchController.searchResultsUpdater = self;
        self.searchController.obscuresBackgroundDuringPresentation = false;
        self.searchController.searchBar.placeholder = "Enter a movie title";
        
        self.navigationItem.searchController = self.searchController;
        self.definesPresentationContext = true;
    }
}


// MARK: UITableView DataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier, for: indexPath) as! MovieTableViewCell;
        cell.movie = self.viewModel.itemFor(indexPath);
        
        return cell;
    }
}

// MARK: UITableView Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard
            let theme = Theme.currentTheme,
            let titleFont = theme.textFont(for: TextStyle.title.rawValue),
            let subtitleFont = theme.textFont(for: TextStyle.subtitle.rawValue)  else
        {
            return self.tableView(tableView, estimatedHeightForRowAt: indexPath);
        }
        
        self.cellViewModel.movie = self.viewModel.itemFor(indexPath);
        // TODO: Constant values should be stored somewhere not hardcoded here
        let width: CGFloat = tableView.frame.width - 130.0;
        let titleHeight: CGFloat = ceil(self.cellViewModel.title.heightFor(width: width, font: titleFont));
        let yearHeight: CGFloat = ceil(self.cellViewModel.year.heightFor(width: width, font: titleFont));
        let overViewHeight: CGFloat = ceil(self.cellViewModel.overview.heightFor(width: width, font: subtitleFont));
        
        let textHeight = titleHeight + yearHeight + overViewHeight + 40;
        let estimatedHeight = self.tableView(self.tableView, estimatedHeightForRowAt: indexPath);
        
        return textHeight < estimatedHeight ? estimatedHeight : textHeight;
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.viewModel.cellHeight;
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            scrollView.contentSize.height > self.viewModel.marginForRetrieving,
            scrollView.contentOffset.y > (scrollView.contentSize.height - self.viewModel.marginForRetrieving) else
        { return; }
        
        let oldItemCount = self.viewModel.numberOfItems;
        self.loadingBar.wait();
        self.viewModel.retrieveData({ (items) in
            defer { self.loadingBar.signal(); }
            guard items != nil else { return; }
            
            var indexPaths: [IndexPath] = [];
            for item in oldItemCount..<self.viewModel.numberOfItems {
                indexPaths.append(IndexPath(row: item, section: 0));
            }
            self.tableView.insertRows(at: indexPaths, with: .automatic);
        });
    }
}


// MARK: UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return; }
        
        let value = !searchText.isEmpty ? searchText : nil;
        self.viewModel.query = value;
        self.tableView.reloadData();
        
        self.reloadWorkItem?.cancel();
        self.reloadWorkItem = DispatchWorkItem { [weak self] in
            self?.retrieveData();
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: self.reloadWorkItem!);
    }
}
