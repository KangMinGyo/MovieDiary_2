//
//  ReviewWriteViewController.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/26.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlertController_Swift

class ReviewWriteViewController: UIViewController {
    
    var viewModel: ReviewWriteViewModelType
    let disposeBag = DisposeBag()
    
    init(viewModel: ReviewWriteViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var movieName = ""
    var movieInfo = ""
    var contents = ""
    var eval = ""
    
    lazy var registerButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: I18NString.Button.saveButton,
                                     style: .plain,
                                     target: self,
                                     action: #selector(registerButtonPressed))
        button.isEnabled = false
        button.tintColor = .red
        return button
    }()
    
    let reviewLabel: UILabel = {
        let label = UILabel()
        label.text = I18NString.SubTitle.myReview
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let reviewVaildView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 3
        view.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.text = I18NString.Explanation.reviewView
        textView.textColor = .lightGray
        textView.backgroundColor = .systemGray6
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let rateLabel: UILabel = {
        let label = UILabel()
        label.text = I18NString.SubTitle.myRate
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rateVaildView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 3
        view.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rateButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .systemBackground
        button.setTitle(I18NString.Explanation.rateButton, for: UIControl.State.normal)
        button.tintColor = .systemGray2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func addView() {
        view.addSubview(reviewLabel)
        view.addSubview(reviewVaildView)
        view.addSubview(reviewTextView)
        view.addSubview(rateLabel)
        view.addSubview(rateVaildView)
        view.addSubview(rateButton)
        view.addSubview(lineView)
    }
    
    func configure() {
        NSLayoutConstraint.activate([
            
            reviewLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            reviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            reviewVaildView.leadingAnchor.constraint(equalTo: reviewLabel.trailingAnchor, constant: 5),
            reviewVaildView.centerYAnchor.constraint(equalTo: reviewLabel.centerYAnchor),
            reviewVaildView.heightAnchor.constraint(equalToConstant: 5),
            reviewVaildView.widthAnchor.constraint(equalToConstant: 5),
            
            reviewTextView.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: 5),
            reviewTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reviewTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            reviewTextView.heightAnchor.constraint(equalToConstant: 200),
            
            rateLabel.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor, constant: 20),
            rateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            rateVaildView.leadingAnchor.constraint(equalTo: rateLabel.trailingAnchor, constant: 5),
            rateVaildView.centerYAnchor.constraint(equalTo: rateLabel.centerYAnchor),
            rateVaildView.heightAnchor.constraint(equalToConstant: 5),
            rateVaildView.widthAnchor.constraint(equalToConstant: 5),
            
            rateButton.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: 5),
            rateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            rateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            lineView.topAnchor.constraint(equalTo: rateButton.bottomAnchor, constant: 20),
            lineView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            lineView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.movieNameText
            .bind(to: rx.title)
            .disposed(by: disposeBag)
        
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = registerButton
        reviewTextView.delegate = self
        
        addView()
        configure()
        bind()
    }
    
    // MARK: - UI Binding
    
    func bind() {
        
        viewModel.movieNameText
            .subscribe(onNext: { name in
                self.movieName = name
            })
            .disposed(by: disposeBag)
        
        viewModel.movieInfoText
            .subscribe(onNext: { info in
                self.movieInfo = info
            })
            .disposed(by: disposeBag)
        
        reviewTextView.rx.text.orEmpty
            .bind(to: viewModel.reviewInputText)
            .disposed(by: disposeBag)
        
        rateButton.rx.tap
            .bind {
                self.showActionSheet()
            }
        
        viewModel.reviewVaild.subscribe(onNext: { b in self.reviewVaildView.isHidden = b})
            .disposed(by: disposeBag)
        
        viewModel.evalVaild.subscribe(onNext: { b in self.rateVaildView.isHidden = b })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.reviewVaild, viewModel.evalVaild, resultSelector: { $0 && $1 } )
            .subscribe(onNext: { b in self.registerButton.isEnabled = b })
            .disposed(by: disposeBag)
    }
    
    func showActionSheet() {
        RxAlertController(title: I18NString.SubTitle.actionSheet, message: nil, preferredStyle: .actionSheet)
          .add(.init(title: "cancel", style: .cancel))
          .add(.init(title: I18NString.actionSheet.best, id: 1, style: .default))
          .add(.init(title: I18NString.actionSheet.good, id: 2, style: .default))
          .add(.init(title: I18NString.actionSheet.notbad, id: 3, style: .default))
          .add(.init(title: I18NString.actionSheet.bad, id: 4, style: .default))
          .show(in: self)
          .subscribe(onNext: {
              self.rateButton.setTitle($0.action.title, for: .normal)
              self.viewModel.evalInputText = BehaviorRelay(value: $0.action.title)
              self.viewModel.bindInput()
          }).disposed(by: disposeBag)
    }
    
    @objc func registerButtonPressed() {

        contents = reviewTextView.text
        viewModel.evalInputText.subscribe(onNext: { e in
            self.eval = e
        })
        
        //리뷰 등록
        ReviewManager.shared.saveReview(title: movieName, contents: contents, movieInfo: movieInfo, eval: eval) { result in
            switch result {
            case .success(let mataData):
                print(mataData)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension ReviewWriteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if reviewTextView.textColor == UIColor.lightGray {
            reviewTextView.text = ""
            reviewTextView.textColor = UIColor.systemGray
            }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if reviewTextView.text.isEmpty {
            reviewTextView.text = "내용을 입력해주세요."
            reviewTextView.textColor = UIColor.lightGray
            }
    }
}
