//
//  ViewController.swift
//  UserAuthTask
//
//  Created by Lukasz Dziwosz on 22/08/2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    let alertService = AlertService()
    let networking = Networking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        submitButton.layer.cornerRadius = 5
        logoImageView.layer.cornerRadius = 5
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        passwordTextField.endEditing(true) //triger
        }
    
    func loginRequest(username: String, password: String) {
        let parameters = ["username": username,
                          "password": password]
        networking.requestToken(endpoint: "/credentials", parameters: parameters) { [weak self] (result) in
            switch result {
            case .success(let tokens): self?.succesfullResponse(tokens: tokens)
            case.failure(let error):
                print(error.localizedDescription)
                guard let alert = self?.alertService.alert(message: "Please input correct credentials", handler: { _ in
                    //might do something when alert dismiss
                }) else { return }
                self?.present(alert, animated: true)
            }
        }
    }
    func succesfullResponse(tokens: Tokens){
        let defaults = UserDefaults.standard
        defaults.setValue(tokens.token, forKey: "jsonwebtoken")
        defaults.setValue(tokens.refreshToken, forKey: "refreshtoken")
        performSegue(withIdentifier: "loginSegue", sender: tokens)
        }
}
extension UITextField {
    @IBInspectable var placeholderColor: UIColor {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
        }
        set {
            guard let attributedPlaceholder = attributedPlaceholder else { return }
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue]
            self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
        }
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if passwordTextField.text != "" {
            return true
        }else {
           passwordTextField.placeholder = "Password"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
         guard let username = self.usernameTextField.text, let password = self.passwordTextField.text else {return}
        loginRequest(username: username, password: password)
        self.passwordTextField.text = ""
        self.usernameTextField.text = ""
        
    }
}
