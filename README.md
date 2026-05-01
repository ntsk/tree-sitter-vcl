# tree-sitter-vcl

[![CI](https://github.com/ntsk/tree-sitter-vcl/actions/workflows/ci.yml/badge.svg)](https://github.com/ntsk/tree-sitter-vcl/actions/workflows/ci.yml)

Varnish Configuration Language grammar for [tree-sitter](https://github.com/tree-sitter/tree-sitter).

## Usage

### Neovim

Neovim (0.11+) has built-in tree-sitter support. Build the parser, install it, and place the queries on the runtime path.

#### 1. Build and install the parser

Requires [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md) and a C compiler.

```sh
git clone https://github.com/ntsk/tree-sitter-vcl
cd tree-sitter-vcl
tree-sitter generate
cc -o vcl.so -shared -Os -fPIC -I src src/parser.c

mkdir -p "$HOME/.local/share/nvim/site/parser"
mv vcl.so "$HOME/.local/share/nvim/site/parser/vcl.so"

mkdir -p "$HOME/.local/share/nvim/site/queries/vcl"
cp queries/highlights.scm "$HOME/.local/share/nvim/site/queries/vcl/"
```

#### 2. Configure Neovim

```lua
vim.filetype.add({
  extension = {
    vcl = "vcl",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "vcl",
  callback = function()
    vim.treesitter.start()
  end,
})
```

## References

- [Varnish Documentation](https://varnish-cache.org/docs/)
- [VCL Syntax](https://varnish-cache.org/docs/trunk/users-guide/vcl-syntax.html)