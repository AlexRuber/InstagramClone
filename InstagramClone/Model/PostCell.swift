//
//  PostCell.swift
//  InstagramClone
//
//  Created by Mihai Ruber on 2/25/18.
//  Copyright © 2018 Mihai Ruber. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var profImg: UIImageView!
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var heartPopup: UIImageView!
    
    
    // Variables
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        // Double tap
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(PostCell.likeAnimation))
        tapGR.delegate = self
        tapGR.numberOfTapsRequired = 2
        self.addGestureRecognizer(tapGR)

        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension PostCell {
    @objc func likeAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
            self.heartPopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.heartPopup.alpha = 1.0
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
                self.heartPopup.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: {(_ finished: Bool) -> Void in
                UIView.animate(withDuration: 0.3, delay: 0, options: .allowUserInteraction, animations: {() -> Void in
                    self.heartPopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    self.heartPopup.alpha = 0.0
                }, completion: {(_ finished: Bool) -> Void in
                    self.heartPopup.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
            })
        })
        var numOfLikes: Int = 0
        numOfLikes += 1
        likeLbl.text = String(numOfLikes)
    }
}
