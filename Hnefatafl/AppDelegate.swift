//
//  AppDelegate.swift
//  Hnefatafl
//
//  Created by Yannick Weiss on 16/06/15.
//  Copyright (c) 2015 Yannick Weiss. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var window: NSWindow!
  @IBOutlet weak var skView: SKView!

  func applicationDidFinishLaunching(aNotification: NSNotification) {
      /* Pick a size for the scene */
      if let scene = GameScene(fileNamed:"GameScene") {
          /* Set the scale mode to scale to fit the window */
        
          
          self.skView!.presentScene(scene)
          
          /* Sprite Kit applies additional optimizations to improve rendering performance */
          self.skView!.ignoresSiblingOrder = true
          
          self.skView!.showsFPS = true
          self.skView!.showsNodeCount = true
      }
  }

  func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
      return true
  }
  
  func nextPlayer(sender: AnyObject?) {
    // forward menuitem to the scene
    let s:GameScene = self.skView!.scene as! GameScene
    s.nextPlayer(sender);
  }
  
}
