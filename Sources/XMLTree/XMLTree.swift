//
//  XMLTree.swift
//  XMLTree
//
//  Created by Richard Meitzler on 7/28/21.
//

import Foundation

public protocol XMLTreeDecodable {
  init(from xml: XMLTree) throws
}

public struct XMLTree: Identifiable, Equatable, Hashable {
  public static func == (lhs: XMLTree, rhs: XMLTree) -> Bool {
    lhs.id == rhs.id
  }
  
  public func hash(into hasher: inout Hasher) {
      hasher.combine(id.uuidString)
      hasher.combine(name)
      hasher.combine(attributes)
  }
  
  public var id: UUID = UUID()
  public var name: String
  public var depth: Int
  public var children: [XMLTree]?
  public var attributes: [String:String] = [:]
  public var value: String?
  
  public mutating func addChild(_ child: XMLTree) {
    if children != nil {
      children?.append(child)
    } else {
      children = [child]
    }
  }
  
  public mutating func addAttributes(key: String, value: String) {
    attributes[key] = value
  }
  
  public mutating func updateName(_ newName: String) {
    name = newName
  }
  
  public static func decodeAll<T: XMLTreeDecodable>(from: [XMLTree]?) throws -> [T]? {
    var output: [T] = []
    do {
      if let data = from, !data.isEmpty {
        for xml in data {
          let element: T = try T(from: xml)
          output.append(element)
        }
      }
    } catch {
      throw XMLTreeError.couldNotDecodeClass(String(describing: T.self))
    }
    return output.count > 0 ? output : nil
  }
  
  public func child(named: String) -> XMLTree? {
    guard let result = self.children?.filter({$0.name == named}).map({$0}).first else {
      return nil
    }
    
    return result
  }
  
  public func valueOfChild(named: String) -> String? {
    guard let result = self.children?.filter({$0.name == named}).map({$0}).first?.value else {
      return nil
    }
    
    return result
  }
  
  public func valuesOfChildren() -> [String]? {
    guard let result = self.children?.compactMap({ $0.value }) else {
      return nil
    }
    
    return result
  }
  
  public func attr(_ key: String) throws -> String {
      guard let result = self.attributes[key] else {
        throw XMLTreeError.attributeNotFound(key)
      }
      return result
  }
  
  public func attrIfPresent(_ key: String) -> String? {
      guard let result = self.attributes[key] else {
        return nil
      }
      return result
  }
  
}

extension Optional where Wrapped == [XMLTree] {
  public func decodeAll<T: XMLTreeDecodable>() throws -> [T]? {
    var output: [T] = []

      if let data = self {
        for xml in data {
          let element: T = try T(from: xml)
          output.append(element)
        }
      }
    return output.count > 0 ? output : nil
  }
}

extension XMLTree {
  public func decode<T: XMLTreeDecodable>() throws -> T {
    let element: T = try T(from: self)
    return element
  }
  public func decodeIfPresent<T: XMLTreeDecodable>() throws -> T? {
    let output: T? = try T(from: self)
    return output
  }
}

public enum XMLTreeError: Error {
    case couldNotDecodeClass(String)
    case attributeNotFound(String)
    case problemDecodingNode(String)
}
