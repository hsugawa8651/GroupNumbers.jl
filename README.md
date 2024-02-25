# GroupNumbers

[![Build Status](https://github.com/hsugawa8651/GroupNumbers.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/hsugawa8651/GroupNumbers.jl/actions/workflows/CI.yml?query=branch%3Amain)


Provides a few iterators for grouping the given iterator.

* `groupby2_dict` : simulates [`itertools.groupby`](https://docs.python.org/3/library/itertools.html#itertools.groupby) iterator of Python 3, and delivers pairs of key and grouped values.
* `groupby2_dict_indices` : same function as `groupby2_dict` but delivers grouped indices rather than grouped values.
* `groupby_numbers_dict` : groups (scalar and/or vector) values of floating point numbers, and delivers pairs of key and grouped values.
* `group_numbers_dict_indices` : same function as `groupby_numbers_dict` but delivers grouped indices rather than grouped values.

For each of the above itarators, alternative versions without `key` output are provided.

* `groupby2`
* `groupby2_dict`
* `group_numbers`
* `group_numbers_indices`


## Installation

Install this package with `Pkg.add("GroupNumbers")`
