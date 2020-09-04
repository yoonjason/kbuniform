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
    let authContext = LAContext()
    var message : String?
    var error : NSError?

    override func viewDidLoad() {
        super.viewDidLoad()
        loginBtn
            .rx
            .tap
            .subscribe(onNext : {
                self.requestLogin()
            })
            .disposed(by: rx.disposeBag)
        self.successStatusLabel.text = "본인 인증해주세요."
    }
    
    private func requestLogin(){
        
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            switch authContext.biometryType {
            case .faceID:
                message = "계정 정보를 열람하기 위해서 Face ID로 인증합니다."
            case .touchID :
                message = "계정 정보를 열람하기 위해서 Touch ID로 인증합니다."
            case .none :
                message = "계정 정보를 열람하기 위해서는 로그인하십시오"
                
            }
            
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: message!) { (isSUccess, error) in
                if isSUccess {
                    print("인증성공")
                    DispatchQueue.main.async {
                        self.successStatusLabel.textColor = .red
                        self.successStatusLabel.text = "인증 성공"
                    }
                    
                }else {
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }else {
            let errorDescripiton = error?.userInfo["NSLocalizedDescription"] ?? ""
            print(errorDescripiton)
            
            let alert = UIAlertController(title: "Authentication Required", message: message, preferredStyle: .alert)
            weak var usernameTextField : UITextField!
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "USer ID"
                usernameTextField = textField
            })
            weak var passwordTextField : UITextField!
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
                passwordTextField = textField
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Log in", style: .destructive, handler: { action in
                print(usernameTextField.text! + "\n" + passwordTextField.text!)
            }))
            self.present(self, animated: true, completion: nil)
        }
    }

}
