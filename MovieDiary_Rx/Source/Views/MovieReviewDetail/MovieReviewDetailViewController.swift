//
//  MovieReviewDetailViewController.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/28.
//

import UIKit
import RxSwift
import RxCocoa

class MovieReviewDetailViewController: UIViewController {
    
    var viewModel: ReviewDetailViewModelType
    let disposeBag = DisposeBag()
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = I18NString.SubTitle.myReview
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemGray6
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let reviewView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let evalLabel: UILabel = {
        let label = UILabel()
        label.text = I18NString.SubTitle.myRate
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let evalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(viewModel: ReviewDetailViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addView()
        configure()
        bind()
        
    }

    func addView() {
        view.addSubview(reviewLabel)
        view.addSubview(reviewTextView)
        view.addSubview(reviewView)
        view.addSubview(evalLabel)
        view.addSubview(evalImageView)
    }
    
    func configure() {
        NSLayoutConstraint.activate([
            reviewLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            reviewLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            reviewView.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: 5),
            reviewView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            reviewView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            reviewView.heightAnchor.constraint(equalToConstant: 200),
            
            reviewTextView.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: 5),
            reviewTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            reviewTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            reviewTextView.heightAnchor.constraint(equalToConstant: 200),
            
            evalLabel.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor, constant: 20),
            evalLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            evalImageView.topAnchor.constraint(equalTo: evalLabel.topAnchor, constant: 20),
            evalImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
    
    func bind() {
        viewModel.movieNameText
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        
        viewModel.movieReviewText
            .subscribe(onNext: { review in
                self.reviewTextView.text = review
            })
            .disposed(by: disposeBag)
        
        viewModel.movieEvalText
            .subscribe(onNext: { eval in
                self.evalImageView.image = UIImage(named: "\(ReviewHelper().evalImage(eval))")
            })
            .disposed(by: disposeBag)
    }

}
