//
//  Wallet.swift
//  HDWalletTestApp
//
//  Created by 川上智樹 on 2018/12/06.
//  Copyright © 2018 yatuhasiumai. All rights reserved.
//

import Foundation

class wallet {
    let name: String!
    var amount: Float!
    let password: String!
    
    init(name: String, amount: Float, password: String) {
        self.name = name
        self.amount = amount
        self.password = password
    }
}
