"""
    read(
        gds :: GOESDataset,
        dt  :: TimeType,
        hr  :: Int,
        ii  :: Int;
        quiet :: Bool = true
    ) -> NCDataset

Reads a GOES dataset specified by `gds` for a GeoRegion specified by `geo` at a date specified by Date `dt`, Hour `$hr` and Step `$ii` (roughly every 5 minutes).

Arguments
=========
- `gds` : a `GOESDataset` specifying the dataset details and date download range
- `dt`  : A specified date.
- `hr`  : The hour (in the date) for which to retrieve data.
- `ii`  : The step (in the hour) for which to retrieve data (roughly every 5 minutes).

Keyword Arguments
=================
- `throw` : if `true`, then throw an error if the dataset does not exist. Otherwise, return `nothing`.
- `quiet` : if `true`, then suppress logging output. Otherwise, logging output will be displayed.
"""
function read(
	gds :: GOESDataset,
	dt  :: TimeType,
    hr  :: Int,
    ii  :: Int;
    throw :: Bool = true,
    quiet :: Bool = true
)

    fnc = gdsfnc(gds,dt,hr,ii)

    if quiet
        disable_logging(Logging.Info)
    end

    
    if !isfile(fnc)
        if throw
            error("$(modulelog()) - The $(gds.product) Dataset during Date $dt, Hour $hr and Step $ii does not exist at $(fnc).  Check if files exist at $(gds.path) or download the files here")
        else
            @warn "$(modulelog()) - The $(gds.product) Dataset during Date $dt, Hour $hr and Step $ii does not exist at $(fnc).  Check if files exist at $(gds.path) or download the files here"
            return nothing
        end
    end
    @info "$(modulelog()) - Opening the $(gds.product) NCDataset during Date $dt, Hour $hr and Step $ii"
    

    if quiet
        disable_logging(Logging.Debug)
    end

    flush(stderr)

    return NCDataset(fnc)

end

"""
    read(
        gds :: GOESDataset,
        geo :: GeoRegion,
        var :: String,
        dt  :: TimeType;
        quiet :: Bool = true
    ) -> NCDataset

Reads a GOES dataset specified by `gds` for a GeoRegion specified by `geo` at a date specified by Date `dt`, Hour `$hr` and Step `$ii` (roughly every 5 minutes).

Arguments
=========
- `gds` : a `GOESDataset` specifying the dataset details and date download range
- `geo` : a `GeoRegion` specifying the geographic region for which to retrieve data
- `var` : a `String` specifying the variable to retrieve
- `dt`  : a `TimeType` specifying the date for which to retrieve data

Keyword Arguments
=================
- `throw` : if `true`, then throw an error if the dataset does not exist. Otherwise, return `nothing`.
- `quiet` : if `true`, then suppress logging output. Otherwise, logging output will be displayed.
"""
function read(
	gds :: GOESDataset,
	geo :: GeoRegion,
    var :: String,
    dt  :: TimeType;
    throw :: Bool = true,
    quiet :: Bool = true
)

    fnc = gdsfnc(gds,geo,var,dt)

    if quiet
        disable_logging(Logging.Info)
    end

    
    if !isfile(fnc)
        if throw
            error("$(modulelog()) - The $(gds.product) Dataset during Date $dt, Hour $hr and Step $ii does not exist at $(fnc).  Check if files exist at $(gds.path) or download the files here")
        else
            @warn "$(modulelog()) - The $(gds.product) Dataset during Date $dt, Hour $hr and Step $ii does not exist at $(fnc).  Check if files exist at $(gds.path) or download the files here"
            return nothing
        end
    end
    @info "$(modulelog()) - Opening the $(gds.product) NCDataset during Date $dt, Hour $hr and Step $ii"
    

    if quiet
        disable_logging(Logging.Debug)
    end

    flush(stderr)

    return NCDataset(fnc)

end