//
//  SignUpViewModel.swift
//  SeSACRxThreads
//
//  Created by 박희지 on 4/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let emailText: ControlProperty<String?>
        let validationButtonTapEvent: ControlEvent<Void>
        let nextButtonTapEvent: ControlEvent<Void>
    }
    
    struct Output {
        let emailValidationText: Driver<String>
        let isValidEmail: Driver<Bool>
        let nextButtonTapTrigger: PublishSubject<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let emailValidationText = PublishRelay<String>()
        let isValidEmail = BehaviorRelay(value: false)
        let nextButtonTapTrigger = PublishSubject<Void>()
        
        let isValid = input.emailText.orEmpty
            .map { $0.contains("@") && $0.count > 10 }
            .share()
        
        input.validationButtonTapEvent
            .withLatestFrom(isValid)
            .bind(with: self) { owner, value in
                let title = value ? "사용가능한 이메일입니다.": "올바른 형식으로 입력해주세요"
                emailValidationText.accept(title)
                isValidEmail.accept(value)
            }
            .disposed(by: disposeBag)
        
        input.nextButtonTapEvent
            .bind(to: nextButtonTapTrigger)
            .disposed(by: disposeBag)
        
        return Output(
            emailValidationText: emailValidationText.asDriver(onErrorJustReturn: "올바른 형식으로 입력해주세요"),
            isValidEmail: isValidEmail.asDriver(),
            nextButtonTapTrigger: nextButtonTapTrigger)
    }
}
