//
//  Item.swift
//
import Foundation
struct Item{
    var id:String
    var name:String
    var url:String
    var released:String
    var score:String
    var rated:String
    init(id:String,name:String,url:String,released:String,score:String,rated:String){
        self.id=id
        self.name=name
        self.url=url
        self.released=released
        self.score=score
        self.rated=rated
    }
}
