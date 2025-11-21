import XCTest
import SwiftTreeSitter
import TreeSitterVcl

final class TreeSitterVclTests: XCTestCase {
    func testCanLoadGrammar() throws {
        let parser = Parser()
        let language = Language(language: tree_sitter_vcl())
        XCTAssertNoThrow(try parser.setLanguage(language),
                         "Error loading TreeSitterVcl grammar")
    }
}
