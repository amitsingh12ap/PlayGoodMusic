//
//  Binding.swift
//  PlayGoodMusic
//
//  Created by 13216146 on 15/06/20.
//  Copyright © 2020 13216146. All rights reserved.
//

import Foundation

class Binding<T> {
  var value: T {
    didSet {
      listener?(value)
    }
  }
  private var listener: ((T) -> Void)?
  init(value: T) {
    self.value = value
  }
  func bind(_ closure: @escaping (T) -> Void) {
    closure(value)
    listener = closure
  }
}
