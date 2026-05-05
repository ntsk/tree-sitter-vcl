;; Keywords
[
  "vcl"
  "backend"
  "probe"
  "acl"
  "sub"
  "import"
  "include"
  "from"
  "if"
  "elsif"
  "elseif"
  "else"
  "return"
  "set"
  "unset"
  "call"
  "new"
] @keyword

;; Operators
[
  "="
  "=="
  "!="
  "~"
  "!~"
  "<"
  "<="
  ">"
  ">="
  "&&"
  "||"
  "!"
  "+"
  "-"
  "*"
  "/"
  "%"
] @operator

;; Delimiters
[
  ";"
  "."
] @punctuation.delimiter

[
  "("
  ")"
  "{"
  "}"
] @punctuation.bracket

;; Literals
(string) @string
(long_string) @string
(integer) @number
(duration) @number
(boolean) @boolean
(version) @number

;; Comments
(comment) @comment

;; Identifiers
(identifier) @variable

;; Special identifiers (built-in subroutines and variables)
((identifier) @function.builtin
  (#match? @function.builtin "^vcl_"))

((identifier) @variable.builtin
  (#match? @variable.builtin "^(req|bereq|beresp|resp|obj|client|server|storage|now)$"))

;; Function calls and subroutine declarations
(subroutine_declaration
  (identifier) @function)

(call_statement
  (identifier) @function)

(call_expression
  (identifier) @function)

(function_call
  (identifier) @function)

(return_statement
  (identifier) @constant)

;; ACL declarations
(acl_declaration
  (identifier) @type)

;; Property names
(property_name) @property

;; Member expressions
(member_expression
  (identifier) @variable)
