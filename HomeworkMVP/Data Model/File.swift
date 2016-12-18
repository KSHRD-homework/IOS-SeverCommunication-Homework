//
//  File.swift
//  HomeworkMVP
//
//  Created by Song Seaktheng on 12/15/16.
//  Copyright © 2016 Song Seaktheng. All rights reserved.
//

import Foundation

class ListData{
    var id:Int?
    var title:String?
    var description:String?
    var image:String?
    
    
    init(id:Int,title:String, description:String) {
        self.id = id
        self.title = title
        self.description = description
    }
    init(title:String, description:String, image:String) {
       
        self.title = title
        self.description = description
        self.image = image
    }
       init(){}
    
    
}
