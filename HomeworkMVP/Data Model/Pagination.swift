//
//  Pagination.swift
//  HomeworkMVP
//
//  Created by Theng on 12/18/16.
//  Copyright © 2016 Song Seaktheng. All rights reserved.
//

import Foundation
import ObjectMapper

//class Pagination{
//    var page:Int?
//    var limit:Int?
//    var total_count:Int?
//    var total_pages:Int?
//    init(page:Int, limit:Int, total_count:Int, total_pages:Int) {
//        self.page = page
//        self.limit = limit
//        self.total_count = total_count
//        self.total_pages = total_pages
//    }
//
//}
class Pagination: Mappable {
    
    var page:Int?
    var limit:Int?
    var total_count:Int?
    var total_pages:Int?
    
    init() {
        
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    // Mappable
    func mapping(map: Map) {
        page            <- map["PAGE"]
        limit           <- map["LIMIT"]
        total_count     <- map["TOTAL_COUNT"]
        total_pages     <- map["TOTAL_PAGES"]
        
    }
}

