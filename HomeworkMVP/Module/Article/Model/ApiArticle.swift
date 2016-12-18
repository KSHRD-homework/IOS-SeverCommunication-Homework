//
//  ApiArticle.swift
//  HomeworkMVP
//
//  Created by Song Seaktheng on 12/15/16.
//  Copyright © 2016 Song Seaktheng. All rights reserved.
//

import Foundation

class ApiArticle{
    
    var apiInterface:APIInterface?
    var pagination:Pagination!
    
    func fetchDataArticle(page:Int, limit:Int, type:String){
        let url=URL(string: "http://120.136.24.174:1301/v1/api/articles?page=\(page)&limit=\(limit)")
        var req=URLRequest(url: url!)
        req.addValue("Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=", forHTTPHeaderField: "Authorization")
        req.addValue("*/*", forHTTPHeaderField: "Accept")
        let session=URLSession.shared
        session.dataTask(with: req, completionHandler: {(body, http, error) in
            if error==nil{
                let jData=try! JSONSerialization.jsonObject(with: body!, options: .allowFragments) as! [String:AnyObject]
                
                let data = jData["DATA"] as! [AnyObject]
                let pageData = jData["PAGINATION"] as! [String:Int]
                var arrayData:[ListData] = []
                print("============== Pagination Test\(pageData)")
                self.pagination = Pagination(JSON: pageData)
                
                for eachData in data {
                    
                    let eachData = eachData as! [String:AnyObject]
                    let listData = ListData()
                    if !(eachData["TITLE"] is NSNull) {
                        listData.title = eachData["TITLE"] as! String
                        arrayData.append(listData)
                    }
                    if !(eachData["DESCRIPTION"] is NSNull) {
                        listData.description = eachData["DESCRIPTION"] as! String
                        arrayData.append(listData)
                    }
                    if !(eachData["IMAGE"] is NSNull){
                        listData.image = eachData["IMAGE"] as! String
                        arrayData.append(listData)
                    }
                    if !(eachData["ID"] is NSNull){
                        listData.id = eachData["ID"] as! Int
                        arrayData.append(listData)
                    }
                }
                
                self.apiInterface?.success(theData: arrayData, pagintion: self.pagination, type:type)
            }
        }).resume()
    }
    
}

protocol APIInterface {
    func success(theData:[ListData], pagintion:Pagination, type:String)
    func error()
}
