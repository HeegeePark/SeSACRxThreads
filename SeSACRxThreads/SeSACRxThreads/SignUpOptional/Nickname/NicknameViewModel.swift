//
//  NicknameViewModel.swift
//  SeSACRxThreads
//
//  Created by 박희지 on 4/12/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameViewModel: ViewModelType {
    struct Input {
        let textFieldText: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isValidNickname: Driver<Bool>
        let nextButtonTitle: Driver<String>
        let nextButtonTapTrigger: PublishSubject<Void>
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        let isValidNickname = BehaviorRelay<Bool>(value: false)
        let nextButtonTitle = BehaviorRelay(value: "닉네임을 입력해주세요.")
        let nextButtonTapTrigger = PublishSubject<Void>()
        
        let inputText = input.textFieldText
            .orEmpty
            .share()
        
        let validation = inputText
            .map { $0.count >= 2 }
        
        validation
            .bind(with: self) { owner, value in
                isValidNickname.accept(value)
                let title = value ? "다음": "닉네임은 2자 이상"
                nextButtonTitle.accept(title)
            }
        
        input.nextButtonTap
            .bind(to: nextButtonTapTrigger)
            .disposed(by: disposeBag)
        
        return Output(
            isValidNickname: isValidNickname.asDriver(),
            nextButtonTitle: nextButtonTitle.asDriver(),
            nextButtonTapTrigger: nextButtonTapTrigger
        )
    }
}
