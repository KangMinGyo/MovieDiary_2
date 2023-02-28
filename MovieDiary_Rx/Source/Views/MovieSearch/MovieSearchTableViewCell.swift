//
//  MovieSearchTableViewCell.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/25.
//

import UIKit
import RxSwift

class MovieSearchTableViewCell: UITableViewCell {
    static let identifier = "SearchCell"
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<ViewMovie>
    
    let movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let movieNameEnLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let movieInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let directorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let data = PublishSubject<ViewMovie>()
        onData = data.asObserver()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                self?.movieNameLabel.text = item.movieNm
                self?.movieNameEnLabel.text = item.movieNmEn
                self?.movieInfoLabel.text = item.info
                self?.directorLabel.text = "감독 : \(MovieSearchHelper().directorNameHelper(item.directorNm))"
            })
            .disposed(by: disposeBag)
        
        [movieNameLabel, movieNameEnLabel, movieInfoLabel, directorLabel].forEach {
            self.stackView.addArrangedSubview($0)
        }

        addView()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addView() {
        addSubview(stackView)
    }
    
    func configure() {
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
