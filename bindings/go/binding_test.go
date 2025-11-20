package tree_sitter_tree_sitter_vcl_test

import (
	"testing"

	tree_sitter "github.com/tree-sitter/go-tree-sitter"
	tree_sitter_tree_sitter_vcl "github.com/ntsk/tree-sitter-vcl/bindings/go"
)

func TestCanLoadGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_tree_sitter_vcl.Language())
	if language == nil {
		t.Errorf("Error loading TreeSitterVcl grammar")
	}
}
