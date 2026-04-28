function goeslonlat(gds :: GOESDataset)

    if gds.satellite == 16 || gds.satellite == 19
        position = "east"
    elseif gds.satellite == 17 || gds.satellite == 18
        position = "west"
    end

    if gds.sectorID == "C"
        sector = "conus"
    elseif gds.sectorID == "F"
        sector = "fulldisk"
    elseif gds.sectorID == "M"
        error("$(modulelog()) - Coordinates for Mesoscale sectors are not uniquely defined and must be converted directly")
    end
    fnc = joinpath(gds.mask,"goes_$(position)-$(sector).nc")
    if !isfile(fnc); downloadgoeslonlat(gds,fnc) end
    
    ds = NCDataset(fnc)
    lon = ds["longitude"][:,:]
    lat = ds["latitude"][:,:]
    close(ds)

    return lon, lat

end

function downloadgoeslonlat(gds :: GOESDataset, fnc :: AbstractString)

    if gds.satellite == 16 || gds.satellite == 19
        position = 19
    elseif gds.satellite == 17 || gds.satellite == 18
        position = 18
    end

    if gds.sectorID == "C"
        sector = "conus"
    elseif gds.sectorID == "F"
        sector = "full_disk"
    end

    download("https://www.star.nesdis.noaa.gov/atmospheric-composition-training/documents/goes$(position)_abi_$(sector)_lat_lon.zip", fnc)

    return nothing

end