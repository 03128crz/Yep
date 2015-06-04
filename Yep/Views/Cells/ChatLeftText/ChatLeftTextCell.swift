//
//  ChatLeftTextCell.swift
//  Yep
//
//  Created by NIX on 15/3/24.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class ChatLeftTextCell: UICollectionViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarImageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarImageViewWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var bubbleBodyImageView: UIImageView!
    @IBOutlet weak var bubbleTailImageView: UIImageView!

    @IBOutlet weak var dotImageView: UIImageView!
    @IBOutlet weak var gapBetweenDotImageViewAndBubbleConstraint: NSLayoutConstraint!

    @IBOutlet weak var textContentLabel: TTTAttributedLabel!
    @IBOutlet weak var textContentLabelLeadingConstaint: NSLayoutConstraint!
    @IBOutlet weak var textContentLabelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var textContentLabelWidthConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        avatarImageViewLeadingConstraint.constant = YepConfig.chatCellGapBetweenWallAndAvatar()
        avatarImageViewWidthConstraint.constant = YepConfig.chatCellAvatarSize()

        textContentLabel.linkAttributes = [
            kCTForegroundColorAttributeName: UIColor.blackColor(),
            kCTUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
        ]
        textContentLabel.activeLinkAttributes = [
            kCTForegroundColorAttributeName: UIColor.rightBubbleTintColor(),
            kCTUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue,
        ]
        textContentLabel.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue | NSTextCheckingType.PhoneNumber.rawValue

        textContentLabel.delegate = self

        textContentLabel.font = UIFont.chatTextFont()

        textContentLabelLeadingConstaint.constant = YepConfig.chatCellGapBetweenTextContentLabelAndAvatar()
        textContentLabelTrailingConstraint.constant = YepConfig.chatTextGapBetweenWallAndContentLabel()

        bubbleBodyImageView.tintColor = UIColor.leftBubbleTintColor()
        bubbleTailImageView.tintColor = UIColor.leftBubbleTintColor()

        gapBetweenDotImageViewAndBubbleConstraint.constant = YepConfig.ChatCell.gapBetweenDotImageViewAndBubble
    }

    func configureWithMessage(message: Message, textContentLabelWidth: CGFloat) {
        textContentLabel.text = message.textContent

        textContentLabelWidthConstraint.constant = max(YepConfig.minMessageTextLabelWidth, textContentLabelWidth)
        textContentLabel.textAlignment = textContentLabelWidth < YepConfig.minMessageTextLabelWidth ? .Center : .Left

        if let sender = message.fromFriend {
            AvatarCache.sharedInstance.roundAvatarOfUser(sender, withRadius: YepConfig.chatCellAvatarSize() * 0.5) { roundImage in
                dispatch_async(dispatch_get_main_queue()) {
                    self.avatarImageView.image = roundImage
                }
            }
        }
    }
}

extension ChatLeftTextCell: TTTAttributedLabelDelegate {

    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }

    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + phoneNumber)!)
    }
}
