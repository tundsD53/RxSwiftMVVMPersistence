//
//  ViewController.swift
//  CoreDataPersistence
//
//  Created by Tunde on 04/06/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxOptional

class ViewController: UIViewController {
    
    @IBOutlet weak var tableVw: UITableView!
    let searchController = UISearchController(searchResultsController: nil)

    private let disposeBag = DisposeBag()
    private lazy var characterService = CharacterService(networkConfig: NetworkConfig(baseUrl: "https://rickandmortyapi.com/api"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        setupFindCharacterSubcription()
        setupFindCharacterErrorSubscription()
        setupSearchBinding()
    }
    
    func setupFindCharacterSubcription() {
        
        characterService
            .getCharactersObservable()
            .map { try? $0.get().data }
            .filterNil()
            .bind(to: tableVw.rx.items(cellIdentifier: CharacterTableViewCell.cellId, cellType: CharacterTableViewCell.self)) {
                row, element, cell in
                cell.configure(with: element)
            }.disposed(by: disposeBag)
    }

    func setupFindCharacterErrorSubscription() {
        
        characterService
            .getCharactersObservable()
            .subscribe(onNext: { result in
                switch result {
                    
                case .failure(let error):
                    UIAlertController(networkError: error).show()
                default: break
                }
            }).disposed(by: disposeBag)
    }
    
    func setupSearchBinding() {
        
        searchController.searchBar.rx
            .text
            .filterNil()
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] query in
                self.characterService.find(name: query)
            }).disposed(by: disposeBag)
    }
}

private extension ViewController {
    
    func setupTableView() {
        
        tableVw.tableFooterView = UIView()
        tableVw.rowHeight = UITableView.automaticDimension
        tableVw.estimatedRowHeight = 44
        tableVw.tableHeaderView = searchController.searchBar
        tableVw.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: CharacterTableViewCell.cellId)
    }
}
