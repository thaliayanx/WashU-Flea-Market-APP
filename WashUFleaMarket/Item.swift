//
//  Item.swift
//
import Foundation
struct Item{
    var id:String
    var name:String
    var url:String
    var price:Int
    
    init(id:String,name:String,url:String,price:Int,score:String,rated:String){
        self.id=id
        self.name=name
        self.url=url
        self.price=price
       
    }
}
