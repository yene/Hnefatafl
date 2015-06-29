//
//  Game.swift
//  Hnefatafl
//
//  Created by Yannick Weiss on 29/06/15.
//  Copyright © 2015 Yannick Weiss. All rights reserved.
//

import Foundation
import SpriteKit

class Game {
  var board = Matrix(rows: 11, columns: 11)
  
  func checkWinCondition() {
   // king in corner = win for defender
    
    // defender cant make a move -> attacker win
    
    // king sourrounded by 4 attacker
    
    // king is sourrounded by 3 attacker and throne
    
    // special: all defenders are encircled, leads to defeat i guess anyway
  }
  
}
