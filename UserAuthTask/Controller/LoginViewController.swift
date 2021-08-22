//
//  ViewController.swift
//  UserAuthTask
//
//  Created by Lukasz Dziwosz on 22/08/2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    let alertService = AlertService()
    let networking = Networking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        guard let username = username.text, let password = password.text else {return}
        
        loginRequest(username: username, password: password)
        }
    
    func loginRequest(username: String, password: String) {
        let parameters = ["username": username,
                          "password": password]
        networking.requestToken(endpoint: "/credentials", parameters: parameters) { [weak self] (result) in
            switch result {

            case .success(let tokens): self?.succesfullResponse(tokens: tokens)
            case.failure(let error):
                print(error.localizedDescription)
                guard let alert = self?.alertService.alert(message: "Please input correct credentials") else { return }
                self?.present(alert, animated: true)
            }
        }
    }
    func succesfullResponse(tokens: Tokens){
        let defaults = UserDefaults.standard
        defaults.setValue(tokens.token, forKey: "jsonwebtoken")
        defaults.setValue(tokens.refreshToken, forKey: "refreshtoken")
      //  performSegue(withIdentifier: "loginSegue", sender: tokens)
      
        
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
