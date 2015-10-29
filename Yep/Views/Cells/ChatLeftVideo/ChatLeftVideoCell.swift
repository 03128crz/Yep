//
//  ChatLeftVideoCell.swift
//  Yep
//
//  Created by NIX on 15/4/23.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

class ChatLeftVideoCell: ChatBaseCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!

    @IBOutlet weak var playImageView: UIImageView!

    @IBOutlet weak var loadingProgressView: MessageLoadingProgressView!
    
    typealias MediaTapAction = () -> Void
    var mediaTapAction: MediaTapAction?

    func makeUI() {

        //let fullWidth = UIScreen.mainScreen().bounds.width

        let halfAvatarSize = YepConfig.chatCellAvatarSize() / 2

        avatarImageView.center = CGPoint(x: YepConfig.chatCellGapBetweenWallAndAvatar() + halfAvatarSize, y: halfAvatarSize)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.performWithoutAnimation { [weak self] in
            self?.makeUI()
        }

        thumbnailImageView.tintColor = UIColor.leftBubbleTintColor()

        thumbnailImageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: "tapMediaView")
        thumbnailImageView.addGestureRecognizer(tap)
    }

    func tapMediaView() {
        mediaTapAction?()
    }

    var loadingProgress: Double = 0 {
        willSet {
            if newValue == 1.0 {
                loadingProgressView.hidden = true

            } else {
                loadingProgressView.progress = newValue
                loadingProgressView.hidden = false
            }
        }
    }

    func loadingWithProgress(progress: Double, image: UIImage?) {

        if progress >= loadingProgress {

            if progress <= 1.0 {
                loadingProgress = progress
            }

            if let image = image {

                dispatch_async(dispatch_get_main_queue()) {

                    self.thumbnailImageView.image = image

                    UIView.animateWithDuration(YepConfig.ChatCell.imageAppearDuration, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                        self.thumbnailImageView.alpha = 1.0
                    }, completion: { (finished) -> Void in
                    })
                }
            }
        }
    }

    func configureWithMessage(message: Message, messageImagePreferredWidth: CGFloat, messageImagePreferredHeight: CGFloat, messageImagePreferredAspectRatio: CGFloat, mediaTapAction: MediaTapAction?, collectionView: UICollectionView, indexPath: NSIndexPath) {

        self.user = message.fromFriend

        self.mediaTapAction = mediaTapAction
        
        var topOffset: CGFloat = 0
        
        if inGroup {
            topOffset = YepConfig.ChatCell.marginTopForGroup
        } else {
            topOffset = 0
        }

        UIView.performWithoutAnimation { [weak self] in
            self?.makeUI()
        }

        if let sender = message.fromFriend {
            let userAvatar = UserAvatar(userID: sender.userID, avatarStyle: nanoAvatarStyle)
            avatarImageView.navi_setAvatar(userAvatar)
        }

        loadingProgress = 0

        dispatch_async(dispatch_get_main_queue()) { [weak self] in
            if let strongSelf = self {
                strongSelf.thumbnailImageView.alpha = 0.0
            }
        }

        if let (videoWidth, videoHeight) = videoMetaOfMessage(message) {

            let aspectRatio = videoWidth / videoHeight

            let messageImagePreferredWidth = max(messageImagePreferredWidth, ceil(YepConfig.ChatCell.mediaMinHeight * aspectRatio))
            let messageImagePreferredHeight = max(messageImagePreferredHeight, ceil(YepConfig.ChatCell.mediaMinWidth / aspectRatio))

            if aspectRatio >= 1 {

                let width = messageImagePreferredWidth
                
                UIView.performWithoutAnimation { [weak self] in

                    if let strongSelf = self {
                        strongSelf.thumbnailImageView.frame = CGRect(x: CGRectGetMaxX(strongSelf.avatarImageView.frame) + YepConfig.ChatCell.gapBetweenAvatarImageViewAndBubble, y: topOffset, width: width, height: strongSelf.bounds.height - topOffset)
                        strongSelf.playImageView.center = CGPoint(x: CGRectGetMidX(strongSelf.thumbnailImageView.frame) + YepConfig.ChatCell.playImageViewXOffset, y: CGRectGetMidY(strongSelf.thumbnailImageView.frame))
                        strongSelf.loadingProgressView.center = strongSelf.playImageView.center
                    }
                }

                ImageCache.sharedInstance.imageOfMessage(message, withSize: CGSize(width: messageImagePreferredWidth, height: ceil(messageImagePreferredWidth / aspectRatio)), tailDirection: .Left, completion: { [weak self] progress, image in

                    dispatch_async(dispatch_get_main_queue()) {
                        if let _ = collectionView.cellForItemAtIndexPath(indexPath) {
                            self?.loadingWithProgress(progress, image: image)
                        }
                    }
                })

            } else {
                let width = messageImagePreferredHeight * aspectRatio
                
                UIView.performWithoutAnimation { [weak self] in

                    if let strongSelf = self {
                        strongSelf.thumbnailImageView.frame = CGRect(x: CGRectGetMaxX(strongSelf.avatarImageView.frame) + YepConfig.ChatCell.gapBetweenAvatarImageViewAndBubble, y: topOffset, width: width, height: strongSelf.bounds.height - topOffset)
                        strongSelf.playImageView.center = CGPoint(x: CGRectGetMidX(strongSelf.thumbnailImageView.frame) + YepConfig.ChatCell.playImageViewXOffset, y: CGRectGetMidY(strongSelf.thumbnailImageView.frame))
                        strongSelf.loadingProgressView.center = strongSelf.playImageView.center
                    }
                }


                ImageCache.sharedInstance.imageOfMessage(message, withSize: CGSize(width: messageImagePreferredHeight * aspectRatio, height: messageImagePreferredHeight), tailDirection: .Left, completion: { [weak self] progress, image in

                    dispatch_async(dispatch_get_main_queue()) {
                        if let _ = collectionView.cellForItemAtIndexPath(indexPath) {
                            self?.loadingWithProgress(progress, image: image)
                        }
                    }
                })
            }

        } else {
            let width = messageImagePreferredWidth
            
            UIView.performWithoutAnimation { [weak self] in

                if let strongSelf = self {
                    strongSelf.thumbnailImageView.frame = CGRect(x: CGRectGetMaxX(strongSelf.avatarImageView.frame) + YepConfig.ChatCell.gapBetweenAvatarImageViewAndBubble, y: topOffset, width: width, height: strongSelf.bounds.height - topOffset)
                    strongSelf.playImageView.center = CGPoint(x: CGRectGetMidX(strongSelf.thumbnailImageView.frame) + YepConfig.ChatCell.playImageViewXOffset, y: CGRectGetMidY(strongSelf.thumbnailImageView.frame))
                    strongSelf.loadingProgressView.center = strongSelf.playImageView.center
                }
            }

            ImageCache.sharedInstance.imageOfMessage(message, withSize: CGSize(width: messageImagePreferredWidth, height: ceil(messageImagePreferredWidth / messageImagePreferredAspectRatio)), tailDirection: .Left, completion: { [weak self] progress, image in

                dispatch_async(dispatch_get_main_queue()) {
                    if let _ = collectionView.cellForItemAtIndexPath(indexPath) {
                        self?.loadingWithProgress(progress, image: image)
                    }
                }
            })
        }
        
        configNameLabel(topOffset)
    }
    
    func configNameLabel(topOffset: CGFloat) {
        
        if inGroup {
            nameLabel.text = user?.nickname
            nameLabel.sizeToFit()
            nameLabel.frame = CGRect(x: CGRectGetMaxX(avatarImageView.frame) + YepConfig.chatCellGapBetweenTextContentLabelAndAvatar(), y: thumbnailImageView.frame.origin.y - topOffset, width: nameLabel.frame.width, height: nameLabel.frame.height)
            //            bubbleTailImageView.hidden = true
        }
    }
}

