# tree-sitter-vcl

[![CI](https://github.com/ntsk/tree-sitter-vcl/actions/workflows/ci.yml/badge.svg)](https://github.com/ntsk/tree-sitter-vcl/actions/workflows/ci.yml)
[![crates.io](https://img.shields.io/badge/crates.io-tree--sitter--vcl-orange?logo=rust)](https://crates.io/crates/tree-sitter-vcl)
[![nixpkgs](https://img.shields.io/badge/nixpkgs-tree--sitter--vcl-blue?logo=nixos&logoColor=white)](https://search.nixos.org/packages?buckets={%22package_attr_set%22:[],%22package_license_set%22:[],%22package_maintainers_set%22:[%22ntsk%22],%22package_teams_set%22:[],%22package_platforms%22:[]}&channel=unstable&query=tree-sitter-vcl)

Varnish Configuration Language grammar for [tree-sitter](https://github.com/tree-sitter/tree-sitter).

## Usage

### Neovim

Neovim (0.11+) has built-in tree-sitter support. The parser must be compiled to a shared library and placed on the runtime path along with the highlight queries.

Both methods below require the [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md) on `$PATH` and a C compiler.

#### Using lazy.nvim

```lua
{
  "ntsk/tree-sitter-vcl",
  build = function(plugin)
    local data = vim.fn.stdpath("data")
    local parser_dir = data .. "/site/parser"
    local queries_dir = data .. "/site/queries/vcl"
    vim.fn.mkdir(parser_dir, "p")
    vim.fn.mkdir(queries_dir, "p")
    vim.fn.system({ "tree-sitter", "build", "-o", parser_dir .. "/vcl.so", plugin.dir })
    vim.fn.system({ "cp", plugin.dir .. "/queries/highlights.scm", queries_dir .. "/" })
  end,
  ft = "vcl",
  init = function()
    vim.filetype.add({ extension = { vcl = "vcl" } })
  end,
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "vcl",
      callback = function() vim.treesitter.start() end,
    })
  end,
}
```

`:Lazy update` rebuilds the parser whenever the grammar changes upstream.

#### Manual setup

If you don't use a plugin manager, build the parser and copy the queries yourself:

```sh
git clone https://github.com/ntsk/tree-sitter-vcl
cd tree-sitter-vcl

mkdir -p "$HOME/.local/share/nvim/site/parser"
tree-sitter build -o "$HOME/.local/share/nvim/site/parser/vcl.so"

mkdir -p "$HOME/.local/share/nvim/site/queries/vcl"
cp queries/highlights.scm "$HOME/.local/share/nvim/site/queries/vcl/"
```

Then add this to your Neovim config:

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

## Development

Requires Node.js and the [tree-sitter CLI](https://github.com/tree-sitter/tree-sitter/blob/master/crates/cli/README.md).

```sh
npm install
npx tree-sitter generate
npx tree-sitter test
npx tree-sitter parse example.vcl
```

After editing `grammar.js`, re-run `npx tree-sitter generate` to update `src/parser.c` and friends, then `npx tree-sitter test` to run the corpus tests under `test/corpus/`.

## References

- [Varnish Documentation](https://varnish-cache.org/docs/)
- [VCL Syntax](https://varnish-cache.org/docs/trunk/users-guide/vcl-syntax.html)