//
//  DataTableViewController.swift
//  HomeworkMVP
//
//  Created by Song Seaktheng on 12/15/16.
//  Copyright © 2016 Song Seaktheng. All rights reserved.
//

import UIKit
import Kingfisher

class DataTableViewController: UITableViewController {
    
    @IBOutlet weak var dataTableView: UITableView!
    var arrayData:[ListData] = []
    var presenter:Presenter?
    let presenterContext = Presenter()
    var paginationContext:Pagination!
    var model = ApiArticle()
   

    var paggingView : UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = Presenter()
        self.presenter?.delegate = self
        self.presenter?.getArticle(page: 1, limit: 10, type: "request")
        //presenterContext.fetchArtical()
        tableView.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
      
    }
    


    @IBAction func uploadMultipleButton(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "multipleSegue", sender: sender)
    }
    
   
 
    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayData.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as? DataTableViewCell
        cell?.titleArticle.text? = arrayData[indexPath.row].title!
        cell?.descriptionArticle.text? =  arrayData[indexPath.row].description!
        let imageURL = URL(string: arrayData[indexPath.row].image!)
        
        print("\(arrayData[indexPath.row])")
//        let imagedData = try! Data(contentsOf: imageURL!)

        cell?.imageArticle.kf.setImage(with: imageURL, placeholder: UIImage(named: "img22"), options: nil, progressBlock: nil, completionHandler: nil)
        
        return cell!
    }

    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{
            action, indexpath in
            self.presenterContext.deleteActicle(id: self.arrayData[indexPath.row].id!)
            self.arrayData.remove(at: indexPath.row) // remove from collection
            self.dataTableView.deleteRows(at: [indexPath], with: .fade) // remove from table
            
        });
        let EditRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler:{
            action, indexpath in
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "AddDataViewControllerID") as! AddDataViewController
            controller.article = self.arrayData[indexPath.row]
            controller.indexToUpdate = indexPath.row
            controller.tableController = self
            print(controller.indexToUpdate)
            self.navigationController?.pushViewController(controller, animated: true)
        });
        deleteRowAction.backgroundColor = UIColor.brown
        return [deleteRowAction,EditRowAction]

    }
    
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.presenter?.getArticle(page: 1, limit: 10, type:"pull")
       
        refreshControl.endRefreshing()
        print("=================== pull to refresh==========")
    }

    func refresh(){
        // Show refresh animation
        tableView.refreshControl?.beginRefreshing()
        // Load Data from Service
        
        let timer = Timer.init(timeInterval: 10, target: self, selector: #selector(updateData), userInfo: nil, repeats: false)
        
        timer.fire()
    }
    
    func updateData(){
        // When Delegate from Service stop the refresh
        tableView.refreshControl?.endRefreshing()
    }
    
    //MARK: ============ Pagination ============
    func pagging(){
       
        if paginationContext.page! < paginationContext.total_pages!{
            paginationContext.page = paginationContext.page! + 1
            print("=====================page number \(paginationContext.page)")
            paggingView?.startAnimating()
           self.presenter?.getArticle(page:paginationContext.page! , limit: 10, type: "pagination")
            
        }
    }
    

    
    func paggingDidEnd(data : [ListData]){
        
        for i in data {
            arrayData.append(i)
        }
        
        paggingView?.stopAnimating()
        self.tableView.reloadData()
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == tableView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
               
                pagging()
                
                
            }
        }
    }

    
}

extension DataTableViewController:PresenterInteface{

    
    func errorPresenter() {
        print("Error Presenter")
    }
    
    //MARK: ============= NOTIFY SUCCESS ============
    func responseData(data: [ListData], pagination:Pagination, type:String) {
        
        
        if type == "pull" {
            print("============= pull =============")
            self.arrayData = [ListData]()
            self.arrayData.append(contentsOf: data)
            
            self.dataTableView.reloadData()
            
        } else {
             print("=========== not pull =============")
             self.arrayData.append(contentsOf: data)
            
            self.dataTableView.reloadData()
            
        }
       
        self.paginationContext = pagination
        
        print(self.paginationContext)
       
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }

    }
    
    func error(data: NSError) {
        print("Edit Error \(data)")
    }
    
    func response(data: HTTPURLResponse) {
        print(data.statusCode)
        if data.statusCode == 200{
            navigationController!.popViewController(animated: true)
        }
    }
    
    func successUpload(data: [String : AnyObject]) {
        print("Upload successfully: \(data)")
    }
    
    func errorUpload(data: NSError) {
        print("Upload is Error \(data)")
    }
    
    func successDelete(data: AnyObject) {
        print("Delete successfully: \(data)")
    }
    
    func editSuccess(_ data: ListData, _ idex: Int) {
        
    }
    
    func editSuccess(data: [String : AnyObject]) {
        let data = data["String"] as! [[String:AnyObject]]
        for eachData in data{
            let article = ListData(id:eachData["ID"] as! Int,
                                   title:eachData["TITLE"] as! String,
                                   description:eachData["DESCRIPTION"] as! String)
           arrayData.append(article)
        }
        dataTableView.reloadData()
    }
    
    func updateList(_ article : ListData, _ index : Int) {
        arrayData.remove(at: index)
        arrayData.insert(article, at: index)
        dataTableView.reloadData()
    }
    
    
    func success(data: [String : AnyObject]) {
        print("============== sucesss ================ ")
       
    }
    func sucess(data: ListData) {
        
        print("============data success 1111111111111==========")
        print(data)
        arrayData.append(data)
        DispatchQueue.main.async {
            self.dataTableView.reloadData()
        }
    }
    

    
}
