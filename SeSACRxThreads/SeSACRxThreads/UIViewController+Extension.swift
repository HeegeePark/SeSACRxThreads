//
//  UIViewController+Extension.swift
//  SeSACRxThreads
//
//  Created by 박희지 on 4/8/24.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String, ok: String, handler: (() -> Void)?, showCancel: Bool = false) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: ok, style: .default) { _ in
            handler?()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(ok)
        if showCancel {
            alert.addAction(cancel)
        }
        
        present(alert, animated: true)
    }
}
