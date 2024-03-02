# GroupNumbers

[![Build Status](https://github.com/hsugawa8651/GroupNumbers.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/hsugawa8651/GroupNumbers.jl/actions/workflows/CI.yml?query=branch%3Amain) [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://hsugawa8651.github.io/GroupNumbers.jl/stable/) [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://hsugawa8651.github.io/GroupNumbers.jl/dev/)


Provides iterators for grouping the given iterator of possibly numbers.

## Quick start

```julia
julia> for g in groupby_numbers([ 16e-4, 17e-4, 19e-4, 20e-4 ] .+ 1; rtol=2e-4)
           @show g
       end
g = [1.0016, 1.0017]
g = [1.0019, 1.002]
```

Please refer to the [documentation](https://hsugawa8651.github.io/GroupNumbers.jl/stable/) for comprehensive guides and examples.