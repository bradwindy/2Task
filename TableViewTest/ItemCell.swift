//
//  ItemCell.swift
//  TableViewTest
//
//  Created by Bradley Windybank on 28/01/20.
//  Copyright © 2020 Bradley Windybank. All rights reserved.
//

import UIKit
import CoreData

class ItemCell: UITableViewCell {
    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var deleteIcon: UIImageView!
    
    func setItem(item: NSManagedObject) {
        let df = DateFormatter()
        df.dateFormat = "EEEE d MMMM, h:mm a"
        
        checkIcon.image = item.value(forKeyPath: "completed") as! Bool ?
            UIImage(systemName: "checkmark.square.fill")
            : UIImage(systemName: "square")
        
        let title = item.value(forKeyPath: "title") as! String
        
        let strikeTitle: NSMutableAttributedString =  NSMutableAttributedString(string: title)
        strikeTitle.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                 value: 2,
                                 range: NSMakeRange(0, strikeTitle.length))
        
        titleLabel.attributedText = item.value(forKeyPath: "completed") as! Bool ?
            strikeTitle
            : NSMutableAttributedString(string: title)
        
        titleLabel.textColor = item.value(forKeyPath: "completed") as! Bool ? .systemGray : .label
        
        let date = item.value(forKeyPath: "date") as! Date
        
        let strikeSubtitle: NSMutableAttributedString =  NSMutableAttributedString(string: df.string(from: date))
        strikeSubtitle.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                 value: 2,
                                 range: NSMakeRange(0, strikeSubtitle.length))
        
        
        subtitleLabel.attributedText = item.value(forKeyPath: "completed") as! Bool ?
            strikeSubtitle
            : NSMutableAttributedString(string: df.string(from: date))
        
        subtitleLabel.textColor = item.value(forKeyPath: "completed") as! Bool ? .systemGray : .label

    }
}
