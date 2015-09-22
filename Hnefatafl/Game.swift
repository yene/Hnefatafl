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


struct GamePoint {
  let row: Int;
  let col: Int;
}

struct GameMove {
  let from: GamePoint;
  let to: GamePoint;
}

let BoardMid = 5

class Game {
  var board = PieceMatrix(rows: 11, columns: 11)
  
  func setup() {
    let A = Piece.Attacker
    let D = Piece.Defender
    let K = Piece.King
    let C = Piece.Corner
    let E = Piece.Empty
    
     board.grid = [
      C,E,E,A,A,A,A,A,E,E,C,
      E,E,E,E,E,A,E,E,E,E,E,
      E,E,E,E,E,E,E,E,E,E,E,
      A,E,E,E,E,D,E,E,E,E,A,
      A,E,E,E,D,D,D,E,E,E,A,
      A,A,E,D,D,K,D,D,E,A,A,
      A,E,E,E,D,D,D,E,E,E,A,
      A,E,E,E,E,D,E,E,E,E,A,
      E,E,E,E,E,E,E,E,E,E,E,
      E,E,E,E,E,A,E,E,E,E,E,
      C,E,E,A,A,A,A,A,E,E,C
    ]
  }
  
  func makeMove(m: GameMove) {
    let p = board[m.from.row, m.from.col]
    board[m.to.row, m.to.col] = p
    if p == .King && m.from.row == BoardMid && m.from.col == BoardMid {
      board[m.from.row, m.from.col] = .Throne
    } else {
      board[m.from.row, m.from.col] = .Empty
    }

    removeKilledPieces(m)
  }
  
  func removeKilledPieces(m: GameMove) {
    let myType = board[m.to.row, m.to.col]
    let enemyType: Piece = myType == .Attacker ? .Defender : .Attacker
    
    // check the sourrounding pieces, if they die because of this move
    if (m.to.row > 0 && board[m.to.row-1, m.to.col] == enemyType) {
      checkPieceDeath(GamePoint(row: m.to.row-1, col: m.to.col))
    }
    if (m.to.row < 11 && board[m.to.row+1, m.to.col] == enemyType) {
      checkPieceDeath(GamePoint(row: m.to.row+1, col: m.to.col))
    }
    if (m.to.col > 0 && board[m.to.row, m.to.col-1] == enemyType) {
      checkPieceDeath(GamePoint(row: m.to.row, col: m.to.col-1))
    }
    if (m.to.col < 11 && board[m.to.row, m.to.col+1] == enemyType) {
      checkPieceDeath(GamePoint(row: m.to.row, col: m.to.col+1))
    }
    
  }
  
  func checkPieceDeath(p: GamePoint) {
    let myType: Piece = board[p.row, p.col]
    
    if (myType == .Defender) {
      if (p.row > 0 && p.row < 11 && board[p.row-1, p.col] == .Attacker && board[p.row+1, p.col] == .Attacker) {
        board[p.row, p.col] = .Empty
        return
      }
      if (p.col > 0 && p.col < 11 && board[p.row, p.col-1] == .Attacker && board[p.row, p.col+1] == .Attacker) {
        board[p.row, p.col] = .Empty
        return
      }
    }
    
    if (myType == .Attacker) {
      if (p.row > 0 && p.row < 11 &&
        ((board[p.row-1, p.col] == .Defender || board[p.row-1, p.col] == .King) &&
          (board[p.row+1, p.col] == .Defender || board[p.row+1, p.col] == .King))) {
        board[p.row, p.col] = .Empty
        return
      }
      if (p.col > 0 && p.col < 11 &&
        ((board[p.row, p.col-1] == .Defender || board[p.row, p.col-1] == .King) &&
          (board[p.row, p.col+1] == .Defender || board[p.row, p.col+1] == .King))) {
        board[p.row, p.col] = .Empty
        return
      }
    }
    
  }
  
  func isMoveValid(m: GameMove) -> Bool {
    if (didStayOnSquare(m)) {
      return false
    }
    
    if (!isMoveStraight(m)) {
      return false
    }
    if (!isMoveInsideBoard(m)) {
      return false
    }
    if (!canPieceMove(m)) {
      return false
    }
    if (!isTargetValid(m)) {
      return false
    }
    if (didPassOverUnits(m)) {
      return false
    }
    return true
  }
  
  func didPassOverUnits(m: GameMove) -> Bool {
    
    if m.from.row == m.to.row {
      for i in min(m.from.col,m.to.col) ... max(m.from.col,m.to.col) {
        // skip start and end location
        if (i == m.from.col) {continue}
        if (i == m.to.col) {continue}
        if board[m.from.row, i] != Piece.Empty && board[m.from.row, i] != Piece.Throne {
          return true
        }
      }
    }

    if m.from.col == m.to.col {
      for i in min(m.from.row, m.to.row) ... max(m.from.row, m.to.row) {
        // skip start and end location
        if (i == m.from.row) {continue}
        if (i == m.to.col) {continue}
        if board[i, m.from.col] != Piece.Empty && board[i, m.from.col] != Piece.Throne {
          return true
        }
      }
    }
    
    return false
  }
  
  func canPieceMove(m: GameMove) -> Bool {
    return board[m.from.row, m.from.col] == Piece.Attacker || board[m.from.row, m.from.col] == Piece.Defender || board[m.from.row, m.from.col] == Piece.King
  }
  
  func isTargetValid(m: GameMove) -> Bool {
    if (board[m.from.row, m.from.col] == Piece.King) {
      // king can move onto corner and throne
      return board[m.to.row, m.to.col] == Piece.Corner || board[m.to.row, m.to.col] == Piece.Throne || board[m.to.row, m.to.col] == Piece.Empty
    }
    
    return board[m.to.row, m.to.col] == Piece.Empty
  }
  
  func didStayOnSquare(m: GameMove) -> Bool {
    return (m.from.col == m.to.col && m.from.row == m.to.row)
  }
  
  func isMoveStraight(m: GameMove) -> Bool {
    return (m.from.col == m.to.col || m.from.row == m.to.row);
  }
  
  func isMoveInsideBoard(m: GameMove) -> Bool {
     return min(m.from.col, m.from.row, m.to.col, m.to.row) >= 0 && max(m.from.col, m.from.row, m.to.col, m.to.row) <= 10
  }
  
  func didAttackerWin() -> Bool {
    let k = board.king()
    
    // the king cannot be captured on the side
    if (k.col == 0 || k.col == 10 || k.row == 0 || k.row == 10) {
      return false;
    }
    
    // sourrounded by attackers
    if (board[k.row, k.col-1] == Piece.Attacker &&
        board[k.row, k.col+1] == Piece.Attacker &&
        board[k.row-1, k.col] == Piece.Attacker &&
        board[k.row+1, k.col] == Piece.Attacker) {
        return true;
    }
    
    // sourrounded by attackers and throne
    if (board[k.row, k.col-1] == Piece.Throne &&
      board[k.row, k.col+1] == Piece.Attacker &&
      board[k.row-1, k.col] == Piece.Attacker &&
      board[k.row+1, k.col] == Piece.Attacker) {
        return true;
    }
    if (board[k.row, k.col-1] == Piece.Attacker &&
      board[k.row, k.col+1] == Piece.Throne &&
      board[k.row-1, k.col] == Piece.Attacker &&
      board[k.row+1, k.col] == Piece.Attacker) {
        return true;
    }
    if (board[k.row, k.col-1] == Piece.Attacker &&
      board[k.row, k.col+1] == Piece.Attacker &&
      board[k.row-1, k.col] == Piece.Throne &&
      board[k.row+1, k.col] == Piece.Attacker) {
        return true;
    }
    if (board[k.row, k.col-1] == Piece.Attacker &&
      board[k.row, k.col+1] == Piece.Attacker &&
      board[k.row-1, k.col] == Piece.Attacker &&
      board[k.row+1, k.col] == Piece.Throne) {
        return true;
    }
    
    return false
  }
  
  func didDefenderWin() -> Bool {
    return board[0,0] == .King || board[0,10] == .King || board[10,10] == .King || board[10,0] == .King
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
  
  func king() -> GamePoint {
    for row in 0...rows-1 {
      for col in 0...columns-1 {
        if (self[row, col] == Piece.King) {
          return GamePoint(row: row, col: col)
        }
      }
    }
    // TODO: Exception or crash when king not found, I have no idea how to error handle this inconsistency
    return GamePoint(row: 4, col: 4)
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

extension PieceMatrix: Equatable {}

func ==(lhs: PieceMatrix, rhs: PieceMatrix) -> Bool {
  if (lhs.columns != rhs.columns || lhs.rows != rhs.rows) {
    return false
  }
  
  for row in 0...lhs.rows-1 {
    for col in 0...lhs.columns-1 {
      if (lhs[row, col] != rhs[row, col]) {
        return false
      }
    }
  }
  
  return true
}
