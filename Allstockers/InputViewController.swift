//
//  InputViewController.swift
//  Allstockers
//
//  Created by tanahashishinhichi on 2017/08/15.
//  Copyright © 2017年 ta7cy. All rights reserved.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController {
    
    
    //form
    @IBOutlet weak var holdFormLabel1: UILabel!
    @IBOutlet weak var holdFormTextField1: UITextField!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!

    @IBOutlet weak var numberOfHoldLabel: UILabel!
    @IBOutlet weak var numberOfHoldTextField: UITextField!
    
    @IBOutlet weak var numberOfSaleLabel: UILabel!
    @IBOutlet weak var numberOfSaleTextField: UITextField!
    
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var taxTextField: UITextField!
    
    @IBOutlet weak var dividendLabel: UILabel!
    @IBOutlet weak var dividendTextField: UITextField!

    @IBOutlet weak var fixButtonLabel: UIButton!
    
    //DB
    let realm = try! Realm()
    var stock : Stock!
    
    //入力のタイプ 0-2 99はダミー
    var type: Int = 99
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formUnvisivle()

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        //入力タイプによって、初期表示を変える
        type = stock.type
        
        switch type {
        case 0:
            print("0")
        case 1:
            print("1")
        case 2:
            print("2")
        case 99:
            print("new stock")
        default:
            print("default")
        
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func segmentButton(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            formUnvisivle()
            holdFormVisible()
            type = 0
            
        case 1:
            formUnvisivle()
            saleFormVisible()
            type = 1
            
        case 2:
            
            formUnvisivle()
            dividendFormVisible()
            type = 2
            
        default:
            print("該当無し")
        }
        
        
    }
    
    //登録ボタンを押した時のアクション
    @IBAction func FixButtonAction(_ sender: Any) {
        
        self.stock.type = type
        self.stock.stockid = self.holdFormTextField1.text!
        print("Debug_stock.id",stock.id)
        
        switch type{
        case 0: // hold
            
             print("type 0")
             self.savePrice(code: self.holdFormTextField1.text!)
            
        case 1: // sale
            
            print("type1")
            
            try! realm.write {
                self.stock.getprice = Int(self.priceTextField.text!)!
                self.stock.numofhold = Int(self.numberOfHoldTextField.text!)!
                self.stock.numofsale = Int(self.numberOfSaleTextField.text!)!
                self.realm.add(self.stock, update: true)
            }
            //close
            self.navigationController?.popViewController(animated: true)
            
        case 2: // dividend
            
            print("type2")
            
            try! realm.write {
                
                self.stock.dividend = Int(self.dividendTextField.text!)!
                self.realm.add(self.stock, update: true)
            }
            //close
            self.navigationController?.popViewController(animated: true)
            
        default:
            print(type)
            //close
            self.navigationController?.popViewController(animated: true)
            
        }
        
        

    }
    
    func savePrice(code: String){
        
        //let code = "6049"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string:"https://www.google.com/finance/getprices?q=" + code + "&i=300&p=60m&f=d,c")
    
        let task = session.dataTask(with: url!){ (data, response, error) in
            if (error == nil){
                print("noerror")
                let pricerawdata = String(data: data!, encoding: .utf8)!
                print(pricerawdata)
                let dataArray = pricerawdata.components(separatedBy: "\n")
                print(dataArray)
                let dataArray2 = dataArray[dataArray.count-2].components(separatedBy: ",")
                print(dataArray2)
                
                let result:Int = Int(dataArray2.last!)!
                print("result:",result)
                
                self.stock.latestprice = result
                print("stock.latestprice:",self.stock.latestprice)
                
                DispatchQueue.main.async {
                    
                    try! self.realm.write {
                        
                        self.stock.getprice = Int(self.priceTextField.text!)!
                        self.stock.numofhold = Int(self.numberOfHoldTextField.text!)!
                        self.realm.add(self.stock, update: true)
                    }
                    //close
                    self.navigationController?.popViewController(animated: true)
                }
                
            } else{
                
                print("error")
                self.navigationController?.popViewController(animated: true)
                
            }
            
        }
        task.resume()
    
    }
    
    
    /*
    func getPrice(code: String) -> Bool {
     
        var flag : Bool = false
     
        print(code)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string:"https://www.google.com/finance/getprices?q=" + code + "&i=300&p=60m&f=d,c")
        
        
        
        let task = session.dataTask(with: url!){ (data, response, error) in
            if (error == nil){
                print("noerror")
                let pricerawdata = String(data: data!, encoding: .utf8)!
                print(pricerawdata)
                let dataArray = pricerawdata.components(separatedBy: "\n")
                print(dataArray)
                let dataArray2 = dataArray[dataArray.count-2].components(separatedBy: ",")
                print(dataArray2)
                
                let result:Int = Int(dataArray2.last!)!
                print("result:",result)
                
                self.stock.latestprice = result
                print("stock.latestprice:",self.stock.latestprice)
                
                
            } else{
                
                print("error")
                flag = false
                
            }
            
        }
        task.resume()
        
        return flag
    }
*/
    
    
    
    func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    

    //form を非表示
    func formUnvisivle(){
        
        holdFormLabel1.isHidden = true
        holdFormTextField1.isHidden = true
        
        priceLabel.isHidden = true
        priceTextField.isHidden = true
        
        numberOfHoldLabel.isHidden = true
        numberOfHoldTextField.isHidden = true
        
        numberOfSaleLabel.isHidden = true
        numberOfSaleTextField.isHidden = true
        
        taxLabel.isHidden = true
        taxTextField.isHidden = true
        
        dividendLabel.isHidden = true
        dividendTextField.isHidden = true
        
        fixButtonLabel.isHidden = true
        
    }
    
    func holdFormVisible(){
        
        holdFormLabel1.isHidden = false
        holdFormTextField1.isHidden = false
        
        priceLabel.isHidden = false
        priceTextField.isHidden = false
        
        numberOfHoldLabel.isHidden = false
        numberOfHoldTextField.isHidden = false
        
        fixButtonLabel.isHidden = false
    
    }

    func saleFormVisible(){

        holdFormLabel1.isHidden = false
        holdFormTextField1.isHidden = false
        
        priceLabel.isHidden = false
        priceTextField.isHidden = false
        
        numberOfHoldLabel.isHidden = false
        numberOfHoldTextField.isHidden = false
        
        numberOfSaleLabel.isHidden = false
        numberOfSaleTextField.isHidden = false
        
        taxLabel.isHidden = false
        taxTextField.isHidden = false
        
        fixButtonLabel.isHidden = false
        

        
    }
    func dividendFormVisible(){
        
        holdFormLabel1.isHidden = false
        holdFormTextField1.isHidden = false
        
        dividendLabel.isHidden = false
        dividendTextField.isHidden = false
        
        fixButtonLabel.isHidden = false
        
    }
    
    
    
}
