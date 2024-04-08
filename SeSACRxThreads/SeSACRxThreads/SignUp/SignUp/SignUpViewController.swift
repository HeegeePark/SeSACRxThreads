 //
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {

    private let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    private let validationButton = UIButton()
    private let nextButton = PointButton(title: "다음")
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        bind()
    }
    
    func bind() {
        let input = SignUpViewModel.Input(
            emailText: emailTextField.rx.text,
            validationButtonTapEvent: validationButton.rx.tap,
            nextButtonTapEvent: nextButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        output.emailValidationText
            .drive(with: self) { owner, text in
                owner.showAlert(title: nil, message: text, ok: "확인", handler: nil)
            }
            .disposed(by: disposeBag)
        
        output.isValidEmail
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.nextButtonTapTrigger
            .bind(with: self, onNext: { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
