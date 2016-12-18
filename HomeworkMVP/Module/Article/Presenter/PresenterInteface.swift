//
//  PresenterInteface.swift
//  HomeworkMVP
//
//  Created by Song Seaktheng on 12/15/16.
//  Copyright © 2016 Song Seaktheng. All rights reserved.
//

import Foundation

protocol PresenterInteface {
    func errorPresenter()
    func responseData(data: [ListData], pagination:Pagination, type:String)
    func response(data:HTTPURLResponse)
    func successDelete(data:AnyObject)
    func successUpload(data:[String:AnyObject])
    func success(data:[String:AnyObject])
    func errorUpload(data:NSError)
    func error(data:NSError)
    func editSuccess(data:[String:AnyObject])
    func sucess(data:ListData)
    
    
}

class Presenter: APIInterface {
    internal func success(theData: [ListData], pagintion: Pagination) {
       
    }

    
    var delegate:PresenterInteface?
    var model : ApiArticle?
    
    init() {
        self.model = ApiArticle()
        self.model?.apiInterface = self
    }
    
    func success(theData: [ListData], pagintion:Pagination, type:String) {
        delegate?.responseData(data: theData, pagination: pagintion, type:type)
        

    }
    func error() {
        delegate?.errorPresenter()
    }
   
    func getArticle(page: Int, limit: Int, type:String){
        self.model?.fetchDataArticle(page: 1, limit: 4, type:type)
    }
    
    
    func addArticle(article:ListData, imageURL:String){
        let url = URL(string:"http://120.136.24.174:1301/v1/api/articles")
        var httpRequest = URLRequest(url:url!)
        
        httpRequest.allHTTPHeaderFields = ["Content-Type": "application/json","Accept": "*/*", "Authorization": "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ="]
        httpRequest.httpMethod = "POST"
        
        let paramater = [
            
            "TITLE": "\(article.title!)",
            "DESCRIPTION": "\(article.description!)",
            "AUTHOR": 0,
            "CATEGORY_ID": 0,
            "STATUS": "string",
            "IMAGE": "\(imageURL)"
            
            ] as AnyObject
        
        let dataParamater = try! JSONSerialization.data(withJSONObject: paramater, options: [])
        httpRequest.httpBody = dataParamater
        let session = URLSession.shared
        
        session.dataTask(with: httpRequest){
            responseBody, httpResponse, error in
            if error == nil { // if error == nothing it mean data is not nothing
                let json = try! JSONSerialization.jsonObject(with: responseBody!, options: .allowFragments) as! [String : AnyObject]
                print("This is my json body response : \(json)")
                let data = json["DATA"] as! [String : AnyObject]
                article.id = data["ID"] as! Int?
                self.delegate?.sucess(data: article)
            }
            else {
                print("Here is my error response : \(error)")
                
            }
            let httpResponse = httpResponse as! HTTPURLResponse
            if httpResponse.statusCode == 200{
              
            }
            
        
            }.resume()
        
    }

    
    func deleteActicle(id:Int){
        // step 1 create url for request
        let url = URL(string:"http://120.136.24.174:1301/v1/api/articles/\(id)" )
        // step 2 create http Request for prepare httpRequest to server
        var httpRequest = URLRequest(url:url!)
        
        //httpRequest.addValue(HEADER, forHTTPHeaderField: ATHENTICATION) // add header
        //httpRequest.addValue("*/*", forHTTPHeaderField: "Accept") // add Accept header
        httpRequest.httpMethod = "GET" // add method
        
        httpRequest.allHTTPHeaderFields = [
            "Authorization":"Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=",
            "Accept":"*/*"
        ]
        
        
        let session = URLSession.shared
        session.dataTask(with: httpRequest, completionHandler: {(responseBody, httpResponse, error) in
            
            if error == nil { // if error == nothing it mean data is not nothing
                let json = try! JSONSerialization.jsonObject(with: responseBody!, options: .allowFragments) as! [String:AnyObject]
                self.delegate?.successDelete(data: json as AnyObject)
                //print("This is my json body response : \(json)")
            }
            else {
                //print("Here is my error response : \(error)")
                self.delegate?.error(data: error as! NSError)
            }
            if let httpResponse = httpResponse  {
                self.delegate?.response(data: httpResponse as! HTTPURLResponse)
                //print("Here is my response http : \(httpResponse)")
                
            }
        }).resume()
    }
    
    func editArticle(article:ListData, imageURL:String){
        let url = URL(string:"http://120.136.24.174:1301/v1/api/articles/\(article.id!)")
        var httpRequest = URLRequest(url:url!)
        
        httpRequest.allHTTPHeaderFields = ["Content-Type": "application/json","Accept": "*/*", "Authorization": "Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ="]
        httpRequest.httpMethod = "PUT"
        
        let paramater = [
            "TITLE": article.title!,
            "DESCRIPTION": article.description!,
            "AUTHOR": 0,
            "CATEGORY_ID": 0,
            "STATUS": "string",
            "IMAGE": "\(imageURL)"
            ] as AnyObject
        
        let dataParamater = try! JSONSerialization.data(withJSONObject: paramater, options: [])
        httpRequest.httpBody = dataParamater
        let session = URLSession.shared
        
        session.dataTask(with: httpRequest){
            responseBody, httpResponse, error in
            if error == nil { // if error == nothing it mean data is not nothing
                let json = try! JSONSerialization.jsonObject(with: responseBody!, options: .allowFragments) as! [String:AnyObject]
                //print("This is my json body response : \(json)")
                self.delegate?.editSuccess(data: json)
            }
            else {
                //print("Here is my error response : \(error)")
                self.delegate?.error(data: error as! NSError)
            }
            if let httpResponse = httpResponse  {
                //print("Here is my response http : \(httpResponse)")
                self.delegate?.response(data: httpResponse as URLResponse as! HTTPURLResponse)
            }
            }.resume()
    }

    
    func fetchArtical(){
        // step 1 create url for request
        let url = URL(string:"http://120.136.24.174:1301/v1/api/articles?page=1&limit=15")
        // step 2 create http Request for prepare httpRequest to server
        var httpRequest = URLRequest(url:url!)
        
        //httpRequest.addValue(HEADER, forHTTPHeaderField: ATHENTICATION) // add header
        //httpRequest.addValue("*/*", forHTTPHeaderField: "Accept") // add Accept header
        httpRequest.httpMethod = "GET" // add method
        
        httpRequest.allHTTPHeaderFields = [
            "Authorization":"Basic QU1TQVBJQURNSU46QU1TQVBJUEBTU1dPUkQ=",
            "Accept":"*/*"
        ]
        
        
        let session = URLSession.shared
        session.dataTask(with: httpRequest, completionHandler: {(responseBody, httpResponse, error) in
            
            if error == nil { // if error == nothing it mean data is not nothing
                let json = try! JSONSerialization.jsonObject(with: responseBody!, options: .allowFragments) as! [String:AnyObject]
                self.delegate?.success(data: json) // notify when data is respone
                //print("This is my json body response : \(json)")
            }
            else {
                //print("Here is my error response : \(error)")
                self.delegate?.error(data: error as! NSError)
            }
            if let httpResponse = httpResponse  {
                self.delegate?.response(data: httpResponse as! HTTPURLResponse)
                //print("Here is my response http : \(httpResponse)")
                
            }
            
        }).resume()
    }
    

}
