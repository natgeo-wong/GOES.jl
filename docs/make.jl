using GOES
using Documenter
using DocumenterVitepress

makedocs(;
    format=DocumenterVitepress.MarkdownVitepress(
        repo="github.com/natgeo-wong/GOES.jl",
        devbranch="main",
        devurl = "dev"
    ),
    modules=[GOES],
    authors="Nathanael Wong <natgeo.wong@outlook.com>",
    sitename="GOES.jl",
    pages=[
        "Home" => "index.md",
    ],
)
# and for deploying use

DocumenterVitepress.deploydocs(;
    repo="github.com/natgeo-wong/GOES.jl",
    target = joinpath(@__DIR__, "build"),
    branch = "gh-pages",
    devbranch="main",
    push_preview = true,
)