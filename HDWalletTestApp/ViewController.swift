//
//  ViewController.swift
//  HDWalletTestApp
//
//  Created by 川上智樹 on 2018/09/20.
//  Copyright © 2018 yatuhasiumai. All rights reserved.
//

import UIKit
import HDWalletKit
import CryptoSwift
import scrypt
import secp256k1

class ViewController: UIViewController, UITextFieldDelegate {
    
    var textfield:UITextField!
    var button:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Generate TexField
        textfield = UITextField()
        textfield.frame = CGRect(x: self.view.frame.width / 2 - 100, y: self.view.frame.height / 2 - 15, width: 200, height: 30)
        textfield.delegate = self
        textfield.borderStyle = .roundedRect
        textfield.clearButtonMode = .whileEditing
        textfield.returnKeyType = .done
        textfield.placeholder = "Please enter your passphrase"
        self.view.addSubview(textfield)
        
        // Generate Button
        button = UIButton()
        button.frame = CGRect(x: self.view.frame.width / 2 - 100, y: self.view.frame.height / 2 + 30, width: 200, height: 30)
        button.backgroundColor = UIColor.blue
        button.setTitle("Generate", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let seed = Mnemonic.createSeed(mnemonic: textfield.text!)
        
        print("====↓16進数表記====")
        print(seed.toHexString())
        
        // Generate Wallet
        let wallet = Wallet(seed: seed, network: Network.main(.bitcoin))
        let account = wallet.generateAccount()
        
        print("====公開鍵====")
        print(account.rawPublicKey)
        print("====ビットコインアドレス====")
        print(account.address)
        print("====秘密鍵====")
        print(account.rawPrivateKey)
        print("=====署名=====")
        print(account.privateKey)
        
//        // HDWallet
//        let privateKey = PrivateKey(seed: seed, network: Network.main(.bitcoin))
//
//        // BIP44 key derivation
//        // m/44'
//        let purpose = privateKey.derived(at: .hardened(44))
//        // m/44'/0'
//        let coinType = purpose.derived(at: .hardened(0))
//        // m/44'/0'/0'
//        let account = coinType.derived(at: .hardened(0))
//        // m/44'/0'/0'/0
//        let change = account.derived(at: .notHardened(0))
//        // m/44'/0'/0'/0/0
//        let firstPrivateKey = change.derived(at: .notHardened(0))
    }
    
}

