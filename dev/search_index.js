var documenterSearchIndex = {"docs":
[{"location":"reference/#API-Reference","page":"API Reference","title":"API Reference","text":"","category":"section"},{"location":"reference/#Index","page":"API Reference","title":"Index","text":"","category":"section"},{"location":"reference/#Iterators-emitting-only-the-grouped-elements-or-indices","page":"API Reference","title":"Iterators emitting only the grouped elements or indices","text":"","category":"section"},{"location":"reference/","page":"API Reference","title":"API Reference","text":"groupby2(::I;::Base.Callable,::Base.Callable) where {I}\ngroupby2_indices(::I;::Base.Callable,::Base.Callable) where {I}\ngroupby_numbers(::I;::Base.Callable,::Base.Callable) where {I}\ngroupby_numbers_indices(::I;::Base.Callable,::Base.Callable) where {I}","category":"page"},{"location":"reference/#GroupNumbers.groupby2-Tuple{I} where I","page":"API Reference","title":"GroupNumbers.groupby2","text":"groupby2(xs; keyfunc=identity, compare=isequal)\n\nAn iterator that yields a group of elements xg from the iterator xs, where the key is computed by applying keyfunc to each element of xs. Compare adjacent keys by compare function, then, emits the vector xg of the grouped elements.\n\nSee documentation\n\n\n\n\n\n","category":"method"},{"location":"reference/#GroupNumbers.groupby2_indices-Tuple{I} where I","page":"API Reference","title":"GroupNumbers.groupby2_indices","text":"groupby2_indices(xs; keyfunc=identity, compare=isequal)\n\nAn iterator that yields a group of indices ig from the iterator xs, where the key is computed by applying keyfunc to each element of xs. Compare adjacent keys by compare function, then, emits the vector ig of the grouped indices.\n\nSee documentation\n\n\n\n\n\n","category":"method"},{"location":"reference/#GroupNumbers.groupby_numbers-Tuple{I} where I","page":"API Reference","title":"GroupNumbers.groupby_numbers","text":"groupby_numbers(xs; keyfunc=identity, kwargs)\n\nAn iterator that yields a group of numbers xg from the iterator xs of presumably numbers, where the key is computed by applying keyfunc to each element of xs. Compare adjacent keys by isapprox function with supplied kwargs optional parameters,  then, emit the vector xg of the grouped numbers.\n\nSee documentation\n\n\n\n\n\n","category":"method"},{"location":"reference/#GroupNumbers.groupby_numbers_indices-Tuple{I} where I","page":"API Reference","title":"GroupNumbers.groupby_numbers_indices","text":"groupby_numbers_indices(xs; keyfunc=identity, kwargs)\n\nAn iterator that yields a group of indices ig from the iterator xs of presumably numbers, where the key is computed by applying keyfunc to each element of xs. Compare adjacent keys by isapprox function with supplied kwargs optional parameters,  then, emits the vector ig of the grouped indices.\n\nSee documentation\n\n\n\n\n\n","category":"method"},{"location":"reference/#Iterators-emitting-keys-and-grouped-elements-or-indices","page":"API Reference","title":"Iterators emitting keys and grouped elements or indices","text":"","category":"section"},{"location":"reference/","page":"API Reference","title":"API Reference","text":"groupby2_dict(::I;::Base.Callable,::Base.Callable) where {I}\ngroupby2_dict_indices(::I;::Base.Callable,::Base.Callable) where {I}\ngroupby_numbers_dict(::I;::Base.Callable,::Base.Callable) where {I}\ngroupby_numbers_dict_indices(::I;::Base.Callable,::Base.Callable) where {I}","category":"page"},{"location":"reference/#GroupNumbers.groupby2_dict-Tuple{I} where I","page":"API Reference","title":"GroupNumbers.groupby2_dict","text":"groupby2_dict(xs; keyfunc=identity, compare=isequal)\n\nAn iterator that yields a key-and-group pair (k,xg) from the iterator xs, where the key k is computed by applying keyfunc to each element of xs. Compare adjacent keys by compare function, then, emits the key k and the vector xg of the grouped elements .\n\nSee documentation\n\n\n\n\n\n","category":"method"},{"location":"reference/#GroupNumbers.groupby2_dict_indices-Tuple{I} where I","page":"API Reference","title":"GroupNumbers.groupby2_dict_indices","text":"groupby2_dict_indices(xs; keyfunc=identity, compare=isequal)\n\nAn iterator that yields a key-and-group pair (k,ig) from the iterator xs, where the key k is computed by applying keyfunc to each element of xs. Compare adjacent keys by compare function, then, emits the key k and the vector ig of the grouped indices.\n\nSee documentation\n\n\n\n\n\n","category":"method"},{"location":"reference/#GroupNumbers.groupby_numbers_dict-Tuple{I} where I","page":"API Reference","title":"GroupNumbers.groupby_numbers_dict","text":"groupby_numbers_dict(xs; keyfunc=identity, kwargs)\n\nAn iterator that yields a key-and-group pair (k,xg) from the iterator xs of presumably numbers, where the key k is computed by applying keyfunc to each element of xs. Compare adjacent keys by isapprox function with supplied kwargs optional parameters,  then, emits the key k and the vector xg of grouped elements.\n\nSee documentation\n\n\n\n\n\n","category":"method"},{"location":"reference/#GroupNumbers.groupby_numbers_dict_indices-Tuple{I} where I","page":"API Reference","title":"GroupNumbers.groupby_numbers_dict_indices","text":"groupby_numbers_dict(xs; keyfunc=identity, kwargs)\n\nAn iterator that yields a key-and-group pair (k,ig) from the iterator xs of presumably numbers, where the key k is computed by applying keyfunc to each element of xs. Compare adjacent keys by isapprox function with supplied kwargs optional parameters,  then, emits the key k and the vector ig of the grouped indices.\n\nSee documentation\n\n\n\n\n\n","category":"method"},{"location":"#GroupNumbers","page":"Home","title":"GroupNumbers","text":"","category":"section"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Install this package with Pkg.add(\"GroupNumbers\")","category":"page"},{"location":"#Description","page":"Home","title":"Description","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"A family of iterators for grouping adjecent elements of the given iterator xs.","category":"page"},{"location":"","page":"Home","title":"Home","text":"compare function emits the grouped elements emits the grouped indices \nisequal groupby2 groupby2_indices \n groupby2_dict groupby2_dict_indices also emits key\nisapprox groupby_numbers groupby_numbers_indices \n groupby_numbers_dict groupby_numbers_dict_indices also emits key","category":"page"},{"location":"","page":"Home","title":"Home","text":"groupby2YYYZZZ(xs; keyfunc=identity, compare=isequal)\ngroupby_numbersYYYZZZ(xs; keyfunc=identity, compare=isapprox, kwargs)","category":"page"},{"location":"","page":"Home","title":"Home","text":"Here, \"YYY\" = \"\" or \"_dict\", and \"ZZZ\" = \"\" or \"_indices\".","category":"page"},{"location":"","page":"Home","title":"Home","text":"Apply keyfunc function to each element of xs to compute the key for comparison. For default, keyfunc is identity, so the key is each element itself.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Compare the adjacent keys by compare function. While groupby2YYYZZZ family  adopt isequal as the default compare function,  groupby_numbersYYYZZZ family adopt isapprox  with accompanying kwargs  being supplied to the keyword parameters of  the default isapprox function, allowing the control of the tolerance.","category":"page"},{"location":"","page":"Home","title":"Home","text":"While unbranded iterators (\"ZZZ\" = \"\") emit the grouped elements, the _indices alternatives (\"ZZZ\" = \"_indices\" ) emit the indices of the grouped elements.","category":"page"},{"location":"","page":"Home","title":"Home","text":"While unbranded iterators (\"YYY\" = \"\") emit only the grouped elements or their indices, the _dict alternatives (\"YYY\" = \"_dict\" ) emit also the first keys.","category":"page"},{"location":"#Examples","page":"Home","title":"Examples","text":"","category":"section"},{"location":"#Example-1:-Groups-characters-in-a-string","page":"Home","title":"Example 1: Groups characters in a string","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"groupby2(xs) is equivalent to IterTools.groupby(identity, xs).","category":"page"},{"location":"#Simple-case","page":"Home","title":"Simple case","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby2(\"AAAABBBCCD\"))\n4-element Vector{Vector{Char}}:\n ['A', 'A', 'A', 'A']\n ['B', 'B', 'B']\n ['C', 'C']\n ['D']","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using IterTools\njulia> collect(IterTools.groupby(identity, \"AAAABBBCCD\")); # => same result","category":"page"},{"location":"#Emits-keys","page":"Home","title":"Emits keys","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Use groupby2_dict(xs) if you need the keys.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby2_dict(\"AAAABBBCCD\"))\n4-element Vector{Tuple{Any, Vector{Char}}}:\n ('A', ['A', 'A', 'A', 'A'])\n ('B', ['B', 'B', 'B'])\n ('C', ['C', 'C'])\n ('D', ['D'])","category":"page"},{"location":"#Groups-without-case-sensitive","page":"Home","title":"Groups without case sensitive","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Specify keyfunc optional parameter to a function that computes a key.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby2_dict(\"AaAABbBcCD\"; keyfunc=uppercase))\n4-element Vector{Tuple{Any, Vector{Char}}}:\n ('A', ['A', 'a', 'A', 'A'])\n ('B', ['B', 'b', 'B'])\n ('C', ['c', 'C'])\n ('D', ['D'])","category":"page"},{"location":"#Groups-without-case-sensitive.-Emits-the-grouped-indices-rather-than-the-grouped-elements.","page":"Home","title":"Groups without case sensitive. Emits the grouped indices rather than the grouped elements.","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby2_dict_indices(\"AaAABbBcCD\", keyfunc=uppercase))\n4-element Vector{Tuple{Any, Vector{Int64}}}:\n ('A', [1, 2, 3, 4])\n ('B', [5, 6, 7])\n ('C', [8, 9])\n ('D', [10])","category":"page"},{"location":"#Example-2:-Groups-integer-numbers","page":"Home","title":"Example 2: Groups integer numbers","text":"","category":"section"},{"location":"#Simple-case-2","page":"Home","title":"Simple case","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"groupby2 and groupby_numbers can be used to group integer numbers.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby2([10,20,20,30]))\n3-element Vector{Vector{Int64}}:\n [10]\n [20, 20]\n [30]","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby_numbers([10,20,20,30])); # => same result","category":"page"},{"location":"#Emits-keys-2","page":"Home","title":"Emits keys","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby2_dict([10,20,20,30]))\n3-element Vector{Tuple{Any, Vector{Int64}}}:\n (10, [10])\n (20, [20, 20])\n (30, [30])","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby_numbers_dict([10,20,20,30])); # => same result","category":"page"},{"location":"#Groups-by-absolute-values","page":"Home","title":"Groups by absolute values","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby2_dict([10,-20,20,30]; keyfunc=abs))\n3-element Vector{Tuple{Any, Vector{Int64}}}:\n (10, [10])\n (20, [-20, 20])\n (30, [30])","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby_numbers_dict([10,-20,20,30]; keyfunc=abs)); # => same result","category":"page"},{"location":"#Groups-by-absolute-values.-Emits-the-grouped-indices-rather-than-the-grouped-elements.","page":"Home","title":"Groups by absolute values. Emits the grouped indices rather than the grouped elements.","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby2_dict_indices([10,-20,20,30]; keyfunc=abs))\n3-element Vector{Tuple{Any, Vector{Int64}}}:\n (10, [1])\n (20, [2, 3])\n (30, [4])","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby_numbers_dict_indices([10,-20,20,30]; keyfunc=abs)); # => same result","category":"page"},{"location":"#Example-3:-Groups-floating-point-numbers","page":"Home","title":"Example 3: Groups floating point numbers","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Use groupby_numbersYYYZZZ rather than groupby2YYYZZZ to group floating point numbers.","category":"page"},{"location":"#Simple-case.","page":"Home","title":"Simple case.","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"groupby_numbersYYYZZZ groups floating point numbers with isapprox function by default.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby_numbers([ 2e-10, 2e-9, 2e-8, 2e-7 ] .+ 1))\n3-element Vector{Vector{Float64}}:\n [1.0000000002, 1.000000002]\n [1.00000002]\n [1.0000002]","category":"page"},{"location":"#Adjusts-tolerance-with-atol-and-rtol-parameters.","page":"Home","title":"Adjusts tolerance with atol and rtol parameters.","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Consult the manual of Base.isapprox for its keyword parameters such as atol and rtol.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby_numbers([ 2e-8, 2e-7, 2e-6, 2e-5 ] .+ 1; atol=1e-6))\n3-element Vector{Vector{Float64}}:\n [1.00000002, 1.0000002]\n [1.000002]\n [1.00002]","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby_numbers([ 16, 17, 19, 20 ]* 1e-4 .+ 1; atol=2e-4))\n2-element Vector{Vector{Float64}}:\n [1.0016, 1.0017]\n [1.0019, 1.002]","category":"page"},{"location":"#Groups-by-their-absolute-values","page":"Home","title":"Groups by their absolute values","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby_numbers([ 1+2e-6, -1+2e-5, 1+2e-4, 1-2e-3 ]; \n        keyfunc=abs, rtol=1e-4))\n3-element Vector{Vector{Float64}}:\n [1.000002, -0.99998]\n [1.0002]\n [0.998]","category":"page"},{"location":"#Emits-the-grouped-indices-rather-than-the-grouped-elements.","page":"Home","title":"Emits the grouped indices rather than the grouped elements.","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"julia> collect(groupby_numbers_indices([ 1+2e-6, -1+2e-5, 1+2e-4, 1-2e-3 ]; \n        keyfunc=abs, rtol=1e-4))\n3-element Vector{Vector{Int64}}:\n [1, 2]\n [3]\n [4]","category":"page"},{"location":"#Example-4:-Groups-noisy-vectors","page":"Home","title":"Example 4: Groups noisy vectors","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"groupby_numbersYYYZZZ can be used to group an array of floating point numbers.","category":"page"},{"location":"#Groups-array-of-vectors","page":"Home","title":"Groups array of vectors","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Rotation preserves norm.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using LinearAlgebra\njulia> # Rotation matrix\n       t=15; r15 = [ cosd(t) -sind(t); sind(t) cosd(t)]\n2×2 Matrix{Float64}:\n 0.965926  -0.258819\n 0.258819   0.965926\n\njulia> using IterTools\njulia> vs1 = collect( Iterators.take(\n                iterated(v -> (1+rand()*1e-8)*r15*v, [1, 0]), 5) )\n5-element Vector{Vector}:\n [1, 0]\n [0.9659258323666292, 0.25881904673099826]\n [0.8660254177031013, 0.5000000080359436]\n [0.7071067969544697, 0.7071067969544694]\n [0.5000000112991584, 0.8660254233551546]\n\njulia> # group by norm\n       collect( groupby_numbers_indices(vs1; keyfunc=norm, atol=1e-6))\n1-element Vector{Vector{Int64}}:\n [1, 2, 3, 4, 5]","category":"page"},{"location":"#Groups-array-of-tuple-consisting-of-vector-and-its-norm","page":"Home","title":"Groups array of tuple consisting of vector and its norm","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Calculate the vectors and their norms to avoid recalculate the latters.","category":"page"},{"location":"","page":"Home","title":"Home","text":"julia> using LinearAlgebra\n\njulia> vs1=vec( [ begin \n            v= [i1,i2] *(1+(rand()-0.5)*1e-8);\n            (norm(v),v)\n        end for i1 in -2:2, i2 in -2:2] );\n\njulia> # sort by norm\n       vs2=sort(vs1; by=first);\n\njulia> # group by norm\n       collect(groupby_numbers_dict_indices(vs2; keyfunc=first))\n6-element Vector{Tuple{Any, Vector{Int64}}}:\n (0.0, [1])\n (0.9999999976242439, [2, 3, 4, 5])\n (1.4142135561654923, [6, 7, 8, 9])\n (1.999999991951223, [10, 11, 12, 13])\n (2.2360679691661827, [14, 15, 16, 17, 18, 19, 20, 21])\n (2.828427114159456, [22, 23, 24, 25])","category":"page"},{"location":"#See-also","page":"Home","title":"See also","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"IterTools.groupby","category":"page"}]
}
