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
    var visible = false
    var isHit = false

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
        // now crop (hide) the penguins
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

    func show(hideTime hideTime: Double) {
        // make sure the slot isn't already visible
        if visible { return }

        // slide the penguin upwards and make it visible
        charNode.runAction(SKAction.moveByX(0, y: 80, duration: 0.05))
        visible = true
        isHit = false

        if RandomInt(min: 0, max: 2) == 0 {
            // one-third of the time the penguin will be good
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            // the rest of the time the penguin will be bad
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }

        // hide the penguin after some time; 3.5 is the optimal value
        RunAfterDelay(hideTime*3.5) { [unowned self] in
            self.hide()
        }
    }

    func hide() {
        if !visible { return }

        // move the penguin down into its hold
        charNode.runAction(SKAction.moveByX(0, y: -80, duration: 0.05))
        visible = false
    }
}
