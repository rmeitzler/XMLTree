//
//  XMLTreeParser.swift
//  XMLTreeParser
//
//  Created by Richard Meitzler on 8/12/21.
//

import Foundation

public class XMLTreeParser: NSObject, XMLParserDelegate {
  private var parser: XMLParser
  public var output: XMLTree = XMLTree(name: "", depth: 0)
  private var depth = 0
  
  private var buildingSet: [XMLTree] = []
  
  public init(_ data: Data) {
    parser = XMLParser(data: data)
    super.init()
    
    parser.delegate = self
    parser.parse()
  }

  
  public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
      {
        var element = XMLTree(name: elementName, depth: depth)
        element.attributes = attributeDict
        buildingSet.append(element)
        depth += 1
      }
      
      public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
      {
        //print("ending: \(elementName)")
        if let popped = buildingSet.popLast() {
          let idx = buildingSet.count - 1
          if idx >= 0 {
            buildingSet[idx].addChild(popped)
          } else {
            output = popped
          }
        }
        depth -= 1
      }
      
    
      public func parser(_ parser: XMLParser, foundCharacters string: String)
      {
        //print("Characters:\(string)")
        let idx = buildingSet.count - 1
        buildingSet[idx].value = string
      }
      
    
      public func parser(_ parser: XMLParser, foundCDATA CDATABlock: Data)
      {
        //print("Encountered CData")
      }
      
 
      public func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
      {
        print("Error:\(parseError.localizedDescription)")
      }
}
