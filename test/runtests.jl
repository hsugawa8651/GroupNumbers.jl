using GroupNumbers
using Test

@testset "GroupNumbers.jl" begin

    @testset "groupby2" begin
        function test_groupby2(input, expected; kwargs...)
            result = collect(groupby2(input; kwargs...))
            @test result == expected
        end

        @testset "empty arrays" begin
            test_groupby2([], Vector{Any}[])

            test_groupby2(Union{}[], Union{}[])
        end

        @testset "singletons" begin
            test_groupby2("A", [['A']])
            test_groupby2([10], [[10]])
        end

        @testset "not group" begin
            test_groupby2("ABC", [['A'], ['B'], ['C']])
            test_groupby2([10, 20, 30], [[10], [20], [30]])
        end

        @testset "group" begin
            test_groupby2("ABBC", [['A'], ['B', 'B'], ['C']])
            test_groupby2([10, 20, 20, 30], [[10], [20, 20], [30]])
        end
    end

    @testset "groupby2 emit=Int64" begin
        function test_groupby2(input, expected; kwargs...)
            result = collect(groupby2(input; kwargs...))
            @test result == expected
        end

        @testset "empty arrays" begin
            @test_throws Exception groupby2([]; emit = Int64)
            @test_throws Exception groupby2(Union{}[]; emit = Int64)
        end

        @testset "singletons" begin
            test_groupby2("A", [[65]]; emit = Int64)
            test_groupby2([10], [[10]]; emit = Int64)
        end

        @testset "not group" begin
            test_groupby2("ABC", [[65], [66], [67]]; emit = Int64)
            test_groupby2([10, 20, 30], [[10], [20], [30]]; emit = Int64)
        end

        @testset "group" begin
            test_groupby2("ABBC", [[65], [66, 66], [67]]; emit = Int64)
            test_groupby2([10, 20, 20, 30], [[10], [20, 20], [30]]; emit = Int64)
        end
    end

    @testset "groupby2_dict" begin
        function test_groupby2_dict(input, expected; kwargs...)
            result = collect(groupby2_dict(input; kwargs...))
            @test result == expected
        end

        @testset "empty arrays" begin
            test_groupby2_dict([], Tuple{Any,Vector{Any}}[])

            test_groupby2_dict(Union{}[], Union{}[])
        end

        @testset "singletons" begin
            test_groupby2_dict("A", [('A', ['A'])])
            test_groupby2_dict([10], Tuple{Int64,Vector{Int64}}[(10, [10])])
        end

        @testset "not group" begin
            test_groupby2_dict("ABC", [('A', ['A']), ('B', ['B']), ('C', ['C'])])
            test_groupby2_dict([10, 20, 30], [(10, [10]), (20, [20]), (30, [30])])
        end

        @testset "group" begin
            test_groupby2_dict("ABBC", [('A', ['A']), ('B', ['B', 'B']), ('C', ['C'])])
            test_groupby2_dict([10, 20, 20, 30], [(10, [10]), (20, [20, 20]), (30, [30])])
        end
    end

    @testset "groupby2_dict emit=Int64" begin
        function test_groupby2_dict(input, expected; kwargs...)
            result = collect(groupby2_dict(input; kwargs...))
            @test result == expected
        end

        @testset "empty arrays" begin
            @test_throws Exception groupby2_dict([]; emit = Int64)
            @test_throws Exception groupby2_dict(Union{}[]; emit = Int64)
        end

        @testset "singletons" begin
            test_groupby2_dict("A", [('A', [65])]; emit = Int64)
            test_groupby2_dict([10], Tuple{Int64,Vector{Int64}}[(10, [10])]; emit = Int64)
        end

        @testset "not group" begin
            test_groupby2_dict("ABC", [('A', [65]), ('B', [66]), ('C', [67])]; emit = Int64)
            test_groupby2_dict(
                [10, 20, 30],
                [(10, [10]), (20, [20]), (30, [30])];
                emit = Int64,
            )
        end

        @testset "group" begin
            test_groupby2_dict(
                "ABBC",
                [('A', [65]), ('B', [66, 66]), ('C', [67])];
                emit = Int64,
            )
            test_groupby2_dict(
                [10, 20, 20, 30],
                [(10, [10]), (20, [20, 20]), (30, [30])];
                emit = Int64,
            )
        end
    end

    @testset "groupby2_indices" begin
        function test_groupby2_indices(input, expected; kwargs...)
            result = collect(groupby2_indices(input; kwargs...))
            @test result == expected
        end

        @testset "empty arrays" begin
            test_groupby2_indices([], Tuple{Any,Vector{Any}}[])

            test_groupby2_indices(Union{}[], Union{}[])
        end
        @testset "singletons" begin
            test_groupby2_indices("A", [[1]])
            test_groupby2_indices([10], [[1]])
        end

        @testset "not group" begin
            test_groupby2_indices("ABC", [[1], [2], [3]])
            test_groupby2_indices([10, 20, 30], [[1], [2], [3]])
        end

        @testset "group" begin
            test_groupby2_indices("ABBC", [[1], [2, 3], [4]])
            test_groupby2_indices([10, 20, 20, 30], [[1], [2, 3], [4]])
        end
    end

    @testset "groupby2_dict_indices" begin
        function test_groupby2_dict_indices(input, expected; kwargs...)
            result = collect(groupby2_dict_indices(input; kwargs...))
            @test result == expected
        end

        @testset "empty arrays" begin
            test_groupby2_dict_indices([], Tuple{Any,Vector{Any}}[])

            test_groupby2_dict_indices(Union{}[], Union{}[])
        end
        @testset "singletons" begin
            test_groupby2_dict_indices("A", [('A', [1])])
            test_groupby2_dict_indices([10], [(10, [1])])
        end

        @testset "not group" begin
            test_groupby2_dict_indices("ABC", [('A', [1]), ('B', [2]), ('C', [3])])
            test_groupby2_dict_indices([10, 20, 30], [(10, [1]), (20, [2]), (30, [3])])
        end

        @testset "group" begin
            test_groupby2_dict_indices("ABBC", [('A', [1]), ('B', [2, 3]), ('C', [4])])
            test_groupby2_dict_indices(
                [10, 20, 20, 30],
                [(10, [1]), (20, [2, 3]), (30, [4])],
            )
        end
    end

    @testset "groupby_numbers" begin
        function test_groupby_numbers(input, expected; kwargs...)
            result = collect(groupby_numbers(input; kwargs...))
            @test result == expected
        end

        @testset "empty arrays" begin
            test_groupby_numbers([], [])

            test_groupby_numbers(Union{}[], Union{}[])
        end
        @testset "singletons" begin
            test_groupby_numbers("A", [['A']])
            test_groupby_numbers([10], [[10]])
        end

        @testset "not group" begin
            @test_throws Exception collect(groupby_numbers("ABC"))
            # ERROR: MethodError: no method matching isapprox(::Char, ::Char)

            test_groupby_numbers([10, 20, 30], [[10], [20], [30]])
        end

        @testset "group" begin
            @test_throws Exception collect(groupby_numbers("ABBC"))
            # ERROR: MethodError: no method matching isapprox(::Char, ::Char)

            test_groupby_numbers([10, 20, 20, 30], [[10], [20, 20], [30]])
        end
    end

    @testset "groupby_numbers emit=Int64" begin
        function test_groupby_numbers(input, expected; kwargs...)
            result = collect(groupby_numbers(input; kwargs...))
            @test result == expected
        end

        @testset "empty arrays" begin
            @test_throws Exception groupby_numbers([]; emit = Int64)
            @test_throws Exception groupby_numbers(Union{}[]; emit = Int64)
        end
        @testset "singletons" begin
            test_groupby_numbers("A", [[65]]; emit = Int64)
            test_groupby_numbers([10], [[10]])
        end

        @testset "not group" begin
            @test_throws Exception collect(groupby_numbers("ABC"; emit = Int64))
            # ERROR: MethodError: no method matching isapprox(::Char, ::Char)

            test_groupby_numbers([10, 20, 30], [[10], [20], [30]]; emit = Int64)
        end

        @testset "group" begin
            @test_throws Exception collect(groupby_numbers("ABBC"; emit = Int64))
            # ERROR: MethodError: no method matching isapprox(::Char, ::Char)

            test_groupby_numbers([10, 20, 20, 30], [[10], [20, 20], [30]]; emit = Int64)
        end
    end

    @testset "groupby_numbers_dict" begin
        function test_groupby_numbers_dict(input, expected; kwargs...)
            result = collect(groupby_numbers_dict(input; kwargs...))
            @test result == expected
        end

        @testset "empty arrays" begin
            test_groupby_numbers_dict([], Tuple{Any,Vector{Any}}[])

            test_groupby_numbers_dict(Union{}[], Union{}[])
        end
        @testset "singletons" begin

            test_groupby_numbers_dict("A", [('A', ['A'])])

            test_groupby_numbers_dict([10], [(10, [10])])
        end

        @testset "not group" begin

            @test_throws Exception collect(groupby_numbers_dict("ABC"))
            # ERROR: MethodError: no method matching isapprox(::Char, ::Char)

            test_groupby_numbers_dict([10, 20, 30], [(10, [10]), (20, [20]), (30, [30])])
        end

        @testset "group" begin
            @test_throws Exception collect(groupby_numbers_dict("ABBC"))
            # ERROR: MethodError: no method matching isapprox(::Char, ::Char)

            test_groupby_numbers_dict(
                [10, 20, 20, 30],
                [(10, [10]), (20, [20, 20]), (30, [30])],
            )
        end
    end

    @testset "groupby_numbers_dict emit=Int64" begin
        function test_groupby_numbers_dict(input, expected; kwargs...)
            result = collect(groupby_numbers_dict(input; kwargs...))
            @test result == expected
        end

        @testset "empty arrays" begin
            @test_throws Exception groupby_numbers_dict([]; emit = Int64)
            @test_throws Exception groupby_numbers_dict(Union{}[]; emit = Int64)
        end
        @testset "singletons" begin
            test_groupby_numbers_dict("A", [('A', [65])]; emit = Int64)
            test_groupby_numbers_dict([10], [(10, [10])]; emit = Int64)
        end

        @testset "not group" begin
            @test_throws Exception collect(groupby_numbers_dict("ABC"; emit = Int64))
            # ERROR: MethodError: no method matching isapprox(::Char, ::Char)

            test_groupby_numbers_dict(
                [10, 20, 30],
                [(10, [10]), (20, [20]), (30, [30])];
                emit = Int64,
            )
        end

        @testset "group" begin
            @test_throws Exception collect(groupby_numbers_dict("ABBC"; emit = Int64))
            # ERROR: MethodError: no method matching isapprox(::Char, ::Char)

            test_groupby_numbers_dict(
                [10, 20, 20, 30],
                [(10, [10]), (20, [20, 20]), (30, [30])];
                emit = Int64,
            )
        end
    end

    @testset "groupby_numbers_indices" begin
        function test_groupby_numbers_indices(input, expected; kwargs...)
            result = collect(groupby_numbers_indices(input; kwargs...))
            @test result == expected
        end

        @testset "empty arrays" begin
            test_groupby_numbers_indices([], [])
            test_groupby_numbers_indices(Union{}[], Union{}[])
        end
        @testset "singletons" begin
            test_groupby_numbers_indices("A", [[1]])
            test_groupby_numbers_indices([10], [[1]])
        end
        @testset "not group" begin
            @test_throws Exception collect(groupby_numbers_indices("ABC"))
            # ERROR: MethodError: no method matching isapprox(::Char, ::Char)

            test_groupby_numbers_indices([10, 20, 30], [[1], [2], [3]])
        end

        @testset "group" begin
            @test_throws Exception collect(groupby_numbers_indices("ABBC"))
            # ERROR: MethodError: no method matching isapprox(::Char, ::Char)

            test_groupby_numbers_indices([10, 20, 20, 30], [[1], [2, 3], [4]])
        end
    end

    @testset "groupby_numbers_dict_indices" begin
        function test_groupby_numbers_dict_indices(input, expected; kwargs...)
            result = collect(groupby_numbers_dict_indices(input; kwargs...))
            @test result == expected
        end

        @testset "empty arrays" begin
            test_groupby_numbers_dict_indices([], Tuple{Any,Vector{Any}}[])
            test_groupby_numbers_dict_indices(Union{}[], Union{}[])
        end
        @testset "singletons" begin
            test_groupby_numbers_dict_indices("A", [('A', [1])])
            test_groupby_numbers_dict_indices([10], [(10, [1])])
        end

        @testset "not group" begin
            @test_throws Exception collect(groupby_numbers_dict_indices("ABC"))
            # ERROR: MethodError: no method matching isapprox(::Char, ::Char)

            test_groupby_numbers_dict_indices(
                [10, 20, 30],
                [(10, [1]), (20, [2]), (30, [3])],
            )
        end

        @testset "group" begin
            @test_throws Exception collect(groupby_numbers_dict_indices("ABBC"))
            # ERROR: MethodError: no method matching isapprox(::Char, ::Char)

            test_groupby_numbers_dict_indices(
                [10, 20, 20, 30],
                [(10, [1]), (20, [2, 3]), (30, [4])],
            )
        end
    end

end
