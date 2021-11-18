---
title: "Evaluating code coverage for a Go project"
layout: single
---

This post aims to provide a solution for evaluating code coverage of a Go
project. The motivation behind this is that by default `go test` evaluates per
package code coverage. It is possible that even though a package `u` itself
doesn't have any tests, it might be covered by a different package `v` which
imports `u`.

We'll take this repo as a reference - [https://github.com/shivansh/coverage](https://github.com/shivansh/coverage).

First, checkout to the root commit of the repo. In this state, we have package
`a` which imports package `b` and calls `b.Bar()`. `b` doesn't have any tests
but is covered by `a` as is visible below -
```
$ git checkout fd9d9b69596b035a117fa2f06b674688ad2e6c06
$ go test -coverpkg=./... ./...
ok      example.com/a   (cached)        coverage: 100.0% of statements in ./...
?       example.com/b   [no test files]
```

We now add new package `c` which also calls `b.Bar()`. Also, a new function
`Baz` is introduced in package `b` which is uncovered.
```
$ git checkout dd7c9f351ccc1f7cdbe867b3d5740c82e0dc3f5a
$ go test -coverpkg=./... ./...
ok      example.com/a   (cached)        coverage: 50.0% of statements in ./...
?       example.com/b   [no test files]
ok      example.com/c   (cached)        coverage: 50.0% of statements in ./...
```

At this point both `a` and `c` show 50% coverage in `./...`. Although these
individual coverages add up to 100%, it's not accurate because it is possible
that both `a` and `c` cover overlapping statements in `b` (which happens to be
the case here).

The accurate coverage can be evaluated by analyzing the cover profile -
```
$ go test -coverpkg=./... ./... -coverprofile=cover.out
$ go tool cover -func=cover.out
example.com/a/x.go:9:   foo             100.0%
example.com/b/y.go:5:   Bar             100.0%
example.com/b/y.go:9:   Baz             0.0%
example.com/c/z.go:9:   qux             100.0%
total:                  (statements)    83.3%
```

As a last step, we invoke `b.Baz()` in package `c` to achieve 100% coverage.
This can be confirmed by repeating the previous steps.

```
$ git checkout 5b39b83f072d306d0f97cd457779fe82be8081af
$ go test -coverpkg=./... ./... -coverprofile=cover.out
$ go tool cover -func=cover.out
example.com/a/x.go:9:   foo             100.0%
example.com/b/y.go:5:   Bar             100.0%
example.com/b/y.go:9:   Baz             100.0%
example.com/c/z.go:9:   qux             100.0%
total:                  (statements)    100.0%
```
