//
//  CompareBoardTests.swift
//  Hnefatafl
//
//  Created by Yannick Weiss on 18/09/15.
//  Copyright © 2015 Yannick Weiss. All rights reserved.
//

import XCTest
@testable import Hnefatafl

class CompareBoardTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
      let g = Game()
      g.setup()
      
      let A = Piece.Attacker
      let D = Piece.Defender
      let K = Piece.King
      let C = Piece.Corner
      let E = Piece.Empty
      
      var sameBoard = PieceMatrix(rows: 11, columns: 11)
      sameBoard.grid = [
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
      
      XCTAssertEqual(g.board, sameBoard, "Both boards should be equal")
      
      var differentBoard = PieceMatrix(rows: 11, columns: 11)
      differentBoard.grid = [
        C,E,E,A,A,A,A,A,E,E,C,
        E,E,E,E,E,A,E,E,E,E,E,
        E,E,E,E,E,D,E,E,E,E,E,
        A,E,E,E,E,D,E,E,E,E,A,
        A,E,E,E,D,D,D,E,E,E,A,
        A,A,E,D,D,K,D,D,E,A,A,
        A,E,E,E,D,D,D,E,E,E,A,
        A,E,E,E,E,D,E,E,E,E,A,
        E,E,E,E,E,E,E,E,E,E,E,
        E,E,E,E,E,A,E,E,E,E,E,
        C,E,E,A,A,A,A,A,E,E,C
      ]
      
      XCTAssertNotEqual(g.board, differentBoard, "Both boards should not be equal")
      
    }


}
