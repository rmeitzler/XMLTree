//
//  File.swift
//  File
//
//  Created by Richard Meitzler on 8/21/21.
//

import Foundation

public struct XMLSilo: Identifiable, Equatable, Hashable {
  public var id: UUID
  public var name: String
  public var depth: Int
  public var parentId: UUID?
  
  public init(id: UUID, name: String, depth: Int, parentId: UUID?) {
    self.id = id
    self.name = name
    self.depth = depth
    self.parentId = parentId
  }
  
  public init(from xmlTree: XMLTree) {
    self.id = xmlTree.id
    self.name = xmlTree.name
    self.depth = xmlTree.depth
    self.parentId = xmlTree.parentId
  }
}
