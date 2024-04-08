//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 박희지 on 4/9/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthdayViewModel: ViewModelType {
    struct Input {
        let birthday: ControlProperty<Date>
    }
    
    struct Output {
        let year: Driver<String>
        let month: Driver<String>
        let day: Driver<String>
        let isValidDate: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    
    func transform(_ input: Input) -> Output {
        let year = BehaviorRelay<Int>(value: 4)
        let month = BehaviorRelay<Int>(value: 4)
        let day = BehaviorRelay<Int>(value: 4)
        
        input.birthday
            .subscribe(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                
                // 구독 전 emit
                year.accept(component.year!)
                month.accept(component.month!)
                day.accept(component.day!)
            }
            .disposed(by: disposeBag)
        
        let isValidDate = Observable.combineLatest(year, month, day) { year, month, day in
            // 생일로부터 17년이 지났는지 확인
            guard let birthDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: day)),
                  let minimumDate = Calendar.current.date(byAdding: .year, value: -17, to: Date()) else {
                return false
            }
            return birthDate <= minimumDate
        }
        
        return Output(year: year.asDriver().map { "\($0)년" },
                      month: month.asDriver().map { "\($0)월" },
                      day: day.asDriver().map { "\($0)일" },
                      isValidDate: isValidDate.asDriver(onErrorJustReturn: false)
        )
    }
}
