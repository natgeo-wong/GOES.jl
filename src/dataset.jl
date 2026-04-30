"""
    GOESDataset{ST<:AbstractString, DT<:TimeType}

Specifies an GOES (Geostationary Operational Environmental Satellite) dataset with the following fields:
* `stream` - The GOES datastream name (e.g., `"sgpmetE13.b1"`).
* `start` - The start date for the data query.
* `stop` - The end date for the data query.
* `path` - The local directory path where data will be stored.
"""
struct GOESDataset{ST<:AbstractString, DT<:TimeType}
    satellite :: Int
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
        start  :: DT,
        stop   :: DT,
        path   :: ST = armpath(homedir())
    ) where {ST <: AbstractString, DT<:TimeType} -> GOESDataset{ST,DT}

Create an `GOESDataset` specification for querying and downloading GOES data.

Keyword Arguments
=================
* `stream` - The GOES datastream name (e.g., `"sgpmetE13.b1"`).
* `start` - The start date for the data query.
* `stop` - The end date for the data query.
* `path` - The root directory for storing data, default is `homedir()`.
"""
function GOESDataset(;
    ID      :: Int,
    product :: ST,
    path    :: ST = goespath(homedir()),
) where {ST <: AbstractString}

    checksatellite(ID)

    path = joinpath(goespath(path),product)
    if !isdir(path); mkpath(path) end

    mask = joinpath(goespath(path),"mask")
    if !isdir(mask); mkpath(mask) end

    return GOESDataset{ST,Date}(
        ID, product, path, mask,
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
		"    Satellite ID (satellite) : ", gds.ID, '\n',
		"    Product ID     (product) : ", gds.product, '\n',
		"    Product Sector  (sector) : ", gds.sector, '\n',
		"    Directory         (path) : ", gds.path, '\n',
		"    Date Begin       (start) : ", gds.start, '\n',
		"    Date End          (stop) : ", gds.stop , '\n',
	)

end

###

checksatellite(ID :: Int) = ID > 15 ? nothing : error("$(modulelog()) - Amazon Web Services does not provided GOES Data for satellites before GOES-16")

checksectorID(product :: AbstractString) = product[end]

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