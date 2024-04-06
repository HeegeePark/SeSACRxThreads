//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 박희지 on 4/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneViewModel: ViewModelType {
    struct Input {
        let textFieldText: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let isValidNumber: Driver<Bool>
        let phoneTextFiledText: Driver<String>
        let nextButtonTitle: Driver<String>
        let nextButtonTapTrigger: PublishSubject<Void>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        let isValidNumber = PublishRelay<Bool>()
        let phoneTextFiledText = BehaviorRelay(value: "010")
        let nextButtonTitle = BehaviorRelay(value: "연락처는 1자 이상")
        let nextButtonTapTrigger = PublishSubject<Void>()
        
        let inputText = input.textFieldText
            .orEmpty
            .share()
        
        let validation = inputText
            .map {  // 형식 체크를 위해 "-" 제거
                $0.replacingOccurrences(of: "-", with: "")
            }
            .map {
                Int($0) != nil &&
                $0.count >= 11 &&
                $0.contains("010")
            }
        
        let refinedText = inputText
            .map {  // 문자 거르기
                $0.filter { $0.isNumber || $0 == "-" }
            }
        
        validation
            .bind(with: self) { owner, isValid in
                isValidNumber.accept(isValid)
                let title = isValid ? "다음": "연락처는 11자 이상"
                nextButtonTitle.accept(title)
            }
            .disposed(by: disposeBag)
        
        refinedText
            .bind(with: self) { owner, text in
                let formatted = owner.insertHyphen(text: text)
                phoneTextFiledText.accept(formatted)
            }
            .disposed(by: disposeBag)
        
        input.nextButtonTap
            .bind(to: nextButtonTapTrigger)
            .disposed(by: disposeBag)
            
        return Output(
            isValidNumber: isValidNumber.asDriver(onErrorJustReturn: false),
            phoneTextFiledText: phoneTextFiledText.asDriver(),
            nextButtonTitle: nextButtonTitle.asDriver(),
            nextButtonTapTrigger: nextButtonTapTrigger
        )
    }
    
    // 전화번호에 하이픈 삽입하기
    private func insertHyphen(text: String) -> String {
        // "-" 포함 13자 이상이면 자르기
        var text = text
        if text.count > 13 {
            let index13 = text.index(text.startIndex, offsetBy: 13)
            text = String(text[..<index13])
        }
        
        var formattedPhoneNumber = ""
        let cleanPhoneNumber = text.replacingOccurrences(of: "-", with: "")
        
        let length = cleanPhoneNumber.count
        
        switch length {
        case 4:
            let index3 = cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: 3)
            formattedPhoneNumber += cleanPhoneNumber[..<index3] + "-"
            formattedPhoneNumber += String(cleanPhoneNumber.last!)
        case 8:
            let index3 = cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: 3)
            let index7 = cleanPhoneNumber.index(cleanPhoneNumber.startIndex, offsetBy: 7)
            formattedPhoneNumber += cleanPhoneNumber[..<index3] + "-"
            formattedPhoneNumber += cleanPhoneNumber[index3..<index7] + "-"
            formattedPhoneNumber += String(cleanPhoneNumber.last!)
        default:
            if text.last == "-" {
                text.removeLast()
            }
            formattedPhoneNumber = text
        }
        return formattedPhoneNumber
    }
}
