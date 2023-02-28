//
//  SettingViewController.swift
//  MovieDiary
//
//  Created by KangMingyo on 2022/10/30.
//

import UIKit
import RxSwift
import MessageUI

class SettingViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let askButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle(I18NString.mail.feedback, for: .normal)
        button.contentHorizontalAlignment = .leading
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = I18NString.Title.setting
        view.backgroundColor = .systemBackground
        
        addView()
        configure()
        setupBinding()

    }
    
    func addView() {
        view.addSubview(topLineView)
        view.addSubview(askButton)
        view.addSubview(buttomLineView)
    }
    
    func configure() {
        NSLayoutConstraint.activate([
            topLineView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topLineView.heightAnchor.constraint(equalToConstant: 1),
            
            askButton.topAnchor.constraint(equalTo: topLineView.bottomAnchor, constant: 10),
            askButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            askButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            buttomLineView.topAnchor.constraint(equalTo: askButton.bottomAnchor, constant: 10),
            buttomLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttomLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttomLineView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    // MARK: - UI Binding
    
    func setupBinding() {
        askButton.rx.tap
            .bind {
                self.sendMail()
            }
            .disposed(by: disposeBag)
    }
    
}
