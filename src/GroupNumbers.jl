module GroupNumbers

import Base: iterate, eltype
import Base: IteratorSize, IteratorEltype
import Base: SizeUnknown
import Base: HasEltype

export groupby2_dict,
    groupby2_dict_indices, groupby_numbers_dict, groupby_numbers_dict_indices

macro ifsomething(ex)
    quote
        result = $(esc(ex))
        result === nothing && return nothing
        result
    end
end

using FunctionWrappers
import FunctionWrappers: FunctionWrapper

struct EmitFunction{V,E}
    fun::FunctionWrapper{V,Tuple{E}}
end

evaluate_emit(emit::EmitFunction{V,E}, arg) where {V,E} = emit.fun(arg)

function first_return_type(f, etype)
    vs = Base.return_types(f, Tuple{etype})
    (length(vs) == 1) || throw(MethodError(f, "is expected to be type-stable."))
    first(vs)
end


# groupby2_dict
# An iterator that yields a key-and-group pair from the iterator `xs`.
struct Groupby2Dict{I,F1<:Base.Callable,F2<:Base.Callable}
    keyfunc::F1
    compare::F2
    xs::I
end
eltype(::Type{<:Groupby2Dict{I}}) where {I} = Tuple{Any,Vector{eltype(I)}}
IteratorSize(::Type{<:Groupby2Dict}) = SizeUnknown()

"""
    groupby2_dict(xs; keyfunc=identity, compare=isequal, emit=identity)

An iterator that yields a key-and-group pair `(k,xg)` from the iterator `xs`,
where the key `k` is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `compare` function, then,
emits the key `k` and the vector `xg` of the grouped elements.

See [documentation](https://hsugawa8651.github.io/GroupNumbers.jl/dev/)
"""
function groupby2_dict(
    xs::I;
    keyfunc::F1 = identity,
    compare::F2 = isequal,
    emit = identity,
) where {F1<:Base.Callable,F2<:Base.Callable,I}
    if emit == identity
        groupby2_dict_noemit(xs; keyfunc, compare)
    else
        groupby2_dict_emit(xs; keyfunc, compare, emit)
    end
end


function groupby2_dict_noemit(
    xs::I;
    keyfunc::F1 = identity,
    compare::F2 = isequal,
) where {F1<:Base.Callable,F2<:Base.Callable,I}
    Groupby2Dict{I,F1,F2}(keyfunc, compare, xs)
end

function iterate(
    it::Groupby2Dict{I,F1,F2},
    state = nothing,
) where {I,F1<:Base.Callable,F2<:Base.Callable}
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

struct Groupby2DictEmit{V,E,I,F1<:Base.Callable,F2<:Base.Callable}
    keyfunc::F1
    compare::F2
    emitWrap::EmitFunction{V,E}
    xs::I
end
eltype(::Type{<:Groupby2DictEmit{V}}) where {V} = Tuple{Any,Vector{V}}
IteratorSize(::Type{<:Groupby2DictEmit}) = SizeUnknown()

function groupby2_dict_emit(
    xs::I;
    keyfunc::F1 = identity,
    compare::F2 = isequal,
    emit = identity,
) where {F1<:Base.Callable,F2<:Base.Callable,I}
    E = eltype(I)
    V = first_return_type(emit, E)
    emitWrap = EmitFunction{V,E}(emit)
    Groupby2DictEmit{V,E,I,F1,F2}(keyfunc, compare, emitWrap, xs)
end

function iterate(
    it::Groupby2DictEmit{V,E,I,F1,F2},
    state = nothing,
) where {V,E,I,F1<:Base.Callable,F2<:Base.Callable}
    if state === nothing
        prev_val, xs_state = @ifsomething iterate(it.xs)
        prev_key = it.keyfunc(prev_val)
        keep_going = true
    else
        keep_going, prev_key, prev_val, xs_state = state
        keep_going || return nothing
    end
    present_key = prev_key
    values = Vector{V}()
    push!(values, evaluate_emit(it.emitWrap, prev_val))

    while true
        xs_iter = iterate(it.xs, xs_state)

        if xs_iter === nothing
            keep_going = false
            break
        end

        val, xs_state = xs_iter
        key = it.keyfunc(val)

        if it.compare(key, prev_key)
            push!(values, evaluate_emit(it.emitWrap, val))
        else
            present_key, prev_key = prev_key, key
            prev_val = val
            break
        end
    end

    return ((present_key, values), (keep_going, prev_key, prev_val, xs_state))
end

# groupby2_dict_indices
# An iterator that yields a key and indices pair from the iterator `xs`.
struct Groupby2DictIndices{I,F1<:Base.Callable,F2<:Base.Callable}
    keyfunc::F1
    compare::F2
    xs::I
end
eltype(::Type{<:Groupby2DictIndices{I}}) where {I} = Tuple{Any,Vector{Int64}}
IteratorSize(::Type{<:Groupby2DictIndices}) = SizeUnknown()

"""
    groupby2_dict_indices(xs; keyfunc=identity, compare=isequal)

An iterator that yields a key-and-group pair `(k,ig)` from the iterator `xs`,
where the key `k` is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `compare` function, then,
emits the key `k` and the vector `ig` of the grouped indices.

See [documentation](https://hsugawa8651.github.io/GroupNumbers.jl/dev/)
"""
function groupby2_dict_indices(
    xs::I;
    keyfunc::F1 = identity,
    compare::F2 = isequal,
) where {F1<:Base.Callable,F2<:Base.Callable,I}
    Groupby2DictIndices{I,F1,F2}(keyfunc, compare, xs)
end

function iterate(
    it::Groupby2DictIndices{I,F1,F2},
    state = nothing,
) where {I,F1<:Base.Callable,F2<:Base.Callable}
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
    groupby_numbers_dict(xs; keyfunc=identity, emit = identity, kwargs)

An iterator that yields a key-and-group pair `(k,xg)` from the iterator `xs` of presumably numbers,
where the key `k` is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `isapprox` function with supplied `kwargs` optional parameters, 
then, emits the key `k` and the vector `xg` of grouped elements.

See [documentation](https://hsugawa8651.github.io/GroupNumbers.jl/dev/)
"""
function groupby_numbers_dict(xs; keyfunc = identity, emit = identity, kwargs...)
    groupby2_dict(
        xs;
        keyfunc = keyfunc,
        emit = emit,
        compare = (x, y) -> isapprox(x, y; kwargs...),
    )
end


# groupby_numbers_dict

"""
    groupby_numbers_dict(xs; keyfunc=identity, kwargs)

An iterator that yields a key-and-group pair `(k,ig)` from the iterator `xs` of presumably numbers,
where the key `k` is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `isapprox` function with supplied `kwargs` optional parameters, 
then, emits the key `k` and the vector `ig` of the grouped indices.

See [documentation](https://hsugawa8651.github.io/GroupNumbers.jl/dev/)
"""
function groupby_numbers_dict_indices(xs; keyfunc = identity, kwargs...)
    groupby2_dict_indices(
        xs;
        keyfunc = keyfunc,
        compare = (x, y) -> isapprox(x, y; kwargs...),
    )
end

export groupby2, groupby2_indices, groupby_numbers, groupby_numbers_indices

# groupby2
# An iterator that yields a key-and-group pair from the iterator `xs`.
struct Groupby2{I,F1<:Base.Callable,F2<:Base.Callable}
    keyfunc::F1
    compare::F2
    xs::I
end
eltype(::Type{<:Groupby2{I}}) where {I} = Vector{eltype(I)}
IteratorSize(::Type{<:Groupby2}) = SizeUnknown()

"""
    groupby2(xs; keyfunc=identity, compare=isequal, emit=identity)

An iterator that yields a group of elements `xg` from the iterator `xs`,
where the key is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `compare` function, then,
emits the vector `xg` of the grouped elements.

See [documentation](https://hsugawa8651.github.io/GroupNumbers.jl/dev/)
"""
function groupby2(
    xs::I;
    keyfunc::F1 = identity,
    compare::F2 = isequal,
    emit = identity,
) where {F1<:Base.Callable,F2<:Base.Callable,I}
    if emit == identity
        groupby2_noemit(xs; keyfunc, compare)
    else
        groupby2_emit(xs; keyfunc, compare, emit)
    end
end

function groupby2_noemit(
    xs::I;
    keyfunc::F1 = identity,
    compare::F2 = isequal,
) where {F1<:Base.Callable,F2<:Base.Callable,I}
    Groupby2{I,F1,F2}(keyfunc, compare, xs)
end

function iterate(
    it::Groupby2{I,F1,F2},
    state = nothing,
) where {I,F1<:Base.Callable,F2<:Base.Callable}
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


struct Groupby2Emit{V,E,I,F1<:Base.Callable,F2<:Base.Callable}
    keyfunc::F1
    compare::F2
    emitWrap::EmitFunction{V,E}
    xs::I
end
eltype(::Type{<:Groupby2Emit{V}}) where {V} = Vector{V}
IteratorSize(::Type{<:Groupby2Emit}) = SizeUnknown()

function groupby2_emit(
    xs::I;
    keyfunc::F1 = identity,
    compare::F2 = isequal,
    emit = identity,
) where {F1<:Base.Callable,F2<:Base.Callable,I}
    E = eltype(I)
    V = first_return_type(emit, E)
    emitWrap = EmitFunction{V,E}(emit)
    Groupby2Emit{V,E,I,F1,F2}(keyfunc, compare, emitWrap, xs)
end

function iterate(
    it::Groupby2Emit{V,E,I,F1,F2},
    state = nothing,
) where {V,E,I,F1<:Base.Callable,F2<:Base.Callable}
    if state === nothing
        prev_val, xs_state = @ifsomething iterate(it.xs)
        prev_key = it.keyfunc(prev_val)
        keep_going = true
    else
        keep_going, prev_key, prev_val, xs_state = state
        keep_going || return nothing
    end
    present_key = prev_key
    values = Vector{V}()
    push!(values, evaluate_emit(it.emitWrap, prev_val))

    while true
        xs_iter = iterate(it.xs, xs_state)

        if xs_iter === nothing
            keep_going = false
            break
        end

        val, xs_state = xs_iter
        key = it.keyfunc(val)

        if it.compare(key, prev_key)
            push!(values, evaluate_emit(it.emitWrap, val))
        else
            present_key, prev_key = prev_key, key
            prev_val = val
            break
        end
    end

    return (values, (keep_going, prev_key, prev_val, xs_state))
end

# groupby2_indices
# An iterator that yields a key and indices pair from the iterator `xs`.
struct Groupby2Indices{I,F1<:Base.Callable,F2<:Base.Callable}
    keyfunc::F1
    compare::F2
    xs::I
end
eltype(::Type{<:Groupby2Indices{I}}) where {I} = Vector{Int64}
IteratorSize(::Type{<:Groupby2Indices}) = SizeUnknown()

"""
    groupby2_indices(xs; keyfunc=identity, compare=isequal)

An iterator that yields a group of indices `ig` from the iterator `xs`,
where the key is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `compare` function, then,
emits the vector `ig` of the grouped indices.

See [documentation](https://hsugawa8651.github.io/GroupNumbers.jl/dev/)
"""
function groupby2_indices(
    xs::I;
    keyfunc::F1 = identity,
    compare::F2 = isequal,
) where {F1<:Base.Callable,F2<:Base.Callable,I}
    Groupby2Indices{I,F1,F2}(keyfunc, compare, xs)
end

function iterate(
    it::Groupby2Indices{I,F1,F2},
    state = nothing,
) where {I,F1<:Base.Callable,F2<:Base.Callable}
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
    groupby_numbers(xs; keyfunc=identity, emit=identity, kwargs)

An iterator that yields a group of numbers `xg` from the iterator `xs` of presumably numbers,
where the key is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `isapprox` function with supplied `kwargs` optional parameters, 
then, emit the vector `xg` of the grouped numbers.

See [documentation](https://hsugawa8651.github.io/GroupNumbers.jl/dev/)
"""
function groupby_numbers(xs; keyfunc = identity, emit = identity, kwargs...)
    groupby2(
        xs;
        keyfunc = keyfunc,
        emit = emit,
        compare = (x, y) -> isapprox(x, y; kwargs...),
    )
end


# groupby_numbers_indices

"""
    groupby_numbers_indices(xs; keyfunc=identity, kwargs)

An iterator that yields a group of indices `ig` from the iterator `xs` of presumably numbers,
where the key is computed by applying `keyfunc` to each element of `xs`.
Compare adjacent keys by `isapprox` function with supplied `kwargs` optional parameters, 
then, emits the vector `ig` of the grouped indices.

See [documentation](https://hsugawa8651.github.io/GroupNumbers.jl/dev/)
"""
function groupby_numbers_indices(xs; keyfunc = identity, kwargs...)
    groupby2_indices(xs; keyfunc = keyfunc, compare = (x, y) -> isapprox(x, y; kwargs...))
end


end # module GroupNumbers

