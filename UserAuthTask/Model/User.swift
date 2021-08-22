//
//  Users.swift
//  UserAuthTask
//
//  Created by Lukasz Dziwosz on 22/08/2021.
//

import Foundation

struct User: Decodable {
    let uuid: String
    let image: String
    let firstName: String
    let lastName: String
    let address: String
    let phone: String
}
