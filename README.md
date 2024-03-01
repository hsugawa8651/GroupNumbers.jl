# GroupNumbers

[![Build Status](https://github.com/hsugawa8651/GroupNumbers.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/hsugawa8651/GroupNumbers.jl/actions/workflows/CI.yml?query=branch%3Amain) [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://hsugawa8651.github.io/GroupNumbers.jl/stable/) [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://hsugawa8651.github.io/GroupNumbers.jl/dev/)


Provides a few iterators for grouping the given iterator.

* `groupby2_dict` : simulates [`itertools.groupby`](https://docs.python.org/3/library/itertools.html#itertools.groupby) iterator of Python 3, and emits pairs of key and grouped values.
* `groupby2_dict_indices` : same function as `groupby2_dict` but emits grouped indices rather than grouped values.
* `groupby_numbers_dict` : groups (scalar and/or vector) values of floating point numbers, and emits pairs of key and grouped values.
* `groupby_numbers_dict_indices` : same function as `groupby_numbers_dict` but emits grouped indices rather than grouped values.

For each of the above itarators, alternative versions without `key` output are provided.

* `groupby2`
* `groupby2_indices`
* `groupby_numbers`
* `groupby_numbers_indices`


## Installation

Install this package with `Pkg.add("GroupNumbers")`
