//
//  MovieSearchViewController.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/25.
//

import UIKit
import RxSwift
import RxRelay

class MovieSearchViewController: UIViewController {
    static let identifier = "MovieSearchViewController"
    
    let viewModel: MovieSearchViewModel
    let disposeBag = DisposeBag()

    // MARK: - View Components
    
    let searchBar = UISearchBar()
    
    func setUpSearchBar() {
        searchBar.frame = (CGRect(x: 0, y: 0, width: 200, height: 70))
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = I18NString.Explanation.searchBar
    }
    
    let movieSearchTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 100
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    //MARK: - LifeCycle
    
    init(viewModel: MovieSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = I18NString.Title.movieSearchTitle
        
        addView()
        configure()
        setupTableView()
        setUpSearchBar()
        bind()
    }
    
    //MARK: -
    //MARK: Setup TableView
    func setupTableView() {
        movieSearchTableView.register(MovieSearchTableViewCell.self, forCellReuseIdentifier: "SearchCell")
        movieSearchTableView.tableHeaderView = searchBar
    }
    
    //MARK: Add View
    func addView() {
        view.addSubview(movieSearchTableView)
    }
    
    //MARK: Layout
    func configure() {
        NSLayoutConstraint.activate([
            
            movieSearchTableView.topAnchor.constraint(equalTo: view.topAnchor),
            movieSearchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            movieSearchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            movieSearchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Binding
    
    func bind() {
        
        searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak searchBar] in
                searchBar?.resignFirstResponder()
                let movieName = searchBar?.text
        
                self.viewModel.fetchMovieSearch(movieName: movieName ?? "").subscribe(onNext: { movieItems in
                    self.viewModel.movieItems.accept(movieItems)
                })
                .disposed(by: self.disposeBag)
            })

        movieSearchTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let nextVC = ReviewWriteViewController(viewModel: ReviewWriteViewModel((self?.viewModel.movieItems.value[indexPath.row])!))
                self?.show(nextVC, sender: self)
            })
            .disposed(by: disposeBag)

        viewModel.movieItems
            .bind(to: movieSearchTableView.rx.items(cellIdentifier: MovieSearchTableViewCell.identifier,
                                                    cellType: MovieSearchTableViewCell.self)) {
                _, item, cell in

                cell.onData.onNext(item)
            }
        .disposed(by: disposeBag)
    }
}

