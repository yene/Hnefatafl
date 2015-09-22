//
//  MovementTests.swift
//  Hnefatafl
//
//  Created by Yannick Weiss on 18/09/15.
//  Copyright © 2015 Yannick Weiss. All rights reserved.
//

import XCTest
@testable import Hnefatafl

class MovementTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testMove() {
    let g = Game()
    g.setup()
    let m = GameMove(from: GamePoint(col: 0, row: 0), to: GamePoint(col: 10, row: 10))
    XCTAssertTrue(g.isMoveInsideBoard(m))

    XCTAssertTrue(g.isMoveValid(GameMove(from: GamePoint(col: 0, row: 3), to: GamePoint(col: 0, row: 2))), "valid 1 up")
    XCTAssertTrue(g.isMoveValid(GameMove(from: GamePoint(col: 0, row: 3), to: GamePoint(col: 3, row: 3))), "valid 2 right")
    XCTAssertFalse(g.isMoveValid(GameMove(from: GamePoint(col: 0, row: 3), to: GamePoint(col: 8, row: 3))), "invalid 8 right")
    XCTAssertTrue(g.isMoveValid(GameMove(from: GamePoint(col: 10, row: 3), to: GamePoint(col: 8, row: 3))), "valid 2 left")
    XCTAssertFalse(g.isMoveValid(GameMove(from: GamePoint(col: 10, row: 3), to: GamePoint(col: 4, row: 3))), "invalid 8 left")
    XCTAssertFalse(g.isMoveValid(GameMove(from: GamePoint(col: 0, row: 3), to: GamePoint(col: 1, row: 2))), "invalid diagonal")
    XCTAssertFalse(g.isMoveValid(GameMove(from: GamePoint(col: 0, row: 3), to: GamePoint(col: -1, row: 3))), "invalid outside")
    XCTAssertFalse(g.isMoveValid(GameMove(from: GamePoint(col: 0, row: 1), to: GamePoint(col: 0, row: 4))), "invalid no starting piece")
    XCTAssertFalse(g.isMoveValid(GameMove(from: GamePoint(col: 0, row: 3), to: GamePoint(col: 0, row: 4))), "invalid does not end on empty")
    XCTAssertFalse(g.isMoveValid(GameMove(from: GamePoint(col: 0, row: 3), to: GamePoint(col: 5, row: 3))), "invalid can only move king onto corner")

  }
  
  func testPieceMovesOnThrone() {
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
      A,A,E,D,D,T,D,D,E,A,A,
      A,E,E,E,D,D,D,E,E,E,A,
      A,E,E,E,E,D,E,E,E,E,A,
      E,E,E,E,E,E,E,E,E,E,E,
      E,E,E,E,E,A,E,E,E,E,E,
      C,E,E,A,A,A,A,A,E,E,C
    ]
    XCTAssertFalse(g.isMoveValid(GameMove(from: GamePoint(col: 4, row: 5), to: GamePoint(col: 5, row: 5))), "invalid only king can move onto throne")
  }
  
  func testKingMovesOnThrone() {
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
      A,A,E,D,K,T,D,D,E,A,A,
      A,E,E,E,D,D,D,E,E,E,A,
      A,E,E,E,E,D,E,E,E,E,A,
      E,E,E,E,E,E,E,E,E,E,E,
      E,E,E,E,E,A,E,E,E,E,E,
      C,E,E,A,A,A,A,A,E,E,C
    ]
    XCTAssertTrue(g.isMoveValid(GameMove(from: GamePoint(col: 4, row: 5), to: GamePoint(col: 5, row: 5))), "king can move onto throne")
  }

}
