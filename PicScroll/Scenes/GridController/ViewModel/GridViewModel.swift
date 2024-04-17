//
//  GridViewModel.swift
//  PicScroll
//
//  Created by Dhruv Govani on 16/04/24.
//

import Foundation

class GridViewModel{
    var coverageItems : [MediaCoverageElement] = []
    lazy private var repo = MediaCoverageRepository()
    weak var interactor: BaseBridge? = nil
    
    init(){
        self.loadData()
    }
    
    /// Get Coverge Items from server
    func loadData(){
        repo.fetchMediaCoverages(limit: 100)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: Failed to load API Data \(error)")
                    self.coverageItems.removeAll()
                    self.interactor?.didFailedToLoadData(self.interactor, errorMessage: error.localizedDescription)
                case .finished:
                    print("API Data loaded successfully.")
                    self.interactor?.didLoadData(self.interactor)
                }
            }, receiveValue: { mediaCoverages in
                self.coverageItems = mediaCoverages
            })
            .store(in: &repo.cancellables)
    }
    
}
