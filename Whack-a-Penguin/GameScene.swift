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
