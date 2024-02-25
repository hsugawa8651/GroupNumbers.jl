module GroupNumbers

import Base: iterate, eltype
import Base: IteratorSize, IteratorEltype
import Base: SizeUnknown
import Base: HasEltype

export
    groupby2_dict,
    groupby2_dict_indices,
    groupby_numbers_dict,
    groupby_numbers_dict_indices

macro ifsomething(ex)
    quote
        result = $(esc(ex))
        result === nothing && return nothing
        result
    end
end

# groupby2_dict

# 
# An iterator that yields a key-and-group pair from the iterator `xs`.
# 
struct Groupby2_Dict{I,F1<:Base.Callable,F2<:Base.Callable}
    keyfunc::F1
    compare::F2
    xs::I
end
eltype(::Type{<:Groupby2_Dict{I}}) where {I} = Tuple{Any,Vector{eltype(I)}}
IteratorSize(::Type{<:Groupby2_Dict}) = SizeUnknown()

"""
    groupby2_dict(xs; keyfunc=identity, compare=isequal)

An iterator that yields a key-and-group pair `(k,xg)` from the iterator `xs`,
where the key `k` is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `compare` function, then,
delivers the key `k` and the vector `xg` of the grouped elements .

# Examples
## Example 1: Group characters
```jldoctest
julia> collect(groupby2_dict("A"))
1-element Vector{Tuple{Any, Vector{Char}}}:
 ('A', ['A'])

julia> collect(groupby2_dict("AAAABBBCCD"))
4-element Vector{Tuple{Any, Vector{Char}}}:
 ('A', ['A', 'A', 'A', 'A'])
 ('B', ['B', 'B', 'B'])
 ('C', ['C', 'C'])
 ('D', ['D'])
```

## Example 2: Group integer numbers
```jldoctest
julia> collect(groupby2_dict([10,20,20,30]))
3-element Vector{Tuple{Any, Vector{Int64}}}:
 (10, [10])
 (20, [20, 20])
 (30, [30])
```

## Example 3: Group floating point numbers
```jldoctest
julia> collect(groupby2_dict([1+2e-10, -(1+2e-9), 1+2e-8, -(1+2e-7)], compare=isapprox, keyfunc=abs))
3-element Vector{Tuple{Any, Vector{Float64}}}:
 (1.0000000002, [1.0000000002, -1.000000002])
 (1.00000002, [1.00000002])
 (1.0000002, [-1.0000002])

```

## Example 4: Group noisy vectors with their norm
 ```jldoctest
julia> using LinearAlgebra

julia> begin
        vs1=[ begin 
               v=(i1+(rand()-0.5)*1e-10,i2+(rand()-0.5)*1e-10);
               (v=v,n=norm(v))
          end for i1 in -2:2, i2 in -2:2] |> vec
        vs2=sort(vs1; by=x->x.n)
        [ (k,length(g)) for (k,g) in groupby2_dict(vs2; keyfunc=x->x.n, compare=isapprox) ]
        end
6-element Vector{Tuple{Float64, Int64}}:
 (4.16311498666887e-11, 1)
 (0.999999999984808, 4)
 (1.4142135623388605, 4)
 (1.9999999999726468, 4)
 (2.236067977467306, 8)
 (2.828427124726703, 4)
```
"""
function groupby2_dict(xs::I; keyfunc::F1=identity, compare::F2=isequal) where {F1<:Base.Callable,F2<:Base.Callable,I}
    Groupby2_Dict{I,F1,F2}(keyfunc, compare, xs)
end

function iterate(it::Groupby2_Dict{I,F1,F2}, state=nothing) where {I,F1<:Base.Callable,F2<:Base.Callable}
    if state === nothing
        prev_val, xs_state = @ifsomething iterate(it.xs)
        prev_key = it.keyfunc(prev_val)
        keep_going = true
    else
        keep_going, prev_key, prev_val, xs_state = state
        keep_going || return nothing
    end
    present_key = prev_key
    values = Vector{eltype(I)}()
    push!(values, prev_val)

    while true
        xs_iter = iterate(it.xs, xs_state)

        if xs_iter === nothing
            keep_going = false
            break
        end

        val, xs_state = xs_iter
        key = it.keyfunc(val)

        if it.compare(key, prev_key)
            push!(values, val)
        else
            present_key, prev_key = prev_key, key
            prev_val = val
            break
        end
    end

    return ((present_key, values), (keep_going, prev_key, prev_val, xs_state))
end

# groupby2_dict_indices

# 
# An iterator that yields a key and indices pair from the iterator `xs`.
# 
struct Groupby2_Dict_Indices{I,F1<:Base.Callable,F2<:Base.Callable}
    keyfunc::F1
    compare::F2
    xs::I
end
eltype(::Type{<:Groupby2_Dict_Indices{I}}) where {I} = Tuple{Any,Vector{Int64}}
IteratorSize(::Type{<:Groupby2_Dict_Indices}) = SizeUnknown()

"""
    groupby2_dict_indices(xs; keyfunc=identity, compare=isequal)

An iterator that yields a key-and-group pair `(k,ig)` from the iterator `xs`,
where the key `k` is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `compare` function, then,
delivers the key `k` and the vector `ig` of the grouped indices.


# Examples
## Example 1: Group characters
```jldoctest
julia> collect(groupby2_dict_indices("A"))
1-element Vector{Tuple{Any, Vector{Int64}}}:
 ('A', [1])
```

```jldoctest
julia> collect(groupby2_dict_indices("AAAABBBCCD"))
4-element Vector{Tuple{Any, Vector{Int64}}}:
 ('A', [1, 2, 3, 4])
 ('B', [5, 6, 7])
 ('C', [8, 9])
 ('D', [10])
```

## Example 2: Group integer numbers
```jldoctest
julia> collect(groupby2_dict_indices([10,20,20,30]))
3-element Vector{Tuple{Any, Vector{Int64}}}:
 (10, [1])
 (20, [2, 3])
 (30, [4])
```

## Example 3: Group floating point numbers
```jldoctest
julia> collect(groupby2_dict_indices([1+2e-10, -(1+2e-9), 1+2e-8, -(1+2e-7)], compare=isapprox, keyfunc=abs))
3-element Vector{Tuple{Any, Vector{Int64}}}:
 (1.0000000002, [1, 2])
 (1.00000002, [3])
 (1.0000002, [4])
```

## Example 4: Group noisy vectors with their norm
 ```jldoctest
julia> using LinearAlgebra
julia> begin
        vs1=[ begin 
                v=(i1+(rand()-0.5)*1e-10,i2+(rand()-0.5)*1e-10);
                (v=v,n=norm(v))
        end for i1 in -2:2, i2 in -2:2] |> vec
        vs2=sort(vs1; by=x->x.n)
        collect(groupby2_dict_indices(vs2; keyfunc=x->x.n, compare=isapprox))
    end
6-element Vector{Tuple{Any, Vector{Int64}}}:
 (3.444788576260325e-11, [1])
 (0.9999999999517916, [2, 3, 4, 5])
 (1.4142135623328898, [6, 7, 8, 9])
 (1.9999999999690443, [10, 11, 12, 13])
 (2.236067977456823, [14, 15, 16, 17, 18, 19, 20, 21])
 (2.828427124691792, [22, 23, 24, 25])
```
"""
function groupby2_dict_indices(xs::I; keyfunc::F1=identity, compare::F2=isequal) where {F1<:Base.Callable,F2<:Base.Callable,I}
    Groupby2_Dict_Indices{I,F1,F2}(keyfunc, compare, xs)
end

function iterate(it::Groupby2_Dict_Indices{I,F1,F2}, state=nothing) where {I,F1<:Base.Callable,F2<:Base.Callable}
    if state === nothing
        prev_val, xs_state = @ifsomething iterate(it.xs)
        prev_key = it.keyfunc(prev_val)
        count = 1
        keep_going = true
    else
        keep_going, count, prev_key, prev_val, xs_state = state
        keep_going || return nothing
    end
    present_key = prev_key
    values = Vector{Int64}()
    push!(values, count)
    count += 1

    while true
        xs_iter = iterate(it.xs, xs_state)

        if xs_iter === nothing
            keep_going = false
            break
        end

        val, xs_state = xs_iter
        key = it.keyfunc(val)

        if it.compare(key, prev_key)
            push!(values, count)
            count += 1
        else
            present_key, prev_key = prev_key, key
            prev_val = val
            break
        end
    end

    return ((present_key, values), (keep_going, count, prev_key, prev_val, xs_state))
end


# groupby_numbers_dict

"""
    groupby_numbers_dict(xs; keyfunc=identity, kwargs)

An iterator that yields a key-and-group pair `(k,xg)` from the iterator `xs` of presumably numbers,
where the key `k` is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `isapprox` function with supplied `kwargs` optional parameters, 
then, delivers the key `k` and the vector `xg` of grouped elements.

# Examples
## Example 1: Group integer numbers
```jldoctest
julia> collect(groupby_numbers_dict([10,20,20,30]))
3-element Vector{Tuple{Any, Vector{Int64}}}:
 (10, [10])
 (20, [20, 20])
 (30, [30])
```

```jldoctest
julia> collect( groupby_numbers_dict([10,20,-20,30]; keyfunc=abs))
3-element Vector{Tuple{Any, Vector{Int64}}}:
 (10, [10])
 (20, [20, -20])
 (30, [30])
```

## Example 2: Group floating point numbers

```jldoctest
julia> collect(groupby_numbers_dict([ 2e-5, 2e-4, 2e-3, 2e-2 ] .+ 1; rtol=1e-3))
3-element Vector{Tuple{Any, Vector{Float64}}}:
 (1.00002, [1.00002, 1.0002])
 (1.002, [1.002])
 (1.02, [1.02])
```

```jldoctest
julia> collect(groupby_numbers_dict([ 1+2e-5, -(1+2e-4), 1+2e-3, -(1+2e-2) ]; keyfunc=abs, rtol=1e-3))
3-element Vector{Tuple{Any, Vector{Float64}}}:
 (1.00002, [1.00002, -1.0002])
 (1.002, [1.002])
 (1.02, [-1.02])
```

## Example 3: Group noisy vectors with their norm
 ```jldoctest
julia> using LinearAlgebra
julia> begin
        vs1=[ begin 
                v=(i1+(rand()-0.5)*1e-10,i2+(rand()-0.5)*1e-10);
                (v=v,n=norm(v))
          end for i1 in -2:2, i2 in -2:2] |> vec
        vs2=sort(vs1; by=x->x.n)
        [ (k,length(xg)) for (k,xg) in groupby_numbers_dict(vs2; keyfunc=x->x.n, rtol=1e-3) ]
      end
6-element Vector{Tuple{Float64, Int64}}:
 (3.2527338422665044e-11, 1)
 (0.999999999995845, 4)
 (1.4142135623542986, 4)
 (2.000000000002051, 4)
 (2.236067977452884, 8)
 (2.8284271246921855, 4)
```
"""
function groupby_numbers_dict(xs; keyfunc=identity, kwargs...)
    groupby2_dict(xs; keyfunc=keyfunc, compare=(x, y) -> isapprox(x, y; kwargs...))
end


# groupby_numbers_dict

"""
    groupby_numbers_dict(xs; keyfunc=identity, kwargs)

An iterator that yields a key-and-group pair `(k,ig)` from the iterator `xs` of presumably numbers,
where the key `k` is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `isapprox` function with supplied `kwargs` optional parameters, 
then, delivers the key `k` and the vector `ig` of the grouped indices.

# Examples
## Example 1: Group integer numbers
```jldoctest
julia> collect( groupby_numbers_dict([10,20,20,30]))
3-element Vector{Tuple{Any, Vector{Int64}}}:
 (10, [1])
 (20, [2, 3])
 (30, [4])
```

```jldoctest
julia> collect( groupby_numbers_dict([10,20,-20,30]; keyfunc=abs))
3-element Vector{Tuple{Any, Vector{Int64}}}:
 (10, [1])
 (20, [2, 3])
 (30, [4])
```

## Example 2: Group floating point numbers

```jldoctest
julia> collect(groupby_numbers_dict([ 2e-5, 2e-4, 2e-3, 2e-2 ] .+ 1; rtol=1e-3))
3-element Vector{Tuple{Any, Vector{Int64}}}:
 (1.00002, [1, 2])
 (1.002, [3])
 (1.02, [4])
```

```jldoctest
julia> collect( groupby_numbers_dict([ 1+2e-5, -(1+2e-4), 1+2e-3, -(1+2e-2) ]; keyfunc=abs, rtol=1e-3))
3-element Vector{Tuple{Any, Vector{Int64}}}:
 (1.00002, [1, 2])
 (1.002, [3])
 (1.02, [4])
```

## Example 3: Group noisy vectors with their norm
 ```jldoctest
julia> using LinearAlgebra
julia> begin
        vs1=[ begin 
                v=(i1+(rand()-0.5)*1e-10,i2+(rand()-0.5)*1e-10);
                (v=v,n=norm(v))
        end for i1 in -2:2, i2 in -2:2] |> vec
        vs2=sort(vs1; by=x->x.n)
        collect(groupby_numbers_dict(vs2; keyfunc=x->x.n, rtol=1e-3) )
    end
6-element Vector{Tuple{Any, Vector{Int64}}}:
 (5.1602090609765565e-11, [1])
 (0.999999999950049, [2, 3, 4, 5])
 (1.41421356233767, [6, 7, 8, 9])
 (1.9999999999749463, [10, 11, 12, 13])
 (2.2360679774420964, [14, 15, 16, 17, 18, 19, 20, 21])
 (2.828427124718571, [22, 23, 24, 25])
```
"""
function groupby_numbers_dict_indices(xs; keyfunc=identity, kwargs...)
    groupby2_dict_indices(xs; keyfunc=keyfunc, compare=(x, y) -> isapprox(x, y; kwargs...))
end


export
    groupby2,
    groupby2_indices,
    groupby_numbers,
    groupby_numbers_indices

# groupby2

# 
# An iterator that yields a key-and-group pair from the iterator `xs`.
# 
struct Groupby2{I,F1<:Base.Callable,F2<:Base.Callable}
    keyfunc::F1
    compare::F2
    xs::I
end
eltype(::Type{<:Groupby2{I}}) where {I} = Vector{eltype(I)}
IteratorSize(::Type{<:Groupby2}) = SizeUnknown()

"""
    groupby2(xs; keyfunc=identity, compare=isequal)

An iterator that yields a group of elements `xg` from the iterator `xs`,
where the key is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `compare` function, then,
delivers the vector `xg` of the grouped elements.

# Examples
## Example 1: Group characters
```jldoctest
julia> collect(groupby2("A"))
1-element Vector{Vector{Char}}:
 ['A']

julia> collect(groupby2("AAAABBBCCD"))
4-element Vector{Vector{Char}}:
 ['A', 'A', 'A', 'A']
 ['B', 'B', 'B']
 ['C', 'C']
 ['D']
```

## Example 2: Group integer numbers
```jldoctest
julia> collect(groupby2([10,20,20,30]))
3-element Vector{Vector{Int64}}:
 [10]
 [20, 20]
 [30]
```

## Example 3: Group floating point numbers
```jldoctest
julia> collect(groupby2([1+2e-10, -(1+2e-9), 1+2e-8, -(1+2e-7)], compare=isapprox, keyfunc=abs))
3-element Vector{Vector{Float64}}:
 [1.0000000002, -1.000000002]
 [1.00000002]
 [-1.0000002]
```

## Example 4: Group noisy vectors with their norm
```jldoctest
julia> using LinearAlgebra

julia> vs1=[ begin 
            v=(i1+(rand()-0.5)*1e-10,i2+(rand()-0.5)*1e-10);
            (v=v,n=norm(v))
          end for i1 in -2:2, i2 in -2:2] |> vec; 

julia> vs2=sort(vs1; by=x->x.n); 

julia> [ length(g) for g in groupby2(vs2; keyfunc=x->x.n, compare=isapprox) ]
6-element Vector{Int64}:
 1
 4
 4
 4
 8
 4
```
"""
function groupby2(xs::I; keyfunc::F1=identity, compare::F2=isequal) where {F1<:Base.Callable,F2<:Base.Callable,I}
    Groupby2{I,F1,F2}(keyfunc, compare, xs)
end

function iterate(it::Groupby2{I,F1,F2}, state=nothing) where {I,F1<:Base.Callable,F2<:Base.Callable}
    if state === nothing
        prev_val, xs_state = @ifsomething iterate(it.xs)
        prev_key = it.keyfunc(prev_val)
        keep_going = true
    else
        keep_going, prev_key, prev_val, xs_state = state
        keep_going || return nothing
    end
    present_key = prev_key
    values = Vector{eltype(I)}()
    push!(values, prev_val)

    while true
        xs_iter = iterate(it.xs, xs_state)

        if xs_iter === nothing
            keep_going = false
            break
        end

        val, xs_state = xs_iter
        key = it.keyfunc(val)

        if it.compare(key, prev_key)
            push!(values, val)
        else
            present_key, prev_key = prev_key, key
            prev_val = val
            break
        end
    end

    return (values, (keep_going, prev_key, prev_val, xs_state))
end

# groupby2_indices

# 
# An iterator that yields a key and indices pair from the iterator `xs`.
# 
struct Groupby2_Indices{I,F1<:Base.Callable,F2<:Base.Callable}
    keyfunc::F1
    compare::F2
    xs::I
end
eltype(::Type{<:Groupby2_Indices{I}}) where {I} = Vector{Int64}
IteratorSize(::Type{<:Groupby2_Indices}) = SizeUnknown()

"""
    groupby2_indices(xs; keyfunc=identity, compare=isequal)

An iterator that yields a group of indices `ig` from the iterator `xs`,
where the key is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `compare` function, then,
delivers the vector `ig` of the grouped indices.


# Examples
## Example 1: Group characters
```jldoctest
julia> collect(groupby2_indices("A"))
1-element Vector{Vector{Int64}}:
 [1]
```

```jldoctest
julia> collect(groupby2_indices("AAAABBBCCD"))
4-element Vector{Vector{Int64}}:
 [1, 2, 3, 4]
 [5, 6, 7]
 [8, 9]
 [10]
```

## Example 2: Group integer numbers
```jldoctest
julia> collect(groupby2_indices([10,20,20,30]))
3-element Vector{Vector{Int64}}:
 [1]
 [2, 3]
 [4]
```

## Example 3: Group floating point numbers
```jldoctest
julia> collect(groupby2_indices([1+2e-10, -(1+2e-9), 1+2e-8, -(1+2e-7)], compare=isapprox, keyfunc=abs))
3-element Vector{Vector{Int64}}:
 [1, 2]
 [3]
 [4]
```

## Example 4: Group noisy vectors with their norm
 ```jldoctest
julia> using LinearAlgebra
julia> vs1=[ begin 
            v=(i1+(rand()-0.5)*1e-10,i2+(rand()-0.5)*1e-10);
            (v=v,n=norm(v))
        end for i1 in -2:2, i2 in -2:2] |> vec;
julia> vs2=sort(vs1; by=x->x.n);

julia> collect(groupby2_indices(vs2; keyfunc=x->x.n, compare=isapprox))
6-element Vector{Vector{Int64}}:
 [1]
 [2, 3, 4, 5]
 [6, 7, 8, 9]
 [10, 11, 12, 13]
 [14, 15, 16, 17, 18, 19, 20, 21]
 [22, 23, 24, 25]
```
"""
function groupby2_indices(xs::I; keyfunc::F1=identity, compare::F2=isequal) where {F1<:Base.Callable,F2<:Base.Callable,I}
    Groupby2_Indices{I,F1,F2}(keyfunc, compare, xs)
end

function iterate(it::Groupby2_Indices{I,F1,F2}, state=nothing) where {I,F1<:Base.Callable,F2<:Base.Callable}
    if state === nothing
        prev_val, xs_state = @ifsomething iterate(it.xs)
        prev_key = it.keyfunc(prev_val)
        count = 1
        keep_going = true
    else
        keep_going, count, prev_key, prev_val, xs_state = state
        keep_going || return nothing
    end
    present_key = prev_key
    values = Vector{Int64}()
    push!(values, count)
    count += 1

    while true
        xs_iter = iterate(it.xs, xs_state)

        if xs_iter === nothing
            keep_going = false
            break
        end

        val, xs_state = xs_iter
        key = it.keyfunc(val)

        if it.compare(key, prev_key)
            push!(values, count)
            count += 1
        else
            present_key, prev_key = prev_key, key
            prev_val = val
            break
        end
    end

    return (values, (keep_going, count, prev_key, prev_val, xs_state))
end


# groupby_numbers

"""
    groupby_numbers(xs; keyfunc=identity, kwargs)

An iterator that yields a group of numbers `xg` from the iterator `xs` of presumably numbers,
where the key is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `isapprox` function with supplied `kwargs` optional parameters, 
then, delivers the vector `xg` of the grouped numbers.

# Examples
## Example 1: Group integer numbers
```jldoctest
julia> collect(groupby_numbers([10,20,20,30]))
3-element Vector{Vector{Int64}}:
 [10]
 [20, 20]
 [30]
```

```jldoctest
julia> collect( groupby_numbers([10,20,-20,30]; keyfunc=abs))
3-element Vector{Vector{Int64}}:
 [10]
 [20, -20]
 [30]
```

## Example 2: Group floating point numbers

```jldoctest
julia> collect(groupby_numbers([ 2e-5, 2e-4, 2e-3, 2e-2 ] .+ 1; rtol=1e-3))
3-element Vector{Vector{Float64}}:
 [1.00002, 1.0002]
 [1.002]
 [1.02]
```

```jldoctest
julia> collect(groupby_numbers([ 1+2e-5, -(1+2e-4), 1+2e-3, -(1+2e-2) ]; keyfunc=abs, rtol=1e-3))
3-element Vector{Vector{Float64}}:
 [1.00002, -1.0002]
 [1.002]
 [-1.02]
```

## Example 3: Group noisy vectors with their norm
 ```jldoctest
 julia> using LinearAlgebra

julia> vs1=[ begin 
            v=(i1+(rand()-0.5)*1e-10,i2+(rand()-0.5)*1e-10);
            (v=v,n=norm(v))
        end for i1 in -2:2, i2 in -2:2] |> vec;
julia> vs2=sort(vs1; by=x->x.n);
julia> map(length, groupby_numbers(vs2; keyfunc=x->x.n, rtol=1e-3))
6-element Vector{Int64}:
 1
 4
 4
 4
 8
 4
```
"""
function groupby_numbers(xs; keyfunc=identity, kwargs...)
    groupby2(xs; keyfunc=keyfunc, compare=(x, y) -> isapprox(x, y; kwargs...))
end


# groupby_numbers_indices

"""
    groupby_numbers_indices(xs; keyfunc=identity, kwargs)

An iterator that yields a group of indices `ig` from the iterator `xs` of presumably numbers,
where the key is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `isapprox` function with supplied `kwargs` optional parameters, 
then, delivers the vector `ig` of the grouped indices.

# Examples
## Example 1: Group integer numbers
```jldoctest
julia> collect( groupby_numbers_indices([10,20,20,30]))
3-element Vector{Vector{Int64}}:
 [1]
 [2, 3]
 [4]
```

```jldoctest
julia> collect( groupby_numbers_indices([10,20,-20,30]; keyfunc=abs))
3-element Vector{Vector{Int64}}:
 [1]
 [2, 3]
 [4]
```

## Example 2: Group floating point numbers

```jldoctest
julia> collect(groupby_numbers_indices([ 2e-5, 2e-4, 2e-3, 2e-2 ] .+ 1; rtol=1e-3))
3-element Vector{Vector{Int64}}:
 [1, 2]
 [3]
 [4]
```

```jldoctest
julia> collect( groupby_numbers_indices([ 1+2e-5, -(1+2e-4), 1+2e-3, -(1+2e-2) ]; keyfunc=abs, rtol=1e-3))
3-element Vector{Vector{Int64}}:
 [1, 2]
 [3]
 [4]
```

## Example 3: Group noisy vectors with their norm
 ```jldoctest
 julia> using LinearAlgebra

julia> vs1=[ begin 
            v=(i1+(rand()-0.5)*1e-10,i2+(rand()-0.5)*1e-10);
            (v=v,n=norm(v))
        end for i1 in -2:2, i2 in -2:2] |> vec;
julia> vs2=sort(vs1; by=x->x.n);
julia> collect(groupby_numbers_indices(vs2; keyfunc=x->x.n, rtol=1e-3) )
6-element Vector{Vector{Int64}}:
 [1]
 [2, 3, 4, 5]
 [6, 7, 8, 9]
 [10, 11, 12, 13]
 [14, 15, 16, 17, 18, 19, 20, 21]
 [22, 23, 24, 25]
```
"""
function groupby_numbers_indices(xs; keyfunc=identity, kwargs...)
    groupby2_indices(xs; keyfunc=keyfunc, compare=(x, y) -> isapprox(x, y; kwargs...))
end


end # module GroupNumbers

