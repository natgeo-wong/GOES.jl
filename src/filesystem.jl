"""
    npdfnc(
        npd :: NASAPrecipitationDataset,
        geo :: GeoRegion,
        dt  :: TimeType
    ) -> String

Returns of the path of the file for the NASA Precipitation dataset specified by `npd` for a GeoRegion specified by `geo` at a date specified by `dt`.

Arguments
=========
- `npd` : a `NASAPrecipitationDataset` specifying the dataset details and date download range
- `geo` : a `GeoRegion` (see [GeoRegions.jl](https://github.com/JuliaClimate/GeoRegions.jl)) that sets the geographic bounds of the data array in lon-lat
- `dt`  : A specified date. The NCDataset retrieved may will contain data for the date, although it may also contain data for other dates depending on the `NASAPrecipitationDataset` specified by `npd`
"""
function gdsfnc(
    gds :: GOESDataset,
    dt  :: TimeType,
    hr  :: Int,
    ii  :: Int
)

    fol = joinpath(gds.path,yrmo2dir(dt))
    if !isdir(fol); mkpath(fol) end
    fnc = "GOES$(gds.satellite)" * "-" * gds.product * "-" *
          ymd2str(dt) * "T" * @sprintf("%02d",hr) * "-step" * @sprintf("%02d",ii) * ".nc"
    return joinpath(fol,fnc)

end

function gdsfnc(
    gds :: GOESDataset,
    geo :: GeoRegion,
    var :: String,
    dt  :: TimeType
)

    fol = joinpath(gds.path,geo.ID,yrmo2dir(dt))
    if !isdir(fol); mkpath(fol) end
    fnc = "GOES$(gds.satellite)" * "-" * gds.product * "-" * geo.ID * "-" * 
           var * "-" * ymd2str(dt) * ".nc"
    return joinpath(fol,fnc)

end