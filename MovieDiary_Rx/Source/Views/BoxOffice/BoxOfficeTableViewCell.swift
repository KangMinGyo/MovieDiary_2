//
//  BoxOfficeTableViewCell.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/24.
//

import UIKit
import RxSwift
import RxCocoa

class BoxOfficeTableViewCell: UITableViewCell {
    static let identifier = "BoxOfficeCell"
    typealias viewModel = BoxOfficeViewModel

    var disposeBag = DisposeBag()
    var onData: AnyObserver<ViewBoxOffice>
    var onPoster: AnyObserver<ViewMoviePoster>
    
    let posterImageView: UIImageView = {
         let imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         return imageView
     }()
    
    //영화 이름
    let movieName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //영화 개봉일
    let openDate: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //박스오피스 랭크
    let boxOfficeRank: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let boxOfficeLabel: UILabel = {
        let label = UILabel()
        label.text = "박스오피스"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let boxOfficeRankStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //누적 관객수
    let audiAcc: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let audiAccLabel: UILabel = {
        let label = UILabel()
        label.text = "누적관객수"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let audiAccStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //전일대비 순위의 증감분
    let rankInten: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rankIntenLabel: UILabel = {
        let label = UILabel()
        label.text = "전일 대비"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rankIntenStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let movieInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let data = PublishSubject<ViewBoxOffice>()
        let posterData = PublishSubject<ViewMoviePoster>()
        onData = data.asObserver()
        onPoster = posterData.asObserver()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                self?.movieName.text = item.movieNm
                self?.movieName.text = item.movieNm
                self?.openDate.text = item.openDt
                self?.boxOfficeRank.text = "\(item.rank)"
                self?.rankInten.text = BoxOfficeHelper().rankIntenCal(item.rankInten)
                self?.audiAcc.text = BoxOfficeHelper().audiAccCal(item.audiAcc)
            })
        
        posterData.asObserver()
            .subscribe(onNext: { [weak self] posterItems in

                self?.posterImageView.setImageUrl(url: posterItems.posterPath, movieName: posterItems.title)
            })
        
        
        addView()
        configure()
        stackViewConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(viewModel: viewModel) {
        
        viewModel.boxOfficeItems
            .map { $0.map {$0.movieNm} }
            .subscribe(onNext: { items in
                print(items)
            })
            
    }

    func addView() {
        addSubview(posterImageView)
        addSubview(movieName)
        addSubview(openDate)
        addSubview(lineView)
        addSubview(movieInfoStackView)
    }
    
    func configure() {
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            posterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            posterImageView.heightAnchor.constraint(equalToConstant: 120),
            posterImageView.widthAnchor.constraint(equalToConstant: 80),
            
            movieName.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            movieName.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            movieName.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            openDate.topAnchor.constraint(equalTo: movieName.bottomAnchor, constant: 5),
            openDate.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            
            lineView.topAnchor.constraint(equalTo: openDate.bottomAnchor, constant: 10),
            lineView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            lineView.widthAnchor.constraint(equalToConstant: 250),
            
            movieInfoStackView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 10),
            movieInfoStackView.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            movieInfoStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    func stackViewConfigure() {
        
        [boxOfficeRank, boxOfficeLabel].forEach {
            self.boxOfficeRankStackView.addArrangedSubview($0)
        }
        
        [audiAcc, audiAccLabel].forEach {
            self.audiAccStackView.addArrangedSubview($0)
        }
        
        [rankInten, rankIntenLabel].forEach {
            self.rankIntenStackView.addArrangedSubview($0)
        }
        
        [boxOfficeRankStackView, rankIntenStackView, audiAccStackView].forEach {
            self.movieInfoStackView.addArrangedSubview($0)
        }

    }
}
