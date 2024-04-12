//
//  NicknameViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NicknameViewController: UIViewController {
   
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    private let viewModel = NicknameViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        bind()
    }
    
    func bind() {
        let input = NicknameViewModel.Input(
            textFieldText: nicknameTextField.rx.text,
            nextButtonTap: nextButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        output.isValidNickname
            .drive(with: self, onNext: { owner, value in
                owner.nextButton.isEnabled = value
                owner.nextButton.backgroundColor = value ? .systemBlue: .black
            })
            .disposed(by: disposeBag)
        
        output.nextButtonTitle
            .drive(nextButton.rx.title())
            .disposed(by: disposeBag)
        
        output.nextButtonTapTrigger
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(nicknameTextField)
        view.addSubview(nextButton)
         
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
