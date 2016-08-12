//
//  GameScene.swift
//  Whack-a-Penguin
//
//  Created by My Nguyen on 8/12/16.
//  Copyright (c) 2016 My Nguyen. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var gameScore: SKLabelNode!
    var score: Int = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    var slots = [WhackSlot]()
    // create a new enemy a bit faster than once a second
    var popupTime = 0.85
    var numRounds = 0

    override func didMoveToView(view: SKView) {
        // refer to project PachinkoWithSpriteKit for a detailed explanation
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        background.zPosition = -1
        addChild(background)

        // refer to project PachinkoWithSpriteKit for a detailed explanation
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .Left
        gameScore.fontSize = 48
        addChild(gameScore)

        // create four rows of slots, with five slots in the top row, then four in the second,
        // then five, then four
        for i in 0 ..< 5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlotAt(CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlotAt(CGPoint(x: 180 + (i * 170), y: 140)) }

        // create an enemy after a brief delay
        RunAfterDelay(1) { [unowned self] in
            self.createEnemy()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            // get the touch location
            let location = touch.locationInNode(self)
            // get an array of nodes at the touch location
            let nodes = nodesAtPoint(location)

            // loop through the list of all nodes at the touch point and take action depending on
            // whether node's name is "charFriend" or "charEnemy"
            for node in nodes {
                if node.name == "charFriend" {
                    /// they shouldn't have whacked this penguin
                    // get the parent of the parent of the node. the node is a penguin, so its parent
                    // is a crop node, and the crop's parent is a slot
                    let whackSlot = node.parent!.parent as! WhackSlot
                    if !whackSlot.visible || whackSlot.isHit { continue }

                    whackSlot.hit()
                    score -= 5

                    // play a sound and optionally wait for the sound to finish before continuing
                    runAction(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                } else if node.name == "charEnemy" {
                    /// they should have whacked this one
                    let whackSlot = node.parent!.parent as! WhackSlot
                    if !whackSlot.visible || whackSlot.isHit { continue }

                    // shrink the penguin
                    whackSlot.charNode.xScale = 0.85
                    whackSlot.charNode.yScale = 0.85

                    whackSlot.hit()
                    score += 1

                    runAction(SKAction.playSoundFileNamed("whack.caf", waitForCompletion:false))
                }
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }

    func createSlotAt(pos: CGPoint) {
        let slot = WhackSlot()
        slot.configureAtPosition(pos)
        addChild(slot)
        slots.append(slot)
    }

    func createEnemy() {
        numRounds += 1

        // end the game after 30 rounds
        if numRounds >= 30 {
            // hide all the slots
            for slot in slots {
                slot.hide()
            }

            // show a "Game over" sprite
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            // place the "Gamve over" graphic over other items
            gameOver.zPosition = 1
            addChild(gameOver)

            return
        }

        // decrease popupTime each time this method is invoked
        popupTime *= 0.991

        // shuffle the list of available slots
        slots = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(slots) as! [WhackSlot]
        // show the first slow
        slots[0].show(hideTime: popupTime)

        // generate 4 random numbers to see if more slots should be shown; potentially up to 5 slots
        // could be shown at once
        if RandomInt(min: 0, max: 12) > 4 { slots[1].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 8 { slots[2].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 10 { slots[3].show(hideTime: popupTime) }
        if RandomInt(min: 0, max: 12) > 11 { slots[4].show(hideTime: popupTime) }

        // set up a random delay between half of popupTime and twice popupTime
        let randomDelay = RandomDouble(min: popupTime/2.0, max: popupTime*2)
        // make a recursive call after the random delay
        RunAfterDelay(randomDelay) { [unowned self] in
            self.createEnemy()
        }
    }
}
