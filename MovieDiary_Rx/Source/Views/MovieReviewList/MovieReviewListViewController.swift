//
//  MovieReviewListViewController.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/24.
//

import UIKit
import RxSwift
import RxCocoa

class MovieReviewListViewController: UIViewController {
    
    var viewModel: MovieReviewModelType
    var disposeBag = DisposeBag()
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "ko_kr")
        return f
    }()
    
    // MARK: - View Components
    
    lazy var settingButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: .gearshape))
        button.tintColor = .gray
        return button
    }()
    
    lazy var movieSearchButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: .magnifyingglass))
        button.tintColor = .gray
        return button
    }()
    
    lazy var boxOfficeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: .chart))
        button.tintColor = .gray
        return button
    }()
    
    let MovieReviewListTableView: UITableView = {
         let tableView = UITableView()
         tableView.rowHeight = 100
         tableView.translatesAutoresizingMaskIntoConstraints = false
         return tableView
     }()
    
    //MARK: - LifeCycle
    
    init(viewModel: MovieReviewModelType = MovieReviewViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = I18NString.Title.reviewList
        navigationItem.leftBarButtonItem = settingButton
        navigationItem.rightBarButtonItems = [boxOfficeButton, movieSearchButton]
        
        addView()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupTableView()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewdidappear")
        bind()
    }
    
    //MARK: -
    //MARK: Setup TableView
    
    func setupTableView() {
        MovieReviewListTableView.delegate = nil
        MovieReviewListTableView.dataSource = nil
        MovieReviewListTableView.register(MovieReviewListTableViewCell.self, forCellReuseIdentifier: "ReviewCell")
    }
    
    func addView() {
        view.addSubview(MovieReviewListTableView)
    }
    
    func configure() {
        NSLayoutConstraint.activate([
            MovieReviewListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            MovieReviewListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            MovieReviewListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            MovieReviewListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadData() {
        viewModel.reviewMetaDatas = BehaviorRelay<[ReviewMetaData]>(value: [])
        
        ReviewManager.shared.loadReviews(start: 0) { result in
            switch result {
            case .success(let metaDatas):
                self.viewModel.reviewMetaDatas.accept(metaDatas)
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }

    // MARK: - Binding
    func bind() {
        
        viewModel.reviewMetaDatas
            .bind(to: MovieReviewListTableView.rx.items(cellIdentifier: MovieReviewListTableViewCell.identifier,
                                                    cellType: MovieReviewListTableViewCell.self)) {
                _, item, cell in

                cell.onData.onNext(item)
            }
        .disposed(by: disposeBag)
        
        MovieReviewListTableView.rx.itemSelected.take(1)
            .subscribe(onNext: { [weak self] indexPath in
                let nextVC = MovieReviewDetailViewController(viewModel: MovieReviewDetailViewModel((self?.viewModel.reviewMetaDatas.value[indexPath.row])!))
                self?.show(nextVC, sender: self)
            })
        .disposed(by: disposeBag)
        
        MovieReviewListTableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                ReviewManager.shared.deleteReview(data: (self?.viewModel.reviewMetaDatas.value[indexPath.row])!) { result in
                    switch result {
                    case .success:
                        self?.viewModel.reviewMetaDatas.remove(at: indexPath.row)
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        settingButton.rx.tap.take(1)
            .bind {
                let nextVC = SettingViewController()
                self.show(nextVC, sender: self)
            }.disposed(by: disposeBag)
        
        movieSearchButton.rx.tap.take(1)
            .bind {
                let nextVC = MovieSearchViewController(viewModel: MovieSearchViewModel(domain: MovieSearchService()))
                self.show(nextVC, sender: self)
            }.disposed(by: disposeBag)
        
        boxOfficeButton.rx.tap.take(1)
            .bind {
                let nextVC = BoxOfficeViewController(viewModel: BoxOfficeViewModel(domain: BoxOfficeService()))
                self.show(nextVC, sender: self)
            }.disposed(by: disposeBag)
    }
    
}
