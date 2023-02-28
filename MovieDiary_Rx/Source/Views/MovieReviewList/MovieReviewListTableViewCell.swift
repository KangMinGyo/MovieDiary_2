//
//  MovieReviewListTableViewCell.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/24.
//

import UIKit
import RxSwift

class MovieReviewListTableViewCell: UITableViewCell {
    
    static let identifier = "ReviewCell"
    
    var disposeBag = DisposeBag()
    let onData: AnyObserver<ReviewMetaData>
    
    let movieNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
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

    let recordDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray2
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        let data = PublishSubject<ReviewMetaData>()
        onData = data.asObserver()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                self?.movieNameLabel.text = item.title
                self?.movieInfoLabel.text = item.movieInfo
                self?.recordDateLabel.text = self?.formatter.string(for: item.date)
            })
            .disposed(by: disposeBag)

        [movieNameLabel, movieInfoLabel, recordDateLabel].forEach {
            self.stackView.addArrangedSubview($0)
        }
        addView()
        configure()
    }
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "ko_kr")
        return f
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        addSubview(stackView)
    }
    
    func configure() {
        NSLayoutConstraint.activate([
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
