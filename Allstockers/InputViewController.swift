//
//  InputViewController.swift
//  Allstockers
//
//  Created by tanahashishinhichi on 2017/08/15.
//  Copyright © 2017年 ta7cy. All rights reserved.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var formStackView: UIStackView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //form
    @IBOutlet weak var stockidStackView: UIStackView!
    @IBOutlet weak var holdFormLabel1: UILabel!
    @IBOutlet weak var holdFormTextField1: UITextField!
    
    @IBOutlet weak var stockNameStackView: UIStackView!
    @IBOutlet weak var stcokNameTextField: UITextField!
    
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var numberOfHoldStackView: UIStackView!
    @IBOutlet weak var numberOfHoldLabel: UILabel!
    @IBOutlet weak var numberOfHoldTextField: UITextField!
    
    @IBOutlet weak var getStockDateStackView: UIStackView!
    @IBOutlet weak var getStockDateTextField: UITextField!
    
    @IBOutlet weak var numberOfSaleStackView: UIStackView!
    @IBOutlet weak var numberOfSaleLabel: UILabel!
    @IBOutlet weak var numberOfSaleTextField: UITextField!
    
    @IBOutlet weak var saleStockDateStackView: UIStackView!
    @IBOutlet weak var saleDateTextField: UITextField!
    
    @IBOutlet weak var taxStackView: UIStackView!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var taxSegmentdControl: UISegmentedControl!

    @IBOutlet weak var dividendStackView: UIStackView!
    @IBOutlet weak var dividendLabel: UILabel!
    @IBOutlet weak var dividendTextField: UITextField!
    
    @IBOutlet weak var dividendDateStackView: UIStackView!
    @IBOutlet weak var dividendDateTextField: UITextField!
    
    @IBOutlet weak var fixButtonLabel: UIButton!
    
    //date
    let nowDate = Date()
    let dateFormat = DateFormatter()
    let inputHoldDatePicker = UIDatePicker()
    let inputSaleDatePicker = UIDatePicker()
    let inputDividendDatePicker = UIDatePicker()
    
    
    //DB
    let realm = try! Realm()
    var stock : Stock!
    
    //入力のタイプ 0-2 99はダミー
    var type: Int = 99
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        self.priceTextField.keyboardType = .numberPad
        self.numberOfHoldTextField.keyboardType = .numberPad
        self.numberOfSaleTextField.keyboardType = .numberPad
        self.dividendTextField.keyboardType = .numberPad
        
        dateFormat.dateFormat = "yyyy年MM月dd日"
        print("dividend:",self.dividendTextField.text ?? "aaa")
    
        //入力タイプによって、初期表示を変える
        type = stock.type
        if type < 3 {
            segmentedControl.selectedSegmentIndex = type
            segmentedControl.isHidden = true
            fixButtonLabel.setTitle("修正", for: .normal)
            holdFormTextField1.text = stock.stockid
            stcokNameTextField.text = stock.stockname
            
        }
        
        switch type {
        case 0:
            print("0")
            holdFormVisible()
            priceTextField.text = String(stock.getprice)
            numberOfHoldTextField.text = String(stock.numofhold)
            getStockDateTextField.text = dateFormat.string(from: stock.getdate)
            inputHoldDatePicker.date = stock.getdate
            
        case 1:
            print("1")
            saleFormVisible()
            priceTextField.text = String(stock.getprice)
            numberOfHoldTextField.text = String(stock.numofhold)
            getStockDateTextField.text = dateFormat.string(from: stock.getdate)
            inputHoldDatePicker.date = stock.getdate
            numberOfSaleTextField.text = String(stock.numofsale)
            saleDateTextField.text = dateFormat.string(from: stock.saledate)
            inputSaleDatePicker.date = stock.saledate
            taxSegmentdControl.selectedSegmentIndex = stock.tax

        case 2:
            print("2")
            dividendFormVisible()
            dividendTextField.text = String(stock.dividend)
            dividendDateTextField.text = dateFormat.string(from: stock.dividenddate)
            inputDividendDatePicker.date = stock.dividenddate

        case 99:
            print("new stock")
            formStackView.isHidden = true
            //日付フィールドの設定

            getStockDateTextField.text = dateFormat.string(from: nowDate)
            self.getStockDateTextField.delegate = self as UITextFieldDelegate
            
            saleDateTextField.text = dateFormat.string(from: nowDate)
            self.saleDateTextField.delegate = self as UITextFieldDelegate
            
            dividendDateTextField.text = dateFormat.string(from: nowDate)
            self.dividendDateTextField.delegate = self as UITextFieldDelegate
            
        
        default:
            print("default")
        }
        
        // DatePickerの設定(日付用)
        inputHoldDatePicker.datePickerMode = UIDatePickerMode.date
        inputSaleDatePicker.datePickerMode = UIDatePickerMode.date
        inputDividendDatePicker.datePickerMode = UIDatePickerMode.date
        getStockDateTextField.inputView = inputHoldDatePicker
        saleDateTextField.inputView = inputSaleDatePicker
        dividendDateTextField.inputView = inputDividendDatePicker
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func segmentButton(_ sender: UISegmentedControl) {
        
        formStackView.isHidden = false
        
        switch sender.selectedSegmentIndex {
        case 0:
            holdFormVisible()
            type = 0
            
        case 1:
            saleFormVisible()
            type = 1
            
        case 2:
            
            dividendFormVisible()
            type = 2
            
        default:
            print("該当無し")
        }
        
        
    }
    
    //登録ボタンを押した時のアクション
    @IBAction func FixButtonAction(_ sender: Any) {
        
        print("Debug_stock.id",stock.id)
        
        switch type{
        case 0: // hold ////////////////////////////////////////

            print("type 0")

            if (self.priceTextField.text != "") && (self.numberOfHoldTextField.text != "") {
           
                self.savePrice(code: self.holdFormTextField1.text!)

            } else{
                print("フォームに空あり")
                myAlert(title: "登録失敗", text: "全て入力してください")
                
            }
        case 1: // sale ////////////////////////////////////////
            
            print("type1")
            
            if(self.priceTextField.text == "") || (self.numberOfHoldTextField.text == "") || (self.numberOfSaleTextField.text == ""){
                
                myAlert(title: "登録失敗", text: "全て入力してください")

            } else {
            
                try! realm.write {
                    self.stock.type = type
                    self.stock.stockid = self.holdFormTextField1.text!
                    self.stock.stockname = self.stcokNameTextField.text!
                    self.stock.regidate = Date()
                    
                    self.stock.getprice = Int(self.priceTextField.text!) ?? 0
                    self.stock.getdate = self.inputHoldDatePicker.date
                    self.stock.numofhold = Int(self.numberOfHoldTextField.text!) ?? 0
                    self.stock.numofsale = Int(self.numberOfSaleTextField.text!) ?? 0
                    self.stock.saledate = inputSaleDatePicker.date
                    self.stock.tax = taxSegmentdControl.selectedSegmentIndex
                    
                    self.realm.add(self.stock, update: true)
                }
                //close
                self.navigationController?.popViewController(animated: true)
            }
            
        case 2: // dividend //////////////////////////////////////
            
            print("type2")
            
            
            if self.dividendTextField.text == "" {
            
                myAlert(title: "登録失敗", text: "全て入力してください")
            
            } else {
                
                try! realm.write {
                    
                    self.stock.type = type
                    self.stock.stockid = self.holdFormTextField1.text!
                    self.stock.stockname = self.stcokNameTextField.text!
                    self.stock.regidate = Date()
                    self.stock.dividend = Int(self.dividendTextField.text!) ?? 0
                    self.stock.dividenddate = inputDividendDatePicker.date
                    self.realm.add(self.stock, update: true)
                }
                //close
                self.navigationController?.popViewController(animated: true)
                
            }
        default: //////////////////////////////////////
            print(type)
            //close
            self.navigationController?.popViewController(animated: true)
            
        }
        
        

    }
    
    func savePrice(code: String){
        
        dismissKeyboard()
        
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
                
                if ( Int(dataArray2.last!) != nil) {

                    let result = Int(dataArray2.last!)!
                    print("result:",result)
                    
                    DispatchQueue.main.async {
                        
                        try! self.realm.write {
                            
                            self.stock.latestprice = result
                            print("stock.latestprice:",self.stock.latestprice)
                            
                            self.stock.type = self.type
                            self.stock.stockid = self.holdFormTextField1.text!
                            self.stock.stockname = self.stcokNameTextField.text!
                            self.stock.regidate = Date()
                            
                            self.stock.getprice = Int(self.priceTextField.text!) ?? 0
                            self.stock.getdate = self.inputHoldDatePicker.date
                            self.stock.numofhold = Int(self.numberOfHoldTextField.text!) ?? 0
                            self.stock.pricedate = Date()
                            self.realm.add(self.stock, update: true)
                        }
                        //close
                        self.navigationController?.popViewController(animated: true)
                    }
                } else{
                    print("error")
                    /*
                    let alertController = UIAlertController(title: "Alert",message: "銘柄コードが不正です", preferredStyle: UIAlertControllerStyle.alert)
                    let cancelButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alertController.addAction(cancelButton)
                    self.present(alertController,animated: true,completion: nil)
 */
                    
                    self.myAlert(title: "登録失敗", text: "不正な銘柄コードです")
                    
                }
                
            } else{
                print("error")
              
                self.myAlert(title: "登録失敗", text: "ネットワークに繋がっていません")
                
            }
            
        }
        task.resume()
    
    }
    
    func myAlert( title : String, text : String){
    
        let alertController = UIAlertController(title: title ,message: text , preferredStyle: UIAlertControllerStyle.alert)
        let cancelButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelButton)
        self.present(alertController,animated: true,completion: nil)
    
    }
    
    
    func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
        self.getStockDateTextField.text = dateFormat.string(from: inputHoldDatePicker.date)
        self.saleDateTextField.text = dateFormat.string(from: inputSaleDatePicker.date)
        self.dividendDateTextField.text = dateFormat.string(from: inputDividendDatePicker.date)
    }

    func holdFormVisible(){
        
        priceStackView.isHidden = false
        numberOfHoldStackView.isHidden = false
        getStockDateStackView.isHidden = false
        numberOfSaleStackView.isHidden = true
        saleStockDateStackView.isHidden = true
        taxStackView.isHidden = true
        
        dividendStackView.isHidden = true
        dividendDateStackView.isHidden = true
        
    }

    func saleFormVisible(){
        priceStackView.isHidden = false
        numberOfHoldStackView.isHidden = false
        getStockDateStackView.isHidden = false
        numberOfSaleStackView.isHidden = false
        saleStockDateStackView.isHidden = false
        taxStackView.isHidden = false
        
        dividendStackView.isHidden = true
        dividendDateStackView.isHidden = true
        
    }
    func dividendFormVisible(){
        
        priceStackView.isHidden = true
        numberOfHoldStackView.isHidden = true
        getStockDateStackView.isHidden = true
        numberOfSaleStackView.isHidden = true
        saleStockDateStackView.isHidden = true
        taxStackView.isHidden = true
        
        dividendStackView.isHidden = false
        dividendDateStackView.isHidden = false
        
    }
    
    
    
}
