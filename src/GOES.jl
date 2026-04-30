module GOES

## Base Modules Used
using DelimitedFiles
using Logging
using Printf
using Statistics

import Base: show, read, download

## Modules Used
using AWS
using AWSS3
using PrettyTables

## Reexporting exported functions within these modules
using Reexport
@reexport using Dates
@reexport using NCDatasets

## Exporting the following functions:
export
        GOESDataset,
        
        download, read

## GOES.jl setup and logging preface

modulelog() = "$(now()) - GOES.jl"
goesdir = joinpath(@__DIR__,".files")
goespath(path) = splitpath(path)[end] !== "GOES" ? joinpath(path,"GOES") : path

## Including Relevant Files

include("dataset.jl")
# include("download.jl")
include("lonlat.jl")
include("backend.jl")

end
