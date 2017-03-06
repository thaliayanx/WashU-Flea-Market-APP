//
//  MyCell.swift
//

import UIKit

class MyCell: UICollectionViewCell {
    var textLabel: UILabel!
    var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height))
        contentView.addSubview(imageView)
        
        textLabel = UILabel(frame: CGRect(x: 0, y: frame.size.height*2/3, width: frame.size.width, height: frame.size.height/3))
        textLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        textLabel.textAlignment = .center
        textLabel.textColor=UIColor.white
        textLabel.backgroundColor=UIColor(red:0, green:0, blue:0, alpha:0.8)
        contentView.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
