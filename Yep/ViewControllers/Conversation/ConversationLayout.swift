//
//  ConversationLayout.swift
//  Yep
//
//  Created by NIX on 15/3/25.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit
import QuartzCore

class ConversationLayout: UICollectionViewFlowLayout {

    override func prepareLayout() {
        super.prepareLayout()

        minimumLineSpacing = YepConfig.ChatCell.lineSpacing
    }

    var insertIndexPathSet = Set<NSIndexPath>()

    override func prepareForCollectionViewUpdates(updateItems: [AnyObject]!) {
        super.prepareForCollectionViewUpdates(updateItems)

        var insertIndexPathSet = Set<NSIndexPath>()

        if let updateItems = updateItems as? [UICollectionViewUpdateItem] {
            for updateItem in updateItems {
                switch updateItem.updateAction {
                case .Insert:
                    if let indexPath = updateItem.indexPathAfterUpdate {
                        insertIndexPathSet.insert(indexPath)
                    }
                default:
                    break
                }
            }
        }

        self.insertIndexPathSet = insertIndexPathSet
    }

    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {

        let attributes = layoutAttributesForItemAtIndexPath(itemIndexPath)

        if insertIndexPathSet.contains(itemIndexPath) {
            attributes.frame.origin.y += 30

            insertIndexPathSet.remove(itemIndexPath)
        }

        return attributes
    }

//    var lastTimeContentSize: CGSize?
//    
//    var itemsDeleteIndexPaths = [NSIndexPath]()
//    
//    override func collectionViewContentSize() -> CGSize {
//        var contentSize = super.collectionViewContentSize()
//        
//        if let lastTimeContentSize = lastTimeContentSize {
//            if lastTimeContentSize.height > contentSize.height {
//                contentSize.height = lastTimeContentSize.height
//            }
//        } else {
//            lastTimeContentSize = contentSize
//        }
//        
//        return contentSize
//    }
//    
//    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
//        var attr = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
//        
//        for (index, indexPath) in enumerate(itemsDeleteIndexPaths) {
//            if indexPath == itemIndexPath {
//                
//                if let cell = collectionView?.cellForItemAtIndexPath(indexPath) as? ChatStateCell {
//                    var scale: CGFloat = 0.8
//                    var offsetScale: CGFloat  = (1-scale)*0.5
//                    
//                    attr?.transform = CGAffineTransformMakeScale(scale, scale)
//                    attr?.alpha = 0
//                    
//                    println("Frame width \(cell.stateLabel.frame.width)")
//                    
//                    attr?.center = CGPointMake(attr!.center.x + attr!.size.width*offsetScale - cell.stateLabel.frame.width*offsetScale, attr!.center.y - cell.stateLabel.frame.height*scale*0.5)
//                }
//
//                itemsDeleteIndexPaths.removeAtIndex(index)
//            }
//        }
//
//        
//        return attr
//    }

}
