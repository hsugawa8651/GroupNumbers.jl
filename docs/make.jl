using Documenter, GroupNumbers

DocMeta.setdocmeta!(GroupNumbers, :DocTestSetup, :(using GroupNumbers))
makedocs(
    modules = [GroupNumbers],
    sitename = "GroupNumbers",
    pages = [
        "Home" => "index.md",
        "API Reference" => "reference.md"
        ],
    doctest=true,
   )

deploydocs(
    repo = "github.com/hsugawa8651/GroupNumbers.jl.git",
    push_preview = true,
)
