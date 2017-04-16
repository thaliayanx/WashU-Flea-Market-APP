//
//  Item.swift
//
import Foundation
struct Item{
    //var id:String
    var name:String
    var url:String
    var price:String
    var category:String
    var seller:String
    var id:String

    init(name:String,url:String,price:String,category:String,seller:String, id:String){
        //self.id=id
        self.name=name
        self.url=url
        self.price=price
       self.category=category
        self.seller=seller
        self.id = id
    }
}
