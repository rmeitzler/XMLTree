//
//  XMLTreeManager.swift
//  XMLTreeManager
//
//  Created by Richard Meitzler on 8/12/21.
//

import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)

public class XMLManager: ObservableObject {
  @Published public var xmlData: Data?
  @Published public var treeData: XMLTree?
  
  public init() {
    
  }
  
  public func loadXml(filename: String) {
    print("loading::\(filename)")
    
    if let filepath = Bundle.main.path(forResource: filename, ofType: "xml") {
      
        do {
            let contents = try String(contentsOfFile: filepath)
            xmlData = contents.data(using: .utf8)
            parseXML(data: xmlData)
          
        } catch let XMLTreeError.attributeNotFound(failedKey) {
          print("Could not find attribute: \(failedKey)")
        }
        catch let XMLTreeError.couldNotDecodeClass(className) {
          print("Could not decode \(className)")
        }
        catch let XMLTreeError.problemDecodingNode(node) {
          print("\(node) broke everything")
        }
        catch {
            print("Could not load file")
          }
    }
  }
  
  public func parseXML(data xmlData: Data?) {
    if let data = xmlData {
      let parser = XMLTreeParser(data)
      treeData = parser.output
    }
  }
  
}
