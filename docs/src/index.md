# GroupNumbers

## Installation

Install this package with `Pkg.add("GroupNumbers")`

## Description

* `groupby2YYYZZZ(xs; keyfunc=identity, compare=isequal)`
* `groupby_numbersYYYZZZ(xs; keyfunc=identity, compare=isapprox, kwargs)`

Here, "YYY" = "" or "\_dict", and "ZZZ" = "" or "\_indices".


A family of iterators for grouping adjecent elements of the given iterator `xs`.

Apply `keyfunc` function to each element of `xs` to compute the key for comparison.
For default, `keyfunc` is `identity`, so the key is each element itself.

Compare the adjacent keys by `compare` function.
While `groupby2YYYZZZ` family  adopt `isequal` to the default `compare` function, 
`groupby_numbersYYYZZZ` family adopt `isapprox` to the default `compare` function 
with accompanying `kwargs` being supplied to the optional keyword parameters of 
this default `isapprox` function, allowing the control of the tolerance.

While unbranded iterators ("ZZZ" = "") emit the grouped elements,
the `_indices` alternatives ("ZZZ" = "\_indices" ) emit the indices of the grouped elements.

While unbranded iterators ("YYY" = "") emit only the grouped elements or their indices,
the `_dict` alternatives ("YYY" = "\_dict" ) emit also the first keys.



| `compare` function | emits the grouped elements          | emits the grouped indices           |                |
|:-------------------|:--------------------------------|:--------------------------------|:---------------|
| `isequal`          | `groupby2`                      | `groupby2_indices`              |                |
|                    | `groupby2_dict`                 | `groupby2_dict_indices`         | also emits key |
| `isapprox`         | `groupby_numbers`               | `groupby_numbers_indices`       |                |
|                    | `groupby_numbers_dict`          | `groupby_numbers_dict_indices`  | also emits key |

# Examples

## Example 1: Groups characters in a string

`groupby2(xs)` is equivalent to `IterTools.groupby(identity, xs)`.

### Simple case

```julia
julia> collect(groupby2("AAAABBBCCD"))
4-element Vector{Vector{Char}}:
 ['A', 'A', 'A', 'A']
 ['B', 'B', 'B']
 ['C', 'C']
 ['D']
```

```julia
julia> using IterTools
julia> collect(IterTools.groupby(identity, "AAAABBBCCD")); # => same result
```

### Emits keys

Use `groupby2_dict(xs)` if you need the keys.

```julia
julia> collect(groupby2_dict("AAAABBBCCD"))
4-element Vector{Tuple{Any, Vector{Char}}}:
 ('A', ['A', 'A', 'A', 'A'])
 ('B', ['B', 'B', 'B'])
 ('C', ['C', 'C'])
 ('D', ['D'])
```

### Groups without case sensitive

Specify `keyfunc` optional parameter to a function that computes a key.

```julia
julia> collect(groupby2_dict("AaAABbBcCD"; keyfunc=uppercase))
4-element Vector{Tuple{Any, Vector{Char}}}:
 ('A', ['A', 'a', 'A', 'A'])
 ('B', ['B', 'b', 'B'])
 ('C', ['c', 'C'])
 ('D', ['D'])
```

### Groups without case sensitive. Emits the grouped indices rather than the grouped elements.

```julia
julia> collect(groupby2_dict_indices("AaAABbBcCD", keyfunc=uppercase))
4-element Vector{Tuple{Any, Vector{Int64}}}:
 ('A', [1, 2, 3, 4])
 ('B', [5, 6, 7])
 ('C', [8, 9])
 ('D', [10])
```

## Example 2: Groups integer numbers
### Simple case

`groupby2` and `groupby_numbers` can be used to group integer numbers.

```julia
julia> collect(groupby2([10,20,20,30]))
3-element Vector{Vector{Int64}}:
 [10]
 [20, 20]
 [30]
```

```julia
julia> collect(groupby_numbers([10,20,20,30])); # => same result
```

### Emits keys

```julia
julia> collect(groupby2_dict([10,20,20,30]))
3-element Vector{Tuple{Any, Vector{Int64}}}:
 (10, [10])
 (20, [20, 20])
 (30, [30])
```

```julia
julia> collect(groupby_numbers_dict([10,20,20,30])); # => same result
```

### Groups by absolute values

```julia
julia> collect(groupby2_dict([10,-20,20,30]; keyfunc=abs))
3-element Vector{Tuple{Any, Vector{Int64}}}:
 (10, [10])
 (20, [-20, 20])
 (30, [30])
```

```julia
julia> collect(groupby_numbers_dict([10,-20,20,30]; keyfunc=abs)); # => same result
```

### Groups by absolute values. Emits the grouped indices rather than the grouped elements.

```julia
julia> collect(groupby2_dict_indices([10,-20,20,30]; keyfunc=abs))
3-element Vector{Tuple{Any, Vector{Int64}}}:
 (10, [1])
 (20, [2, 3])
 (30, [4])
```

```julia
julia> collect(groupby_numbers_dict_indices([10,-20,20,30]; keyfunc=abs)); # => same result
```

## Example 3: Groups floating point numbers

Use `groupby_numbersYYYZZZ` rather than `groupby2YYYZZZ` to group floating point numbers.

### Simple case. 

`groupby_numbersYYYZZZ` groups floating point numbers with `isapprox` function by default.

```julia
julia> collect(groupby_numbers([ 2e-10, 2e-9, 2e-8, 2e-7 ] .+ 1))
3-element Vector{Vector{Float64}}:
 [1.0000000002, 1.000000002]
 [1.00000002]
 [1.0000002]
```

### Adjusts tolerance with `atol` and `rtol` parameters.

Consult the manual of [`Base.isapprox`](https://docs.julialang.org/en/v1/base/math/#Base.isapprox) for its keyword parameters such as `atol` and `rtol`.

```julia
julia> collect(groupby_numbers([ 2e-8, 2e-7, 2e-6, 2e-5 ] .+ 1; atol=1e-6))
3-element Vector{Vector{Float64}}:
 [1.00000002, 1.0000002]
 [1.000002]
 [1.00002]
```

```julia
julia> collect(groupby_numbers([ 2e-6, 2e-5, 2e-4, 2e-3 ] .+ 1; rtol=1e-4))
3-element Vector{Vector{Float64}}:
 [1.000002, 1.00002]
 [1.0002]
 [1.002]
```

### Groups by their absolute values

```julia
julia> collect(groupby_numbers([ 1+2e-6, -1+2e-5, 1+2e-4, 1-2e-3 ]; 
        keyfunc=abs, rtol=1e-4))
3-element Vector{Vector{Float64}}:
 [1.000002, -0.99998]
 [1.0002]
 [0.998]
```

### Emits the grouped indices rather than the grouped elements.

```julia
julia> collect(groupby_numbers_indices([ 1+2e-6, -1+2e-5, 1+2e-4, 1-2e-3 ]; 
        keyfunc=abs, rtol=1e-4))
3-element Vector{Vector{Int64}}:
 [1, 2]
 [3]
 [4]
```

## Example 4: Groups noisy vectors

`groupby_numbersYYYZZZ` can be used to group an array of floating point numbers.

### Groups array of vectors

Rotation preserves norm.

```julia
julia> using LinearAlgebra
julia> # Rotation matrix
       t=15; r15 = [ cosd(t) -sind(t); sind(t) cosd(t)]
2×2 Matrix{Float64}:
 0.965926  -0.258819
 0.258819   0.965926

julia> using IterTools
julia> vs1 = collect( Iterators.take(
                iterated(v -> (1+rand()*1e-8)*r15*v, [1,0]), 5) )
5-element Vector{Vector}:
 [1, 0]
 [0.9659258323666292, 0.25881904673099826]
 [0.8660254177031013, 0.5000000080359436]
 [0.7071067969544697, 0.7071067969544694]
 [0.5000000112991584, 0.8660254233551546]

julia> # group by norm
       collect( groupby_numbers_indices(vs1; keyfunc=norm, atol=1e-6))
1-element Vector{Vector{Int64}}:
 [1, 2, 3, 4, 5]
```

### Groups array of tuple consisting of vector and its norm

Calculate the vectors and their norms to avoid recalculate the latters.

```julia
julia> using LinearAlgebra

julia> vs1=vec( [ begin 
            v= [i1,i2] *(1+(rand()-0.5)*1e-8);
            (v=v,n=norm(v))
        end for i1 in -2:2, i2 in -2:2] );

julia> # sort by norm
       vs2=sort(vs1; by=x->x.n);

julia> # group by norm
       collect(groupby_numbers_dict_indices(vs2; keyfunc=x->x.n))
6-element Vector{Tuple{Any, Vector{Int64}}}:
 (0.0, [1])
 (0.9999999976242439, [2, 3, 4, 5])
 (1.4142135561654923, [6, 7, 8, 9])
 (1.999999991951223, [10, 11, 12, 13])
 (2.2360679691661827, [14, 15, 16, 17, 18, 19, 20, 21])
 (2.828427114159456, [22, 23, 24, 25])
```


## See also

* [`IterTools.groupby`](https://juliacollections.github.io/IterTools.jl/stable/reference/#IterTools.groupby-Union{Tuple{I},%20Tuple{F},%20Tuple{F,%20I}}%20where%20{F%3C:Union{Function,%20Type},%20I})