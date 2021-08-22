//
//  UserViewController.swift
//  UserAuthTask
//
//  Created by Lukasz Dziwosz on 22/08/2021.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var telephoneLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        <#code#>
    }
    
    @IBAction func logoutBtnAction(_ sender: Any) {
    }
}
