//
//  GameScene.swift
//  Hnefatafl
//
//  Created by Yannick Weiss on 16/06/15.
//  Copyright (c) 2015 Yannick Weiss. All rights reserved.
//

import SpriteKit

let kDebugMovement = true

class GameScene: SKScene {
  
  var players = [Player(type: .Attacker, name: "Attacker"), Player(type: .Defender, name: "Defender")]
  var currentPlayer = 0
  
  var spriteBoard = SpriteMatrix(rows: 11, columns: 11)
  let squareSize = CGSizeMake(80, 80)
  var draggedNode: PieceNode?
  var game = Game()
 
  override func didMoveToView(view: SKView) {
    drawBoard()
    setupGame()
    drawPieces()
    displayCurrentPlayer()
    
  }
  
  func displayCurrentPlayer() {
    let text = SKLabelNode(fontNamed:"Helvetica-Bold")
    text.text = "\(players[currentPlayer].name)'s turn";
    text.zPosition = 100
    text.fontSize = 50
    text.fontColor = SKColor.whiteColor()
    text.position = CGPoint(x:CGRectGetMidX(self.frame), y:self.frame.height-220);
    
    let dropShadow = SKLabelNode(fontNamed:"Helvetica-Bold")
    dropShadow.text = text.text
    dropShadow.fontSize = text.fontSize
    dropShadow.fontColor = SKColor.blackColor()
    dropShadow.zPosition = -1
    dropShadow.position = CGPointMake( -3, -3)
    text.addChild(dropShadow)
    
    let fadeAway = SKAction.fadeOutWithDuration(0.25)
    let sequence = SKAction.sequence([SKAction.waitForDuration(1), fadeAway, SKAction.removeFromParent()])
    text.runAction(sequence)
    
    self.addChild(text)
  }
  
  override func mouseDown(theEvent: NSEvent) {
    let location = theEvent.locationInNode(self)
    let clickedNode = self.nodeAtPoint(location)
    if clickedNode == self {return}
    
    if let pNode = clickedNode as? PieceNode {
      if (kDebugMovement) {
        print("start: row \(pNode.row), col \(pNode.col)")
      }
      
      if (players[currentPlayer].type == PlayerType.Attacker) {
        if (pNode.type != Piece.Attacker) {
          return;
        }
      } else if (players[currentPlayer].type == PlayerType.Defender) {
        if (pNode.type != Piece.Defender && pNode.type != Piece.King) {
          return;
        }
      }
      
      
      draggedNode = pNode
      pNode.moveToParent(self)
    }
  }
  
  override func mouseDragged(theEvent: NSEvent) {
    draggedNode?.position = theEvent.locationInNode(self)
  }
  
  override func mouseUp(theEvent: NSEvent) {
    var playSound = true
    if (draggedNode == nil) { return }
    
    let location = theEvent.locationInNode(self)
    let nodes = self.nodesAtPoint(location)
    for node in nodes {
      if let bNode = node as? BoardNode {
        if (kDebugMovement) {
          print("end: row \(bNode.row), col \(bNode.col)")
        }
        let m = GameMove(from: GamePoint(row: (draggedNode?.row)!, col: (draggedNode?.col)!), to: GamePoint(row: bNode.row, col: bNode.col))
        if game.didStayOnSquare(m) {
          playSound = false
        }
        if game.isMoveValid(m) {
          game.makeMove(m)
          draggedNode?.moveToParent(node)
          draggedNode?.position = CGPointMake(0, 0)
          draggedNode?.col = bNode.col
          draggedNode?.row = bNode.row
          draggedNode = nil
          
          removeDeadPieces()
          nextPlayer(nil)
          
          if game.didDefenderWin() {
            self.runAction(SKAction.playSoundFileNamed("lost.m4a", waitForCompletion: false))
            // TODO: show score screen
          } else if game.didAttackerWin() {
            self.runAction(SKAction.playSoundFileNamed("win.m4a", waitForCompletion: false))
            // TODO: show score screen
          } else {
            self.runAction(SKAction.playSoundFileNamed("placing.m4a", waitForCompletion: false))
          }

          
          return
        }
      }
    }
    
    let startNode = spriteBoard[draggedNode!.row, draggedNode!.col]
    draggedNode?.moveToParent(startNode)
    draggedNode?.position = CGPointMake(0, 0)
    draggedNode = nil
    if (playSound) {
      self.runAction(SKAction.playSoundFileNamed("invalid.m4a", waitForCompletion: false))
    }
  }
  
  override func update(currentTime: CFTimeInterval) {
      /* Called before each frame is rendered */
  }
  
  func removeDeadPieces() {
    for row in 0...spriteBoard.rows-1 {
      for col in 0...spriteBoard.columns-1 {
        let type = game.board[row, col]
        let square = spriteBoard[row, col]
        if (type == .Empty && square.children.count == 1) {
          square.children[0].runAction(deathAnimation())
        }
      }
    }
  }
  
  func deathAnimation() -> SKAction {
    let rotate = SKAction.rotateByAngle(CGFloat(M_PI/2), duration: 0.25)
    let fadeAway = SKAction.fadeOutWithDuration(0.25)
    let removeNode = SKAction.removeFromParent()
    let sound = SKAction.playSoundFileNamed("death.m4a", waitForCompletion: false)
    let group = SKAction.group([rotate, fadeAway, sound])
    return SKAction.sequence([group, removeNode])
  }
  
  func setupGame() {
    game.setup()
  }
  
  func nextPlayer(sender: AnyObject?) {
    currentPlayer = currentPlayer == 1 ? 0 : 1
    displayCurrentPlayer()
  }
  
  func drawBoard() {
    let xOffset:CGFloat = squareSize.height/2
    let yOffset:CGFloat = squareSize.width/2
    var toggle:Bool = false
    
    for row in 0...spriteBoard.rows-1 {
      for col in 0...spriteBoard.columns-1 {
        let color = toggle ? SKColor.clearColor() : SKColor.clearColor()
        let square = BoardNode(color: color, size: squareSize)
        // draw from top to bottom
        square.position = CGPointMake(CGFloat(col) * squareSize.width + xOffset,
          self.size.height - CGFloat(row+1) * squareSize.height + yOffset)
        
        square.col = col
        square.row = row
        self.addChild(square)
        spriteBoard[row, col] = square
        toggle = !toggle
      }
    }
  }

  func drawPieces() {
    let squareSize = CGSizeMake(80, 80)
    
    for row in 0...spriteBoard.rows-1 {
      for col in 0...spriteBoard.columns-1 {
        let square = spriteBoard[row, col]
        
        switch game.board[row, col] {
          case .Attacker:
            let s = PieceNode(imageNamed: "Attacker")
            s.size = squareSize
            s.col = col
            s.row = row
            s.type = Piece.Attacker
            square.addChild(s)
          case .Defender:
            let s = PieceNode(imageNamed: "Defender")
            s.size = squareSize
            s.col = col
            s.row = row
            s.type = Piece.Defender
            square.addChild(s)
          case .King:
            let s = PieceNode(imageNamed: "King")
            s.size = squareSize
            s.col = col
            s.row = row
            s.type = Piece.King
            square.addChild(s)
          default: ()
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
