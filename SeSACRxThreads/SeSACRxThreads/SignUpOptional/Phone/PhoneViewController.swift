//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    private let viewModel = PhoneViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
    }
    
    func bind() {
        let input = PhoneViewModel.Input(
            textFieldText: phoneTextField.rx.text,
            nextButtonTap: nextButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        output.isValidNumber
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.phoneTextFiledText
            .drive(phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.nextButtonTitle
            .drive(nextButton.rx.title())
            .disposed(by: disposeBag)
        
        output.nextButtonTapTrigger
            .bind(with: self, onNext: { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
