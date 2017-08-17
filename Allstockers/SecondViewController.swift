//
//  SecondViewController.swift
//  Allstockers
//
//  Created by tanahashishinhichi on 2017/08/15.
//  Copyright © 2017年 ta7cy. All rights reserved.
//

import UIKit
import RealmSwift

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableView: UITableView!
    var type = 0
    
    let realm = try! Realm()
    var stockArray = try! Realm().objects(Stock.self).filter("type == 0")
    
    @IBAction func segmentButton(_ sender: UISegmentedControl) {
 
        
        switch sender.selectedSegmentIndex {
        case 0:
            type = 0
            print("select 所有株")
            
        case 1:
            type = 1
            print("select 売却済")
            
        case 2:
            type = 2
            print("select 配当")
            
        default:
            print("選択なし")

        }
        stockArray = try! Realm().objects(Stock.self).filter("type == " + String(type))
        tableView.reloadData()
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockArray.count
    }
    
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let stock = stockArray[indexPath.row]
        
        var title = ""
        var subTitle = ""
        var profits = 0
        
        switch type {
        case 0:
            profits = (stock.latestprice - stock.getprice) * stock.numofhold
            title = stock.stockid + "------/収益" + String(profits)
            subTitle = "取得単価:" + String(stock.getprice) + "/取得数" + String(stock.numofhold) + "/現在価格" + String(stock.latestprice)

        case 1:
            profits = 0
            title = stock.stockid + "/売却収益"
            subTitle = "取得単価:" + String(stock.getprice) + "/取得数" + "/売却単価" + "非課税"
           
        case 2:
            title = stock.stockid + "------/配当益" + String(stock.dividend)
            subTitle = ""
            
        default:
            print("xxx")
        }
        

        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subTitle
        
        return cell
    }
    
    // MARK: UITableViewDelegateプロトコルのメソッド
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil)
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete{
            
            try! realm.write{
                
                self.realm.delete(self.stockArray[indexPath.row])
                tableView.deleteRows(at: [indexPath as IndexPath], with:UITableViewRowAnimation.fade)
            }
        }
        
    }
    
    //inputへの遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.stock = stockArray[indexPath!.row]
        } else {
            let stock = Stock()
            if stockArray.count != 0 {
                stock.id = stockArray.max(ofProperty: "id")! + 1
            }
            print("Debug_stockArray.count")
            print(stockArray.count)
            
            inputViewController.stock = stock
        }
    }

}

