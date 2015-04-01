//
//  ChatRightImageCell.swift
//  Yep
//
//  Created by NIX on 15/3/31.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

class ChatRightImageCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarImageViewWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var messageImageView: UIImageView!

    @IBOutlet weak var messageImageViewAspectRatioConstrint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        avatarImageViewWidthConstraint.constant = YepConfig.chatCellAvatarSize()

        messageImageViewAspectRatioConstrint.active = false
        let newMessageImageViewAspectRatioConstraint = NSLayoutConstraint(item: messageImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: messageImageView, attribute: NSLayoutAttribute.Height, multiplier: YepConfig.messageImageViewAspectRatio(), constant: 0.0)
        NSLayoutConstraint.activateConstraints([newMessageImageViewAspectRatioConstraint])
    }

}
