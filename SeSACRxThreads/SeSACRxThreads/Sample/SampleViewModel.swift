//
//  SampleViewModel.swift
//  SeSACRxThreads
//
//  Created by 박희지 on 4/12/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SampleViewModel: ViewModelType {
    struct Input {
        let itemSelected: PublishSubject<Int>
        let textFieldText: PublishSubject<String>
        let addButtonTap: PublishSubject<Void>
    }
    
    struct Output {
        let items: PublishSubject<[String]>
    }
    
    var items: [String] = []
    
    var disposeBag: DisposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        
        let output = Output(items: PublishSubject<[String]>())
        
        let text = input.textFieldText
            .distinctUntilChanged()
        
        input.addButtonTap
            .withLatestFrom(text)
            .bind(with: self) { owner, value in
                guard !value.isEmpty else { return }
                owner.items.append(value)
                output.items.onNext(owner.items)
            }
            .disposed(by: disposeBag)
        
        input.itemSelected
            .bind(with: self) { owner, value in
                owner.items.remove(at: value)
                output.items.onNext(owner.items)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
