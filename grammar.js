/**
 * @file Varnish Configuration Launguage grammer for tree-sitter
 * @author ntsk <ntsk@ntsk.jp>
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: "tree_sitter_vcl",

  rules: {
    // TODO: add the actual grammar rules
    source_file: $ => "hello"
  }
});
