//
//  Game.swift
//  Hnefatafl
//
//  Created by Yannick Weiss on 29/06/15.
//  Copyright © 2015 Yannick Weiss. All rights reserved.
//

import Foundation
import SpriteKit

enum Piece {
  case Attacker
  case Defender
  case King
  case Corner
  case Throne
  case Empty
}

class Game {
  var board = PieceMatrix(rows: 11, columns: 11)
  
  func checkWinCondition() {
   // king in corner = win for defender
    
    // defender cant make a move -> attacker win
    
    // king sourrounded by 4 attacker
    
    // king is sourrounded by 3 attacker and throne
    
    // special: all defenders are encircled, leads to defeat i guess anyway
  }
  
}

struct PieceMatrix {
  let rows: Int, columns: Int
  var grid: [Piece]
  init(rows: Int, columns: Int) {
    self.rows = rows
    self.columns = columns
    grid = Array(count: rows * columns, repeatedValue: Piece.Empty)
  }
  func indexIsValidForRow(row: Int, column: Int) -> Bool {
    return row >= 0 && row < rows && column >= 0 && column < columns
  }
  subscript(row: Int, column: Int) -> Piece {
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