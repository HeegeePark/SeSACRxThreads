//
//  SampleViewController.swift
//  SeSACRxThreads
//
//  Created by 박희지 on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SampleViewController: UIViewController {
    private let textField = SignTextField(placeholderText: "추가할 내용을 입력해주세요")
    
    private let addButton = {
        let view = UIButton()
        view.setTitle("추가", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .black
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let tableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        return view
    }()
    
    private let viewModel = SampleViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        bind()
    }
    
    func bind() {
        let input = SampleViewModel.Input(
            itemSelected: PublishSubject<Int>(),
            textFieldText: PublishSubject<String>(),
            addButtonTap: PublishSubject<Void>()
        )
        
        textField.rx.text.orEmpty
            .bind(to: input.textFieldText)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: input.addButtonTap)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: input.itemSelected)
            .disposed(by: disposeBag)
        
        let output = viewModel.transform(input)
        
        output.items
            .bind(to: tableView.rx.items(cellIdentifier: "tableViewCell", cellType: UITableViewCell.self)) { row, element, cell  in
                cell.textLabel?.text = element
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(textField)
        view.addSubview(addButton)
        view.addSubview(tableView)
        
        textField.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
            make.trailing.equalTo(addButton.snp.leading).offset(-10)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
