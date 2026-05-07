"""
    read(
        npd :: NASAPrecipitationDataset,
        geo :: GeoRegion,
        dt  :: TimeType;
        lonlat :: Bool = false
    ) -> NCDataset           (if lonlat = false)
      -> lon, lat, NCDataset (if lonlat = true)

Reads a NASA Precipitation dataset specified by `npd` for a GeoRegion specified by `geo` at a date specified by `dt`.

Arguments
=========
- `e5ds` : a `NASAPrecipitationDataset` specifying the dataset details and date download range
- `ereg` : a `GeoRegion` (see [GeoRegions.jl](https://github.com/JuliaClimate/GeoRegions.jl)) that sets the geographic bounds of the data array in lon-lat
- `dt`   : A specified date. The NCDataset retrieved may will contain data for the date, although it may also contain data for other dates depending on the `NASAPrecipitationDataset` specified by `npd`

Keyword Arguments
=================
- `lonlat` : if `true`, then return the longitude and latitude vectors for the dataset. Otherwise only the NCDataset type will be returned.
"""
function read(
	gds :: GOESDataset,
	dt  :: TimeType,
    hr  :: Int,
    ii  :: Int;
    quiet :: Bool = true
)

    fnc = gdsfnc(gds,dt,hr,ii)

    if quiet
        disable_logging(Logging.Warn)
    end

    
    if !isfile(fnc)
        error("$(modulelog()) - The $(gds.product) Dataset during Date $dt, Hour $hr and Step $ii does not exist at $(fnc).  Check if files exist at $(gds.path) or download the files here")
    end
    @info "$(modulelog()) - Opening the $(gds.product) NCDataset during Date $dt, Hour $hr and Step $ii"
    

    if quiet
        disable_logging(Logging.Debug)
    end

    flush(stderr)

    return NCDataset(fnc)

end

function read(
	gds :: GOESDataset,
	geo :: GeoRegion,
    var :: String,
    dt  :: TimeType,
    quiet :: Bool = true
)

    fnc = gdsfnc(gds,geo,var,dt)

    if quiet
        disable_logging(Logging.Warn)
    end

    
    if !isfile(fnc)
        error("$(modulelog()) - The $(gds.product) Dataset during Date $dt, Hour $hr and Step $ii does not exist at $(fnc).  Check if files exist at $(gds.path) or download the files here")
    end
    @info "$(modulelog()) - Opening the $(gds.product) NCDataset during Date $dt, Hour $hr and Step $ii"
    

    if quiet
        disable_logging(Logging.Debug)
    end

    flush(stderr)

    return NCDataset(fnc)

end