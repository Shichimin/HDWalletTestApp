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
        button.setBackgroundColor(.gray, for: .highlighted)
        button.setTitle("Genereating...", for: .highlighted)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // Timer
        let start = Date()
        
        // Stretching
        var passphrase = textfield.text!
        for _ in 1...10000 {
            passphrase = passphrase.sha256()
        }
        
        let elapsed = Date().timeIntervalSince(start)
        print(elapsed)
        
        // Generate seed
        let seed = Mnemonic.createSeed(mnemonic: passphrase)
        print("====Hexadecimal notation====")
        print(seed.toHexString())
        
//        // Generate Hierarchical Deterministic
//        // BIP44 key derivation
//        let privateKey = PrivateKey(seed: seed, network: Network.main(.bitcoin))
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
//
//        // Generate Wallet
//        let wallet = Wallet(seed: firstPrivateKey.chainCode, network: Network.main(.bitcoin))
//        let myAccount = wallet.generateAccount()
//
//        print("====rawPublicKey====")
//        print(myAccount.rawPublicKey)
//        print("====bitcoinAddress====")
//        print(myAccount.address)
//        print("====rawPrivateKey====")
//        print(myAccount.rawPrivateKey)
//        print("=====privateKey=====")
//        print(myAccount.privateKey)
        
        // Gnerate Wallet (passphrase to Wallet)
        let wallet = Wallet(seed: seed, network: Network.main(.bitcoin))
        let myAccount = wallet.generateAccount()
        
        print("====rawPublicKey====")
        print(myAccount.rawPublicKey)
        print("====bitcoinAddress====")
        print(myAccount.address)
        print("====rawPrivateKey====")
        print(myAccount.rawPrivateKey)
        print("=====privateKey=====")
        print(myAccount.privateKey)
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let image = color.image
        setBackgroundImage(image, for: state)
    }
}

extension UIColor {
    var image: UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setFillColor(self.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

