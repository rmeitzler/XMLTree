//
//  XMLTreeManager.swift
//  XMLTreeManager
//
//  Created by Richard Meitzler on 8/12/21.
//

import AppKit

@available(macOS 10.15, *)
class XMLManager: ObservableObject {
  @Published var xmlData: Data?
  @Published var treeData: XMLTree?
  
  func loadXml(filename: String) {
    if let filepath = Bundle.main.path(forResource: filename, ofType: "xml") {
        do {
            let contents = try String(contentsOfFile: filepath)
            xmlData = contents.data(using: .utf8)
          
            if let data = xmlData {
              let parser = XMLTreeParser(data)
              treeData = parser.output
            }
          
        } catch let XMLTreeError.attributeNotFound(failedKey) {
          print("Could not find attribute: \(failedKey)")
        }
        catch let XMLTreeError.couldNotDecodeClass(className) {
          print("Could not decode \(className)")
        }
        catch {
            print("Could not load file")
          }
    }
  }
  
}
