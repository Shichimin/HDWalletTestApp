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
        
        // Generate Hierarchical Deterministic
        let privateKey = PrivateKey(seed: seed, network: Network.main(.bitcoin))
        // BIP44 key derivation
        // m/44'
        let child = privateKey.derived(at: .hardened(44))
        // m/44'/0'
        let grandchild = child.derived(at: .hardened(0))
        // m/44'/0'/0'
        let greatGrandchild = grandchild.derived(at: .hardened(0))
        // m/44'/0'/0'/0
        let greatGreatGrandchild = greatGrandchild.derived(at: .notHardened(0))
        // m/44'/0'/0'/0/0
        let firstPrivateKey = greatGreatGrandchild.derived(at: .notHardened(0))
        
        // Generate Wallet
        let wallet = Wallet(seed: firstPrivateKey.chainCode, network: Network.main(.bitcoin))
        let account = wallet.generateAccount()
        
        print("====rawPublicKey====")
        print(account.rawPublicKey)
        print("====bitcoinAddress====")
        print(account.address)
        print("====rawPrivateKey====")
        print(account.rawPrivateKey)
        print("=====privateKey=====")
        print(account.privateKey)
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

