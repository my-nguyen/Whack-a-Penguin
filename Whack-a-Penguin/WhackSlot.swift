//
//  WhackSlot.swift
//  Whack-a-Penguin
//
//  Created by My Nguyen on 8/12/16.
//  Copyright © 2016 My Nguyen. All rights reserved.
//

import UIKit
import SpriteKit

class WhackSlot: SKNode {

    var charNode: SKSpriteNode!

    // this method is in lieu of an initializer
    func configureAtPosition(pos: CGPoint) {
        position = pos

        // create a hole and add it to the slot
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)

        // create a new SKCropNode, which renders anything transparent invisible, and anything
        // with color visible
        let cropNode = SKCropNode()
        // position the crop node slightly higher than the slot itself; 15 is the exact number
        // of points required to make the crop node line up perfectly with the hole graphics
        cropNode.position = CGPoint(x: 0, y: 15)
        // set zPosition to 1 to put the crop node to the front of other nodes, which stops it
        // from appearing behind the hole.
        cropNode.zPosition = 1
        // don't crop anything yet
        cropNode.maskNode = nil
        // now crop the penguins
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

        // create the character node, with the "good penguin" image
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        // the node is placed at -90, which is way below the hole as if the penguin were properly hiding
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"

        // add the character node to the crop node since the crop node only crops nodes that are inside it
        cropNode.addChild(charNode)
        // add the crop node to the slot
        addChild(cropNode)
    }
}
