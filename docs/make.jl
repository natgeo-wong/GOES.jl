using GOES
using Documenter

DocMeta.setdocmeta!(GOES, :DocTestSetup, :(using GOES); recursive=true)

makedocs(;
    modules=[GOES],
    authors="Nathanael Wong <natgeo.wong@outlook.com>",
    sitename="GOES.jl",
    format=Documenter.HTML(;
        canonical="https://natgeo-wong.github.io/GOES.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/natgeo-wong/GOES.jl",
    devbranch="main",
)
