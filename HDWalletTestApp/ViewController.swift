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
    
    // Labels
    var destinationUserLabel: UILabel!
    var walletLabel: UILabel!
    var passwordLabel: UILabel!
    var amountOfRemittanceLabel: UILabel!
    var BTCLable1: UILabel!
    var BTCLable2: UILabel!
    var balanceLabel: UILabel!
    var balanveNumLabel: UILabel!
    
    // TextFields
    var inputPasswordTextField: UITextField!
    var amountOfRemittanceTextField: UITextField!
    var walletTextField: UITextField!
    
    // Button
    var button: UIButton!
    
    // counter
    var walletNumer: Int = 0
    
    // Lists
    let usersList: [String] = ["ユーザA", "ユーザB", "ユーザC", "ユーザD", "ユーザE"]
    var walletsList: [wallet] = []

    
    // PickerViews
    var pickerViewDestinationTextField: UITextField!
    var pickerViewWalletTextField: UITextField!
    
    // PickerView
    let pickers: [UIPickerView] = [
        UIPickerView(),
        UIPickerView()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // walletsListの初期化
        walletsList = [wallet(name: "ウォレット1", amount: 2.00, password: "hoge1"),
                       wallet(name: "ウォレット2", amount: 2.50, password: "hoge2"),
                       wallet(name: "ウォレット3", amount: 1.50, password: "hoge3")]
        
        // PickerView
        pickers.forEach({
            $0.delegate = self
            $0.dataSource = self
            $0.showsSelectionIndicator = true
        })
        
        // 宛先ユーザ表示用ラベル
        destinationUserLabel = UILabel()
        destinationUserLabel.text = "宛先ユーザ："
        destinationUserLabel.frame = CGRect(x: 40, y: 50, width: 700, height: 70)
        destinationUserLabel.font = UIFont.systemFont(ofSize: 35.0)
        self.view.addSubview(destinationUserLabel)
        
        // 送金額表示用ラベル
        amountOfRemittanceLabel = UILabel()
        amountOfRemittanceLabel.text = "送金額："
        amountOfRemittanceLabel.frame = CGRect(x: 310, y: 230, width: 350, height: 70)
        amountOfRemittanceLabel.font = UIFont.systemFont(ofSize: 35.0)
        self.view.addSubview(amountOfRemittanceLabel)
        
        // 送金額テキストフィールド
        amountOfRemittanceTextField = UITextField()
        amountOfRemittanceTextField.keyboardType = UIKeyboardType.numberPad
        amountOfRemittanceTextField.textAlignment = .right
        amountOfRemittanceTextField.frame = CGRect(x: 450, y: 240, width: 200, height: 50)
        amountOfRemittanceTextField.delegate = self
        amountOfRemittanceTextField.borderStyle = .roundedRect
        amountOfRemittanceTextField.clearButtonMode = .whileEditing
        amountOfRemittanceTextField.returnKeyType = .done
        amountOfRemittanceTextField.font = UIFont.systemFont(ofSize: 35.0)
        amountOfRemittanceTextField.text = "0.00"
        self.view.addSubview(amountOfRemittanceTextField)
        
        // BTC表示ラベル1
        BTCLable1 = UILabel()
        BTCLable1.text = "BTC"
        BTCLable1.frame = CGRect(x: 670, y: 230, width: 200, height: 70)
        BTCLable1.font = UIFont.systemFont(ofSize: 35.0)
        self.view.addSubview(BTCLable1)
        
        // ウォレット表示用ラベル
        walletLabel = UILabel()
        walletLabel.text = "ウォレット："
        walletLabel.frame = CGRect(x: 40, y: 310, width: 700, height: 70)
        walletLabel.font = UIFont.systemFont(ofSize: 35.0)
        self.view.addSubview(walletLabel)
        
        // 残高表示用ラベル
        balanceLabel = UILabel()
        balanceLabel.text = "　残高："
        balanceLabel.frame = CGRect(x: 310, y: 490, width: 350, height: 70)
        balanceLabel.font = UIFont.systemFont(ofSize: 35.0)
        self.view.addSubview(balanceLabel)
        
        // 残高数
        balanveNumLabel = UILabel()
        balanveNumLabel.text = "0.00"
        balanveNumLabel.frame = CGRect(x: 570, y: 490, width: 350, height: 70)
        balanveNumLabel.font = UIFont.systemFont(ofSize: 35.0)
        self.view.addSubview(balanveNumLabel)
        
        // BTC表示ラベル2
        BTCLable2 = UILabel()
        BTCLable2.text = "BTC"
        BTCLable2.frame = CGRect(x: 670, y: 490, width: 200, height: 70)
        BTCLable2.font = UIFont.systemFont(ofSize: 35.0)
        self.view.addSubview(BTCLable2)
        
        // パスワード表示用ラベル
        passwordLabel = UILabel()
        passwordLabel.frame = CGRect(x: 40, y: 0, width: 700, height: 70)
        passwordLabel.center.y = self.view.center.y + 140
        passwordLabel.text = "パスワード："
        passwordLabel.font = UIFont.systemFont(ofSize: 35.0)
        self.view.addSubview(passwordLabel)
        
        // 決定バーの生成
        // ユーザ
        let usersToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 45))
        let usersSpacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let usersDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneUsers))
        usersToolbar.setItems([usersSpacelItem, usersDoneItem], animated: true)
        
        pickerViewDestinationTextField = UITextField()
        pickerViewDestinationTextField.frame = CGRect(x: 0, y: 0, width: 700, height: 80)
        pickerViewDestinationTextField.center.x = self.view.center.x
        pickerViewDestinationTextField.center.y = destinationUserLabel.layer.position.y + 80
        pickerViewDestinationTextField.inputView = pickers[0]
        pickerViewDestinationTextField.text = "宛先ユーザ選択"
        pickerViewDestinationTextField.textAlignment = .center
        pickerViewDestinationTextField.font = UIFont.systemFont(ofSize: 50.0)
        pickerViewDestinationTextField.backgroundColor = UIColor.gray
        pickerViewDestinationTextField.inputAccessoryView = usersToolbar
        self.view.addSubview(pickerViewDestinationTextField)
        
        // ウォレット
        let walletsToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 45))
        let walletsSpacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let walletsDoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneWallets))
        walletsToolbar.setItems([walletsSpacelItem, walletsDoneItem], animated: true)
        
        pickerViewWalletTextField = UITextField()
        pickerViewWalletTextField.frame = CGRect(x: 0, y: 0, width: 700, height: 80)
        pickerViewWalletTextField.center.x = self.view.center.x
        pickerViewWalletTextField.center.y = walletLabel.layer.position.y + 80
        pickerViewWalletTextField.inputView = pickers[1]
        pickerViewWalletTextField.text = "使用ウォレット選択"
        pickerViewWalletTextField.textAlignment = .center
        pickerViewWalletTextField.font = UIFont.systemFont(ofSize: 50.0)
        pickerViewWalletTextField.backgroundColor = UIColor.gray
        pickerViewWalletTextField.inputAccessoryView = walletsToolbar
        self.view.addSubview(pickerViewWalletTextField)
        
        // パスワード
        inputPasswordTextField = UITextField()
        inputPasswordTextField.frame = CGRect(x: 0, y: 0, width: 700, height: 70)
        inputPasswordTextField.center.x = self.view.center.x
        inputPasswordTextField.center.y = passwordLabel.layer.position.y + 80
        inputPasswordTextField.delegate = self
        inputPasswordTextField.borderStyle = .roundedRect
        inputPasswordTextField.clearButtonMode = .whileEditing
        inputPasswordTextField.returnKeyType = .done
        inputPasswordTextField.textAlignment = .center
        inputPasswordTextField.placeholder = "パスワードを入力してください"
        inputPasswordTextField.font = UIFont.systemFont(ofSize: 30.0)
        self.view.addSubview(inputPasswordTextField)
        
        // Generate MoneyTransfer Button
        button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 700, height: 150)
        button.center.x = self.view.center.x
        button.center.y = self.view.center.y + 400
        button.backgroundColor = UIColor.blue
        button.setTitle("送 金", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 100.0)
        button.setBackgroundColor(.gray, for: .highlighted)
        button.setTitle("送 金 中 ...", for: .highlighted)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    // 決定ボタン押下
    @objc func doneUsers() {
        pickerViewDestinationTextField.endEditing(true)
        pickerViewDestinationTextField.text = "\(usersList[pickers[0].selectedRow(inComponent: 0)])"
    }
    
    @objc func doneWallets() {
        pickerViewWalletTextField.endEditing(true)
        pickerViewWalletTextField.text = "\(walletsList[pickers[1].selectedRow(inComponent: 0)].name!)"
        balanveNumLabel.text = NSString(format: "%.2f", walletsList[pickers[1].selectedRow(inComponent: 0)].amount!) as String
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if walletsList[walletNumer].password == inputPasswordTextField.text {
            // Timer
            let start = Date()
            
            // Stretching
            var passphrase = self.inputPasswordTextField.text!
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
            
            // 送金
            self.moneyTransfer()
            
            // 送金終了アラートの表示
            let sucseedAlertController = UIAlertController(title: "送金完了", message: "送金が完了しました", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            }
            sucseedAlertController.addAction(okAction)
            self.present(sucseedAlertController, animated: true, completion: nil)
        } else {
            let nonconformingAlert = UIAlertController(title: "送金エラー", message: "パスワードが違います", preferredStyle: .alert)
            let nonconformingOKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            }
            nonconformingAlert.addAction(nonconformingOKAction)
            present(nonconformingAlert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 送金処理
    func moneyTransfer() {
        let num = Float(amountOfRemittanceTextField.text!)
        walletsList[self.walletNumer].amount = walletsList[self.walletNumer].amount - num!
        balanveNumLabel.text = NSString(format: "%.2f", walletsList[self.walletNumer].amount) as String
        amountOfRemittanceTextField.text = "0.00"
        inputPasswordTextField.text = ""
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

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pickers[0]:
            return 5
            
        case pickers[1]:
            return 3
            
        case let invalid:
            assertionFailure("Unrecognized UIPickerView \(invalid) sent to \(self)")
            return 0
        }
    }
    
    
    // Title
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case pickers[0]:
            return "\(usersList[row])"
            
        case pickers[1]:
            self.walletNumer = row
            return "\(walletsList[row].name!)"

        case let invalid:
            assertionFailure("Unrecognized UIPickerView \(invalid) sent to \(self)")
            return nil
        }
    }
}

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case pickers[0]:
            print("picker A \(row): \(component)")
            
        case pickers[1]:
            print("picker B \(row): \(component)")
            
        case let invalid:
            assertionFailure("Unrecognized UIPickerView \(invalid) sent to \(self)")
        }
    }
}
