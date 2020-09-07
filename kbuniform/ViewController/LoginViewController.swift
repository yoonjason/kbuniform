//
//  LoginViewController.swift
//  kbuniform
//
//  Created by twave on 2020/09/04.
//  Copyright © 2020 seokyu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import NSObject_Rx
import LocalAuthentication



class LoginViewController: UIViewController {


    @IBOutlet weak var successStatusLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    let authContext                   = LAContext()
    var message: String?
    var error: NSError?

    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn
            .rx
            .tap
            .subscribe(onNext: {
                self.requestLogin()
            })
            .disposed(by: rx.disposeBag)
    self.successStatusLabel.text      = "본인 인증해주세요."
    }

    private func requestLogin() {

        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {

            switch authContext.biometryType {
            case .faceID:
    message                           = "Face ID 인증해주세요."
            case .touchID:
    message                           = "Touch ID로 인증해주세요."
            case .none:
    message                           = "둘 다 안되니 로그인하십시오 X를 눌러 Joy를 표하십시오."

            }

            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: message!) { (isSUccess, error) in
                if isSUccess {
                    print("인증성공")
                    DispatchQueue.main.async {
    self.successStatusLabel.textColor = .red
    self.successStatusLabel.text      = "인증 성공"
                    }

                } else {
    if let error                      = error {
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            print("X를 눌러 Joy를 표하십시오.")
    let errorDescripiton              = error?.userInfo["NSLocalizedDescription"] ?? ""
            print(errorDescripiton)

    let alert                         = UIAlertController(title: "Authentication Required", message: message, preferredStyle: .alert)
            weak var usernameTextField: UITextField!
            alert.addTextField(configurationHandler: { textField in
    textField.placeholder             = "아이디 좀.."
    usernameTextField                 = textField
            })
            weak var passwordTextField: UITextField!
            alert.addTextField(configurationHandler: { textField in
    textField.placeholder             = "비번도 좀 적어주시겠어요?"
    textField.isSecureTextEntry       = true
    passwordTextField                 = textField
            })
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { action in
//                print(usernameTextField.text! + " & " + passwordTextField.text!)

            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

}
