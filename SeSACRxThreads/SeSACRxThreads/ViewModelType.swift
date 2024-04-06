//
//  ViewModelType.swift
//  SeSACRxThreads
//
//  Created by 박희지 on 4/6/24.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    func transform(_ input: Input) -> Output
}
