using Documenter, GroupNumbers

DocMeta.setdocmeta!(GroupNumbers, :DocTestSetup, :(using GroupNumbers))
makedocs(
    modules = [GroupNumbers],
    authors="Hiroharu Sugawara <hsugawa@gmail.com>",
    sitename = "GroupNumbers.jl",
    format=Documenter.HTML(;
        canonical="https://hsugawa8651.github.io/GroupNumbers.jl",
        edit_link="main",
        assets=String[],
    ),
    pages = [
        "Home" => "index.md",
        "API Reference" => "reference.md"
        ],
    doctest=true,
   )

deploydocs(
    repo = "github.com/hsugawa8651/GroupNumbers.jl.git",
    devbranch="main",
)
