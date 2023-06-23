---
title: "Reordering Go functions to allow top-down reading"
layout: single
---

One of the nice things about Go is that it allows a function call expression to
precede the corresponding function declaration, unlike for e.g. C. An
implication of this property is that the function declarations in a program can
be arranged in such a way that one reads it in a top down manner.

Consider the following program -

```
func qux() { ... }

func baz() { ... }

func bar() {
  qux()
}

func foo() { // entry point
  bar()
  baz()
}
```

The ordering of function declarations above might lead to one scrolling a bit
before reaching and identifying the entry point `foo` (for relatively larger
programs). A valid alternate representation for the above program could be -

```
func foo() { // entry point
  bar()
  baz()
}

func bar() {
  qux()
}

func qux() { ... }

func baz() { ... }
```

This representation improves readability by allowing one to read the program
from top to down. If the function names are descriptive enough, then one might
not necessarily need to know the specifics of `bar` and `baz` to get an idea of
what `foo` is doing. This makes most of the information about the program
available at the top.

## Rewriting the AST
One can think of the above program as a directed graph where each node is a
function declaration and an edge from `foo` to `bar` represents that `foo`'s
declaration contains a call to `bar`.

<br>
<center><img src="/images/graph.svg"></center>
<br>

The desired sequence of function declarations is the topological ordering of
above directed acyclic graph.

Go provides a rich toolset for manipulating ASTs. The
[astutil](golang.org/x/tools/go/ast/astutil) package allows finding nodes of
interest in the AST, and also provides an API to
[replace](https://pkg.go.dev/golang.org/x/tools/go/ast/astutil#Cursor.Replace)
them. A nice walkthrough of these capabilities is documented
[here](https://eli.thegreenplace.net/2021/rewriting-go-source-code-with-ast-tooling/).

In this case, we need to replace the nodes corresponding to function
declarations to achieve the desired ordering. However, the corresponding
comments would not be reordered since they are not attached to the AST nodes
and are free-floating (see issue
[#20744](https://github.com/golang/go/issues/20744)). Package
[dave/dst](https://pkg.go.dev/github.com/dave/dst@v0.26.2) solves exactly this
shortcoming and provides similar APIs to Go's AST tooling with added support of
retaining comment positions relative to AST nodes.

## Implementation

The implementation is available
[here](https://github.com/shivansh/rewrite/tree/main/reorder) and can be used via -
```
$ go install github.com/shivansh/rewrite/reorder@latest
$ reorder
usage: reorder [-svg graph.svg] file.go
```