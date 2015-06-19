//
//  GameScene.swift
//  Hnefatafl
//
//  Created by Yannick Weiss on 16/06/15.
//  Copyright (c) 2015 Yannick Weiss. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  var board = Matrix(rows: 11, columns: 11)
  let squareSize = CGSizeMake(80, 80)
 
  override func didMoveToView(view: SKView) {
//    /* Setup your scene here */
//    let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//    myLabel.text = "Hello, World!";
//    myLabel.fontSize = 65;
//    myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//    
//    self.addChild(myLabel)
    
    drawBoard()

    
    setupGame()
    
  }
  
  override func mouseDown(theEvent: NSEvent) {
    /* Called when a mouse click occurs */
    
    let location = theEvent.locationInNode(self)
    
    let sprite = SKSpriteNode(imageNamed:"Spaceship")
    sprite.position = location;
    sprite.setScale(0.5)
    
    let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
    sprite.runAction(SKAction.repeatActionForever(action))
    
    self.addChild(sprite)
  }
  
  override func update(currentTime: CFTimeInterval) {
      /* Called before each frame is rendered */
  }
  
  func setupGame() {
    let squareSize = CGSizeMake(50, 50)
    
    // place attackers
    let color = SKColor.greenColor()
    for row in 4...6 {
      for col in 0...1 {
        let square = SKSpriteNode(color: color, size: squareSize)
        let s:SKSpriteNode = board[row, col]
        s.addChild(square)
      }
    }
    
    for row in 4...6 {
      for col in 9...10 {
        let square = SKSpriteNode(color: color, size: squareSize)
        let s:SKSpriteNode = board[row, col]
        s.addChild(square)
      }
    }
    
    for col in 4...6 {
      for row in 0...1 {
        let square = SKSpriteNode(color: color, size: squareSize)
        let s:SKSpriteNode = board[row, col]
        s.addChild(square)
      }
    }
    
    for col in 4...6 {
      for row in 9...10 {
        let square = SKSpriteNode(color: color, size: squareSize)
        let s:SKSpriteNode = board[row, col]
        s.addChild(square)
      }
    }
    
    // place defenders
    let defenderColor = SKColor.orangeColor()
    for row in 4...6 {
      for col in 4...6 {
        if (col == 5 && row == 5) {
          continue
        }
        let square = SKSpriteNode(color: defenderColor, size: squareSize)
        let s:SKSpriteNode = board[row, col]
        s.addChild(square)
      }
    }
    
    let defender1 = SKSpriteNode(color: defenderColor, size: squareSize)
    board[3,5].addChild(defender1)
    
    let defender2 = SKSpriteNode(color: defenderColor, size: squareSize)
    board[5,3].addChild(defender2)
    
    let defender3 = SKSpriteNode(color: defenderColor, size: squareSize)
    board[5,7].addChild(defender3)
    
    let defender4 = SKSpriteNode(color: defenderColor, size: squareSize)
    board[7,5].addChild(defender4)
    
    
    // place king
    let king = SKSpriteNode(color: SKColor.redColor(), size:squareSize)
    board[5,5].addChild(king)
    
    // place tower
    let towerColor = SKColor.grayColor()
    let tower1 = SKSpriteNode(color: towerColor, size: squareSize)
    board[0,0].addChild(tower1)
    let tower2 = SKSpriteNode(color: towerColor, size: squareSize)
    board[0,10].addChild(tower2)
    let tower3 = SKSpriteNode(color: towerColor, size: squareSize)
    board[10,0].addChild(tower3)
    let tower4 = SKSpriteNode(color: towerColor, size: squareSize)
    board[10,10].addChild(tower4)
    
    
  }
  
  func drawBoard() {
    let xOffset:CGFloat = squareSize.height/2
    let yOffset:CGFloat = squareSize.width/2
    var toggle:Bool = false
    
    for row in 0...board.rows-1 {
      for col in 0...board.columns-1 {
        let color = toggle ? SKColor.whiteColor() : SKColor.blackColor()
        let square = SKSpriteNode(color: color, size: squareSize)
        square.position = CGPointMake(CGFloat(col) * squareSize.width + xOffset,
          CGFloat(row) * squareSize.height + yOffset)
        square.name = "empty"
        self.addChild(square)
        board[row, col] = square
        toggle = !toggle
      }
    }
  }
}

struct Matrix {
  let rows: Int, columns: Int
  var grid: [SKSpriteNode]
  init(rows: Int, columns: Int) {
    self.rows = rows
    self.columns = columns
    grid = Array(count: rows * columns, repeatedValue: SKSpriteNode())
  }
  func indexIsValidForRow(row: Int, column: Int) -> Bool {
    return row >= 0 && row < rows && column >= 0 && column < columns
  }
  subscript(row: Int, column: Int) -> SKSpriteNode {
    get {
      assert(indexIsValidForRow(row, column: column), "Index out of range")
      return grid[(row * columns) + column]
    }
    set {
      assert(indexIsValidForRow(row, column: column), "Index out of range")
      grid[(row * columns) + column] = newValue
    }
  }
}
