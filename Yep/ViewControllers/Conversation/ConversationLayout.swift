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

    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)

        var insertIndexPathSet = Set<NSIndexPath>()

        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .Insert:
                let indexPath = updateItem.indexPathAfterUpdate
                insertIndexPathSet.insert(indexPath)

            default:
                break
            }
        }

        self.insertIndexPathSet = insertIndexPathSet
    }

    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {

        let attributes = layoutAttributesForItemAtIndexPath(itemIndexPath)

        if insertIndexPathSet.contains(itemIndexPath) {
            attributes?.frame.origin.y += 30
            attributes?.alpha = 0

            insertIndexPathSet.remove(itemIndexPath)
        }

        return attributes
    }
    
}

