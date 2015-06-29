//
//  GameScene.swift
//  Hnefatafl
//
//  Created by Yannick Weiss on 16/06/15.
//  Copyright (c) 2015 Yannick Weiss. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  var players = [Player(), Player()]
  var currentPlayer = 0
  let myLabel = SKLabelNode(fontNamed:"Arial")
  
  var board = SpriteMatrix(rows: 11, columns: 11)
  let squareSize = CGSizeMake(80, 80)
  var draggedNode: PieceNode?
  var game = Game()
 
  override func didMoveToView(view: SKView) {
    drawBoard()
    setupGame()
    drawPieces()
    
    players[0].name = "Player 1 Attacker"
    players[1].name = "Player 2 Defender"
    
    
    myLabel.text = "\(players[currentPlayer].name) turn";
    myLabel.fontSize = 25;
    myLabel.fontColor = NSColor.redColor()
    myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)/2);
    
    self.addChild(myLabel)
  }
  
  override func mouseDown(theEvent: NSEvent) {
    let location = theEvent.locationInNode(self)
    let node = self.nodeAtPoint(location)
    
    if let pNode = node as? PieceNode {
      draggedNode = pNode
      pNode.moveToParent(self)
    }
  }
  
  override func mouseDragged(theEvent: NSEvent) {
    if (draggedNode != nil) {
      let location = theEvent.locationInNode(self)
      draggedNode?.position = location
    }
    
  }
  
  override func mouseUp(theEvent: NSEvent) {
    let location = theEvent.locationInNode(self)
    let nodes = self.nodesAtPoint(location)
    for node in nodes {
      if (node.name == "board") {
        draggedNode?.moveToParent(node)
        draggedNode = nil
        break
      }
    }
    draggedNode = nil
  }
  
  override func update(currentTime: CFTimeInterval) {
      /* Called before each frame is rendered */
  }
  
  func setupGame() {
    let squareSize = CGSizeMake(50, 50)
    
    // place attackers
    for row in 4...6 {
      for col in 0...1 {
        game.board[row, col] = Piece.Attacker
      }
    }
    
    for row in 4...6 {
      for col in 9...10 {
        game.board[row, col] = Piece.Attacker
      }
    }
    
    for col in 4...6 {
      for row in 0...1 {
        game.board[row, col] = Piece.Attacker
      }
    }
    
    for col in 4...6 {
      for row in 9...10 {
        game.board[row, col] = Piece.Attacker
      }
    }
    
    // place defenders
    for row in 4...6 {
      for col in 4...6 {
        if (col == 5 && row == 5) { // skip throne
          continue
        }
        game.board[row, col] = Piece.Defender
      }
    }
    
    game.board[3,5] = Piece.Defender
    game.board[5,3] = Piece.Defender
    game.board[5,7] = Piece.Defender
    game.board[7,5] = Piece.Defender
    
    // place king
    game.board[5,5] = Piece.King
    
    // place Corner
    game.board[0,0] = Piece.Corner
    game.board[0,10] = Piece.Corner
    game.board[10,0] = Piece.Corner
    game.board[10,10] = Piece.Corner
  }
  
  func nextPlayer(sender: AnyObject?) {
    currentPlayer = currentPlayer == 1 ? 0 : 1
    
    // hit me
    myLabel.text = "\(players[currentPlayer].name) turn";
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
        square.name = "board"
        self.addChild(square)
        board[row, col] = square
        toggle = !toggle
      }
    }
  }

  func drawPieces() {
    let squareSize = CGSizeMake(50, 50)
    
    for row in 0...board.rows-1 {
      for col in 0...board.columns-1 {
        let square = board[row, col]
        switch game.board[row, col] {
        case .Attacker:
          let color = SKColor.greenColor()
          let s = PieceNode(color: color, size: squareSize)
          square.addChild(s)
        case .Defender:
          let color = SKColor.orangeColor()
          let s = PieceNode(color: color, size: squareSize)
          square.addChild(s)
        case .King:
          let color = SKColor.redColor()
          let s = PieceNode(color: color, size: squareSize)
          square.addChild(s)
        case .Corner:
          let color = SKColor.grayColor()
          let s = PieceNode(color: color, size: squareSize)
          square.addChild(s)
        default:
          let one = 1;
          // .Empty -> do nothing
        }
        
      }
    }
  }
  
  func winnerScreen() {
    for _ in 0...10 {
      let xx = CGFloat(arc4random_uniform(800))
      let yy = CGFloat(arc4random_uniform(800))
      
      let sprite = SKSpriteNode(imageNamed:"Spaceship")
      sprite.position = CGPoint(x: xx, y: yy)
      sprite.setScale(0.5)
      
      let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
      sprite.runAction(SKAction.repeatActionForever(action))
      
      self.addChild(sprite)
      
      let winLabel = SKLabelNode(fontNamed:"Chalkboard")
      winLabel.text = "You Won";
      winLabel.fontSize = 60;
      winLabel.fontColor = NSColor.redColor()
      winLabel.position = CGPoint(x: xx, y: yy)
      let action2 = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
      winLabel.runAction(SKAction.repeatActionForever(action2))
      self.addChild(winLabel)
    }
  }
}

struct SpriteMatrix {
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
