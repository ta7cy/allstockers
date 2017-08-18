//
//  stock.swift
//  Allstockers
//
//  Created by tanahashishinhichi on 2017/08/16.
//  Copyright © 2017年 ta7cy. All rights reserved.
//

import RealmSwift

class Stock: Object{

    dynamic var id = 0
    
    dynamic var type = 99
    
    dynamic var stockid = ""
    
    dynamic var stockname = ""
    
    dynamic var getprice = 0

    dynamic var numofhold = 0
    
    dynamic var getdate = Date()
    
    dynamic var numofsale = 0 // 売却価格
    
    dynamic var saledate = Date()
    
    dynamic var tax = 0
    
    dynamic var dividend = 0
    
    dynamic var dividenddate = Date()

    dynamic var latestprice = 0
    
    dynamic var regidate = Date()
    
    dynamic var pricedate = Date()

    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }

}
