//
//  ViewController.swift
//  PicScroll
//
//  Created by Dhruv Govani on 16/04/24.
//

import UIKit

class GridViewController: UIViewController, BaseBridge{

    @IBOutlet weak var clcGridView: UICollectionView!
    var viewModel : GridViewModel = GridViewModel()
    lazy private var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Grid"
        
        clcGridView.delegate = self
        clcGridView.dataSource = self
        clcGridView.register(UINib(nibName: "GridCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "GridCollectionViewCell")
        
        clcGridView.refreshControl = refreshControl
        refreshControl.beginRefreshing()
        refreshControl.addTarget(self, action: #selector(refreshGrid(_:)), for: .valueChanged)
        
        viewModel.interactor = self
        // Do any additional setup after loading the view.
    }
    
    @objc func refreshGrid(_ sender: Any){
        viewModel.loadData()
    }
    
    func didLoadData(_ bridge: BaseBridge?) {
        self.clcGridView.backgroundView = nil
        self.clcGridView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func didFailedToLoadData(_ bridge: BaseBridge?, errorMessage: String) {
        let errorMessage = errorMessage + "\n\n Pull to refresh."
        let errorView = ErrorMessageView(frame: self.clcGridView.frame)
        errorView.configure(with: errorMessage)
        self.clcGridView.backgroundView = errorView
        self.refreshControl.endRefreshing()
        self.clcGridView.reloadData()
    }
    
}
