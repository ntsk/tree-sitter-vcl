# tree-sitter-vcl

Varnish Configuration Language (VCL) grammar for [tree-sitter](https://github.com/tree-sitter/tree-sitter).

## Features

- Full VCL 4.x syntax support
- Syntax highlighting
- Code folding
- Indentation support

## Usage

This parser recognizes `.vcl` files and provides syntax highlighting for:

- VCL version declarations
- Import statements
- Backend definitions
- Subroutine declarations
- Control flow statements (if/elsif/else)
- Expressions and operators
- Comments (line and block)
- String and numeric literals
- Duration literals

## Development

### Prerequisites

- Node.js
- tree-sitter CLI

### Building

```bash
npm install
tree-sitter generate
tree-sitter test
```

## License

MIT

## References

- [Varnish Documentation](https://varnish-cache.org/docs/trunk/users-guide/vcl-syntax.html)
- [tree-sitter](https://tree-sitter.github.io/tree-sitter/)
