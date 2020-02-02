//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by RIDVAN on 30.01.2020.
//  Copyright © 2020 ridvanmertoglu. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!    
    @IBOutlet weak var numberOfLikeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func likeButton(_ sender: Any) {
        let fireStoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(numberOfLikeLabel.text!) {
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            fireStoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
        }
    }
    

}
