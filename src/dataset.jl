"""
    GOESDataset{ST<:AbstractString, DT<:TimeType}

Specifies an GOES (Geostationary Operational Environmental Satellite) dataset with the following fields:
* `satellite` : An `Int` specifying the satellite ID (valid satellites are GOES 16-19)
* `bucket`    : An `AbstractString` specifying the S3 bucket name (derived from the satellite ID)
* `product`   : An `AbstractString` specifying the product name
* `path`      : An `AbstractString` specifying the local directory path where data will be stored
* `mask`      : An `AbstractString` specifying the directory path for storing lon/lat mask files
* `sector`    : An `AbstractString` specifying the sector name
* `sectorID`  : An `AbstractString` specifying the sector ID
* `start`     : An `TimeType` specifying the default start date for the data query
* `stop`      : An `TimeType` specifying the default end date for the data query
"""
struct GOESDataset{ST<:AbstractString, DT<:TimeType}
    satellite :: Int
    bucket    :: ST
    product   :: ST
    path      :: ST
    mask      :: ST
    sector    :: ST
    sectorID  :: ST
    start     :: DT
    stop      :: DT
end

"""
    GOESDataset(; stream :: ST,
        ID      :: Int,
        product :: ST,
        path    :: ST = goespath(homedir()),
    ) where {ST <: AbstractString} -> GOESDataset{ST,DT}

Create an `GOESDataset` specification for querying and downloading GOES data.

Keyword Arguments
=================
* `ID`      : An `Int` specifying the satellite ID (valid satellites are GOES 16-19)
* `product` : An `AbstractString` specifying the product name
* `path`    : An `AbstractString` specifying the data directory path where downloaded data will be, with the default given by `goespath(homedir())`
"""
function GOESDataset(;
    ID      :: Int,
    product :: ST,
    path    :: ST = goespath(homedir()),
) where {ST <: AbstractString}

    checksatellite(ID)

    mask = joinpath(goespath(path),"mask")
    if !isdir(mask); mkpath(mask) end

    path = joinpath(goespath(path),product)
    if !isdir(path); mkpath(path) end

    return GOESDataset{ST,Date}(
        ID, "noaa-goes$ID",product, path, mask,
        checksector(product), checksectorID(product),
        datestart(ID), datestop(ID)
    )

end

function show(
    io  :: IO,
    gds :: GOESDataset
)

    print(io,
		"The GOES Dataset has the following properties:\n",
		"    Satellite ID (satellite) : ", gds.satellite, '\n',
		"    Bucket          (bucket) : ", gds.bucket, '\n',
		"    Product ID     (product) : ", gds.product, '\n',
		"    Product Sector  (sector) : ", gds.sector, '\n',
		"    Directory         (path) : ", gds.path, '\n',
		"    Mask Directory    (mask) : ", gds.mask, '\n',
		"    Date Begin       (start) : ", gds.start, '\n',
		"    Date End          (stop) : ", gds.stop , '\n',
	)

end

###

checksatellite(ID :: Int) = ID > 15 ? nothing : error("$(modulelog()) - Amazon Web Services does not provided GOES Data for satellites before GOES-16")

checksectorID(product :: AbstractString) = string(product[end])

function checksector(product :: AbstractString)

    sID = checksectorID(product)

    if sID == "C"
        return "CONUS"
    elseif sID == "F"
        return "Full Disk"
    elseif sID == "M"
        return "Mesoscale"
    else
        error("$(modulelog()) - Sector ID not recognized")
    end

end

function datestart(satellite :: Int)

    if satellite == 16
        return Date(2017,12,1)
    elseif satellite == 17
        return Date(2019,2,1)
    elseif satellite == 18
        return Date(2023,1,1)
    elseif satellite == 19
        return Date(2025,4,1)
    else
        error("$(modulelog()) - Amazon Web Services does not provided GOES Data for satellites before GOES-16")
    end
    
end

function datestop(satellite :: Int)

    if satellite == 16
        return Date(2025,5,1)
    elseif satellite == 17
        return Date(2023,4,7)
    elseif satellite == 18
        return now() - Month(3)
    elseif satellite == 19
        return now() - Month(3)
    else
        error("$(modulelog()) - Amazon Web Services does not provided GOES Data for satellites before GOES-16")
    end
    
end