//
//  ListViewModel.swift
//  TMDBSwift
//
//  Created by Gerardo on 02/01/2018.
//  Copyright © 2018 crisisGriega. All rights reserved.
//

import UIKit
import Alamofire


class ListViewModel {
    
    private let dataProvider: DataProvider = DataProvider();
    
    let itemsPerPage: Int = 20;
    let cellHeight: CGFloat = 170.0;
    
    private var list: [Movie] = [];
    private(set) var isRetrieving: Bool = false;
    
    var query: String? {
        didSet {
            guard oldValue != query  else { return; }
            self.page = 1;
            self.list.removeAll();
            self.isRetrieving = false;
            self.request?.cancel();
        }
    }
    
    private var page: Int = 1;
    private var request: DataRequest?;
    
    
    var marginForRetrieving: CGFloat {
        return (self.cellHeight) * CGFloat(self.itemsPerPage / 2);
    }
    
    var numberOfItems: Int {
        return self.list.count;
    }
    
    func itemFor(_ indexPath: IndexPath) -> Movie? {
        guard indexPath.row >= 0, indexPath.row < self.list.count else {
            return nil;
        }
        
        return self.list[indexPath.row];
    }
    
    func retrieveData(_ completion: (([Movie]?) -> Void)?) {
        if self.isRetrieving {
            if let _completion = completion {
                _completion(nil);
            }
            return;
        }
        self.isRetrieving = true;
        
        self.request = self.dataProvider.retrieveData(for: self.page, query: self.query, completion: { (result) in
            self.isRetrieving = false
            defer {
                if let _completion = completion {
                    _completion(result.value);
                }
            }
            
            if result.isSuccess, let value = result.value {
                self.list.append(contentsOf: value);
                self.page += 1;
            }
        });
    }
}
