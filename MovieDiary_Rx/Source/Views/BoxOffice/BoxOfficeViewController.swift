//
//  BoxOfficeViewController.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/24.
//

import UIKit
import RxSwift
import RxCocoa

class BoxOfficeViewController: UIViewController {
    
    let viewModel: BoxOfficeViewModel
    let disposeBag = DisposeBag()
    var moviePosterItem = [ViewMoviePoster]()
    
    var boxOfficeHelper = BoxOfficeHelper()
    var boxOfficeDataList = [DailyBoxOfficeList]()
    var moviePosterData = [String]()
    
    let posterBaseURL = "https://image.tmdb.org/t/p/original"

    let boxOfficeTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 150
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(viewModel: BoxOfficeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = I18NString.Title.boxOfficeTitle
        
        addView()
        configure()
        setupTableView()
        bind()
    }
    
    
    //MARK: -
    //MARK: Setup TableView
    
    func setupTableView() {
        boxOfficeTableView.delegate = nil
        boxOfficeTableView.dataSource = nil
        boxOfficeTableView.register(BoxOfficeTableViewCell.self, forCellReuseIdentifier: "BoxOfficeCell")
    }
    
    func addView() {
        view.addSubview(boxOfficeTableView)
    }
    
    func configure() {
        NSLayoutConstraint.activate([
            
            boxOfficeTableView.topAnchor.constraint(equalTo: view.topAnchor),
            boxOfficeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boxOfficeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boxOfficeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Binding
    
    func bind() {
        
        viewModel.fetchBoxOffice(date: Date().yesterdayDate())
            .subscribe(onNext: { items in
                self.viewModel.boxOfficeItems.accept(items)
                self.viewModel.movieCode.append(contentsOf: items.map{ $0.movieNm })
                
                for index in 0..<self.viewModel.movieCode.value.count {
                    self.viewModel.fetchMoviePoster(movieNm: self.viewModel.movieCode.value[index])
                        .subscribe(onNext: { posterItems in
                            self.viewModel.moviePosterItems.append(posterItems[0])
                            self.viewModel.realmMoviePosterItems.append(posterItems[0])
                        })
                    }
                
            }) .disposed(by: disposeBag)
        
        viewModel.posterVaild
            .subscribe(onNext: { b in
                if b == true {
                    self.viewModel.boxOfficeItems
                        .bind(to: self.boxOfficeTableView.rx.items(cellIdentifier: BoxOfficeTableViewCell.identifier,
                                                                   cellType: BoxOfficeTableViewCell.self)) {
                            index, item, cell in
                            
                            cell.onData.onNext(item)
                            cell.posterImageView.setImageUrl(url: self.viewModel.realmMoviePosterItems.value[index].posterPath, movieName: self.viewModel.realmMoviePosterItems.value[index].title)
                        }
                    }
            }).disposed(by: self.disposeBag)
        
    }
}

