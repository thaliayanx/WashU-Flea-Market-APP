//
//  MyCell.swift
//

import UIKit

class MyCell1: UICollectionViewCell {
    var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height))
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
