//
//  AppleSignInViewController.swift
//  kbuniform
//
//  Created by twave on 2020/09/07.
//  Copyright © 2020 seokyu. All rights reserved.
//

import UIKit
import AuthenticationServices

enum UserdefaultString: String {
    case Email = "email"
    case Token = "token"
    case Name = "name"
    case SIGNIN = "signin"
}


class AppleSignInViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var signoutBtn: UIButton!
    
    @available(iOS 13.0, *)
    @IBAction func onActionSignout(_ sender: Any) {
        showAlert()
    }


    @available(iOS 13.0, *)
    lazy var signInBtn = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
    let userDefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        setAppleLoginButton()
        let isSigned = userDefault.bool(forKey: UserdefaultString.SIGNIN.rawValue)
        if #available(iOS 13.0, *) {
            if isSigned {
                signInBtn.isHidden = true
                signoutBtn.isHidden = false
                if let email = userDefault.object(forKey: UserdefaultString.Email.rawValue) as? String, let token = userDefault.object(forKey: UserdefaultString.Token.rawValue) as? String, let name = userDefault.object(forKey: UserdefaultString.Name.rawValue) as? String {
                    setLabels(name: name, token: token, email: email)
                }
            }else {
                setLabels(name: "", token: "", email: "")
                signInBtn.isHidden = false
                signoutBtn.isHidden = true
            }
        }
    }

    func setAppleLoginButton() {
        if #available(iOS 13.0, *) {
            //            let appleLoginBtn = ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)
            signInBtn.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
            self.view.addSubview(signInBtn)
            // Setup Layout Constraints to be in the center of the screen
            signInBtn.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                signInBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                signInBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                signInBtn.widthAnchor.constraint(equalToConstant: 200),
                signInBtn.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
    }

    @available(iOS 13.0, *)
    @objc func actionHandleAppleSignin() {
        print(#function)
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self as? ASAuthorizationControllerDelegate
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
    
    @available(iOS 13.0, *)
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            let loginText = "로그인이 필요한 서비스입니다."
            self.setLabels(name: "", token: "", email: loginText)
            self.signoutBtn.isHidden = true
            
            self.signInBtn.isHidden = false
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setLabels(name : String, token : String, email : String) {
        nameLabel.text = name
        tokenLabel.text = token
        emailLabel.text = email
    }

}

extension AppleSignInViewController: ASAuthorizationControllerDelegate {

    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print(#function)
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let user = credential.user
            print("User : \(user)")
            guard let email = credential.email, let familyName = credential.fullName?.familyName, let givenName = credential.fullName?.givenName else {
                //이메일과 이름이 없을 때, 다시 말해서 해당 애플 아이디로 재로그인
                userDefault.set(true, forKey: UserdefaultString.SIGNIN.rawValue)
                signInBtn.isHidden = true
                signoutBtn.isHidden = false
                return
            }

            let name = givenName + familyName
            print(email, name)
            userDefault.set(email, forKey: UserdefaultString.Email.rawValue)
            userDefault.set(user, forKey: UserdefaultString.Token.rawValue)
            userDefault.set(name, forKey: UserdefaultString.Name.rawValue)
            userDefault.set(true, forKey: UserdefaultString.SIGNIN.rawValue)
            signInBtn.isHidden = true
            signoutBtn.isHidden = false

            if let token = userDefault.object(forKey: UserdefaultString.Token.rawValue) as? String {
                tokenLabel.text = token
            }

            if let name = userDefault.object(forKey: UserdefaultString.Name.rawValue) as? String {
                nameLabel.text = name
            }

            if let email = userDefault.object(forKey: UserdefaultString.Email.rawValue) as? String {
                emailLabel.text = email
            }

            print("email : \(email), fullName: \(name), \(#function), \(#line)")
            print("최초로그인")
        }
    }

    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}
