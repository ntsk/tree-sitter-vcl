# tree-sitter-vcl

[![CI](https://github.com/ntsk/tree-sitter-vcl/actions/workflows/ci.yml/badge.svg)](https://github.com/ntsk/tree-sitter-vcl/actions/workflows/ci.yml)

Varnish Configuration Language grammar for [tree-sitter](https://github.com/tree-sitter/tree-sitter).

## Usage

### Neovim

For usage with [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter), add this to your configuration:

```lua
-- Register VCL parser
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.vcl = {
  install_info = {
    url = "https://github.com/ntsk/tree-sitter-vcl",
    files = {"src/parser.c"},
    branch = "main",
  },
  filetype = "vcl",
}
```

```vim
" Set filetype and enable highlighting
autocmd BufNewFile,BufRead *.vcl set filetype=vcl
autocmd FileType vcl TSBufEnable highlight
```

Then run `:TSInstall vcl`

## References

- [Varnish Documentation](https://varnish-cache.org/docs/)
- [VCL Syntax](https://varnish-cache.org/docs/trunk/users-guide/vcl-syntax.html)