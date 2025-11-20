;; Keywords
[
  "vcl"
  "backend"
  "sub"
  "import"
  "from"
  "if"
  "elsif"
  "else"
  "return"
  "set"
  "unset"
  "call"
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
  ","
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

(return_statement
  (identifier) @constant)

;; Property names
(property_name) @property

;; Member expressions
(member_expression
  (identifier) @variable)
