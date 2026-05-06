function save(
	data :: AbstractArray{Float32,3},
	t    :: Vector{DateTime,1},
	gvar :: String,
	dt   :: TimeType,
	gds  :: GOESDataset,
	geo  :: GeoRegion,
	ggrd :: RegionGrid,
	dict :: Vector{Dict}
)

	@info "$(modulelog()) - Saving $(gds.name) data in the $(geo.name) GeoRegion for $(dt)"

	fnc = gdsfnc(gds,geo,gvar,dt)
	if !isdir(dirname(fnc)); mkpath(dirname(fnc)) end
	if isfile(fnc)
		@info "$(modulelog()) - Overwrite stale NetCDF file $(fnc) ..."
        rm(fnc)
	end
	@info "$(modulelog()) - Creating NetCDF file $(fnc) ..."
	pds = NCDataset(fnc,"c",attrib = Dict(
        "doi" => gds.doi
    ))

	pds.dim["longitude"] = size(ggrd.lon,1)
	pds.dim["latitude"]  = size(ggrd.lat,2)
	pds.dim["time"]      = 288

	nclon = defVar(pds,"longitude",Float32,("longitude","latitude"),attrib = Dict(
	    "units"         => "degrees_east",
	    "standard_name" => "longitude",
	))

	nclat = defVar(pds,"latitude",Float32,("longitude","latitude"),attrib = Dict(
	    "units"         => "degrees_north",
	    "standard_name" => "latitude",
	))

	ncvar = defVar(pds,gvar,Float32,("longitude","latitude","time"),attrib = dict[1])
	
	dict[2]["units"] = "minutes since $(dt) 00:00:00"
	nct = defVar(pds,"time",Float64,("time",),attrib = dict[2])

	nclon[:,:] = ggrd.lon
	nclat[:,:] = ggrd.lat
	nct[:] = t
	ncvar[:,:,:] = data

	close(pds)

	@info "$(modulelog()) - $(gds.name) data in the $(geo.name) GeoRegion for $(dt) has been saved into $(fnc)"

end