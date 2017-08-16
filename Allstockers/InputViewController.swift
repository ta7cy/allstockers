//
//  InputViewController.swift
//  Allstockers
//
//  Created by tanahashishinhichi on 2017/08/15.
//  Copyright © 2017年 ta7cy. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {
    
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
    
    func formUnvisivle(){
        
        holdFormLabel1.isHidden = true
        holdFormTextField1.isHidden = true
        
        //holdFormLabel1.frame.size.height = 0
        //holdFormTextField1.frame.size.height = 0
        
        priceLabel.isHidden = true
        priceTextField.isHidden = true
        
        //priceLabel.frame.size.height = 0
        //priceTextField.frame.size.height = 0
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formUnvisivle()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func segmentButton(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            formUnvisivle()
            
            holdFormLabel1.isHidden = false
            holdFormTextField1.isHidden = false
            
            priceLabel.isHidden = false
            priceTextField.isHidden = false
            
            numberOfHoldLabel.isHidden = false
            numberOfHoldTextField.isHidden = false

            fixButtonLabel.isHidden = false
            
        case 1:
            formUnvisivle()
            
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
            
        case 2:
            
            formUnvisivle()
            holdFormLabel1.isHidden = false
            holdFormTextField1.isHidden = false
        
            dividendLabel.isHidden = false
            dividendTextField.isHidden = false
            
            fixButtonLabel.isHidden = false
            
        default:
            print("該当無し")
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
