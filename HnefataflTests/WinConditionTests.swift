//
//  WinConditionTests.swift
//  Hnefatafl
//
//  Created by Yannick Weiss on 18/09/15.
//  Copyright © 2015 Yannick Weiss. All rights reserved.
//

import XCTest
@testable import Hnefatafl

class WinConditionTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testNobodyDidWin() {
    let g = Game()
    g.setup()

    XCTAssertFalse(g.didAttackerWin(), "attacker did not win")
    XCTAssertFalse(g.didDefenderWin(), "defender did not win")
  }
  
  
  func testAttackerDidWin() {
    let g = Game()
    g.setup()
    let A = Piece.Attacker
    let D = Piece.Defender
    let K = Piece.King
    let C = Piece.Corner
    let E = Piece.Empty
    let T = Piece.Throne
    g.board.grid = [
      C,E,E,A,A,A,A,A,E,E,C,
      E,E,E,E,E,A,E,E,E,E,E,
      E,E,E,E,A,K,A,E,E,E,E,
      A,E,E,E,E,A,E,E,E,E,A,
      A,E,E,E,D,D,D,E,E,E,A,
      A,A,E,D,D,K,D,D,E,A,A,
      A,E,E,E,D,D,D,E,E,E,A,
      A,E,E,E,E,D,E,E,E,E,A,
      E,E,E,E,E,E,E,E,E,E,E,
      E,E,E,E,E,A,E,E,E,E,E,
      C,E,E,A,A,A,A,A,E,E,C
    ]
    
    XCTAssertTrue(g.didAttackerWin(), "attacker did win")
    
    g.board.grid = [
      C,E,E,A,A,A,A,A,E,E,C,
      E,E,E,E,E,A,E,E,E,E,E,
      E,E,E,E,E,E,E,E,E,E,E,
      A,E,E,E,E,D,E,E,E,E,A,
      A,E,E,E,A,D,D,E,E,E,A,
      A,A,E,A,K,T,D,D,E,A,A,
      A,E,E,E,A,D,D,E,E,E,A,
      A,E,E,E,E,D,E,E,E,E,A,
      E,E,E,E,E,E,E,E,E,E,E,
      E,E,E,E,E,A,E,E,E,E,E,
      C,E,E,A,A,A,A,A,E,E,C
    ]
    
    XCTAssertTrue(g.didAttackerWin(), "attacker did win, king surrounded with throne")
  }
  
  
  func testDefenderDidWin() {
    let g = Game()
    g.setup()
    let A = Piece.Attacker
    let D = Piece.Defender
    let K = Piece.King
    let C = Piece.Corner
    let E = Piece.Empty
    g.board.grid = [
      K,E,E,A,A,A,A,A,E,E,C,
      E,E,E,E,E,A,E,E,E,E,E,
      E,E,E,E,E,D,E,E,E,E,E,
      A,E,E,E,E,D,E,E,E,E,A,
      A,E,E,E,D,D,D,E,E,E,A,
      A,A,E,D,D,E,D,D,E,A,A,
      A,E,E,E,D,D,D,E,E,E,A,
      A,E,E,E,E,D,E,E,E,E,A,
      E,E,E,E,E,E,E,E,E,E,E,
      E,E,E,E,E,A,E,E,E,E,E,
      C,E,E,A,A,A,A,A,E,E,C
    ]
    
    XCTAssertTrue(g.didDefenderWin(), "defender did win")
    
  }


}
