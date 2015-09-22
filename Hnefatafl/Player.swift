//
//  Player.swift
//  Hnefatafl
//
//  Created by Yannick Weiss on 19/06/15.
//  Copyright © 2015 Yannick Weiss. All rights reserved.
//

import Foundation

enum PlayerType {
  case Attacker
  case Defender
}

struct Player {
  var type: PlayerType
  var name: String
}