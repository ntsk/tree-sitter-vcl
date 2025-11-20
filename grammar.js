/**
 * @file Varnish Configuration Launguage grammer for tree-sitter
 * @author ntsk <ntsk@ntsk.jp>
 * @license MIT
 */

/// <reference types="tree-sitter-cli/dsl" />

module.exports = grammar({
  name: "tree_sitter_vcl",

  extras: $ => [
    /\s/,
    $.comment,
  ],

  rules: {
    source_file: $ => repeat($._statement),

    _statement: $ => choice(
      $.vcl_declaration,
      $.import_statement,
      $.backend_declaration,
      $.subroutine_declaration,
    ),

    comment: $ => token(choice(
      seq('#', /.*/),
      seq('//', /.*/),
      seq('/*', /[^*]*\*+([^/*][^*]*\*+)*/, '/'),
    )),

    vcl_declaration: $ => seq(
      'vcl',
      field('version', $.version),
      ';'
    ),

    version: $ => /\d+\.\d+/,

    import_statement: $ => seq(
      'import',
      $.identifier,
      optional(seq('from', $.string)),
      ';'
    ),

    backend_declaration: $ => seq(
      'backend',
      $.identifier,
      '{',
      field('properties', $.backend_properties),
      '}'
    ),

    backend_properties: $ => repeat1($.backend_property),

    backend_property: $ => choice(
      seq(
        field('name', $.property_name),
        '=',
        field('value', $.probe_properties)
      ),
      seq(
        field('name', $.property_name),
        '=',
        field('value', choice(
          $.string,
          $.integer,
          $.duration,
        )),
        ';'
      )
    ),

    probe_properties: $ => seq(
      '{',
      repeat($.probe_property),
      '}'
    ),

    probe_property: $ => seq(
      field('name', $.property_name),
      '=',
      field('value', choice(
        $.string,
        $.integer,
        $.duration,
      )),
      ';'
    ),

    property_name: $ => /\.[a-zA-Z_][a-zA-Z0-9_]*/,

    subroutine_declaration: $ => seq(
      'sub',
      $.identifier,
      $.block
    ),

    block: $ => seq(
      '{',
      repeat($._subroutine_statement),
      '}'
    ),

    _subroutine_statement: $ => choice(
      $.if_statement,
      $.set_statement,
      $.unset_statement,
      $.return_statement,
      $.call_statement,
    ),

    if_statement: $ => seq(
      'if',
      field('condition', $.condition),
      field('consequence', $.block),
      optional(seq('elsif', field('condition', $.condition), field('alternative', $.block))),
      optional(seq('else', field('alternative', $.block)))
    ),

    condition: $ => seq(
      '(',
      $._expression,
      ')'
    ),

    set_statement: $ => seq(
      'set',
      field('left', $._expression),
      '=',
      field('right', $._expression),
      ';'
    ),

    unset_statement: $ => seq(
      'unset',
      $._expression,
      ';'
    ),

    return_statement: $ => seq(
      'return',
      '(',
      $.identifier,
      ')',
      ';'
    ),

    call_statement: $ => seq(
      'call',
      $.identifier,
      ';'
    ),

    _expression: $ => choice(
      $.binary_expression,
      $.unary_expression,
      $.member_expression,
      $.string,
      $.long_string,
      $.integer,
      $.duration,
      $.boolean,
      $.identifier,
    ),

    binary_expression: $ => choice(
      prec.left(1, seq($._expression, '||', $._expression)),
      prec.left(2, seq($._expression, '&&', $._expression)),
      prec.left(3, seq($._expression, '==', $._expression)),
      prec.left(3, seq($._expression, '!=', $._expression)),
      prec.left(3, seq($._expression, '~', $._expression)),
      prec.left(3, seq($._expression, '!~', $._expression)),
      prec.left(4, seq($._expression, '<', $._expression)),
      prec.left(4, seq($._expression, '<=', $._expression)),
      prec.left(4, seq($._expression, '>', $._expression)),
      prec.left(4, seq($._expression, '>=', $._expression)),
      prec.left(5, seq($._expression, '+', $._expression)),
      prec.left(5, seq($._expression, '-', $._expression)),
      prec.left(6, seq($._expression, '*', $._expression)),
      prec.left(6, seq($._expression, '/', $._expression)),
      prec.left(6, seq($._expression, '%', $._expression)),
    ),

    unary_expression: $ => prec(7, seq(
      '!',
      $._expression
    )),

    member_expression: $ => prec.left(8, seq(
      $.identifier,
      repeat1(seq('.', $.identifier))
    )),

    string: $ => /"([^"\\]|\\.)*"/,

    long_string: $ => token(choice(
      seq('{"', repeat(choice(/[^"}]/, /"[^}]/)), '"}'),
      seq('"""', /(.|\n|\r)*?/, '"""'),
    )),

    integer: $ => /\d+/,

    duration: $ => /\d+(\.\d+)?(ms|s|m|h|d|w|y)/,

    boolean: $ => choice('true', 'false'),

    identifier: $ => /[a-zA-Z_][a-zA-Z0-9_]*(-[a-zA-Z0-9_]+)*/,
  }
});
