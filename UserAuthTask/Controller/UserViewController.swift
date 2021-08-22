//
//  UserViewController.swift
//  UserAuthTask
//
//  Created by Lukasz Dziwosz on 22/08/2021.
//

import UIKit

class UserViewController: UIViewController , UserDataDelegate {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var telephoneLbl: UILabel!
    @IBOutlet weak var logoutBtnOutlet: UIBarButtonItem!
    
    let networking = Networking()
    let alertService = AlertService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networking.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo()
        
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "jsonwebtoken")
        defaults.removeObject(forKey: "refreshtoken")
        performSegue(withIdentifier: "goBackToLogin", sender: (Any).self)
    }
    
    func getUserInfo() {
        
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "jsonwebtoken") else {
            return
        }
        networking.requestUser(endpoint: "/user", token: token) { [weak self] (result) in
            switch result {

            case .success(let userData): print("\(userData)")
            case.failure(let error):
                print(error.localizedDescription)
                guard let alert = self?.alertService.alert(message: "Cannot get user data") else { return }
                self?.present(alert, animated: true)
            }
        }
    }
    func didGetData(_ userData: User) {
        DispatchQueue.main.async {
            self.fullNameLbl.text = "\(userData.firstName) \(userData.lastName)"
            self.addressLbl.text = userData.address
            self.telephoneLbl.text = userData.phone
            }
            if let url = URL(string: userData.image) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async {
                    self.userImageView.image = UIImage(data: data)
                }
            }
            
            task.resume()
        }
        
    }
    
}

