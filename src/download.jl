"""
    download(
        gds :: GOESDataset;
		start :: Date = gds.start,
		stop  :: Date = gds.stop,
	    overwrite :: Bool = false
    ) -> nothing

Downloads a NASA Precipitation dataset specified by `btd` for a GeoRegion specified by `geo`

Arguments
=========
- `btd` : a `NASAPrecipitationDataset` specifying the dataset details and date download range
- `geo` : a `GeoRegion` (see [GeoRegions.jl](https://github.com/JuliaClimate/GeoRegions.jl)) that sets the geographic bounds of the data array in lon-lat

Keyword Arguments
=================
- `overwrite` : If `true`, overwrite any existing files
"""
function download(
	gds   :: GOESDataset;
	start :: Date = gds.start,
	stop  :: Date = gds.stop,
	overwrite :: Bool = false
)

	@info "$(modulelog()) - Establishing AWS connection credentials and region ..."
	aws = AWSConfig(; creds=nothing, region="us-east-1")

	@info "$(modulelog()) - Downloading $(gds.name) data from $(gds.start) to $(gds.stop)"

	for dt in start : Day(1) : stop

		@info "$(modulelog()) - Downloading $(gds.product) data from the Amazon Web Servers ..."

		yr = year(dt)
		mo = month(dt)
		dy = day(dt)
		doy = dayofyear(dt)
		
		for hr = 0 : 23

			prefix = "$product/$yr/$(@sprintf("%03d",doy))/$(@sprintf("%02d",hr))/"

			keys = s3_list_objects(aws, bucket, prefix)
			for (ii, obj) in enumerate(keys)
				fnc = gdsfnc(gds,dt,hr,ii)
				if overwrite || !isfile(fnc)
					s3_get_file(aws,bucket,obj["Key"],fnc)
				else
					@info "$(modulelog()) - $(gds.product) data for $(dt)T$(hr)-step$(ii) exists in $(fnc), and we are not overwriting, skipping to next timestep ..."
				end
			end
		
		end

		flush(stderr)

	end

end

"""
    download(
        gds :: GOESDataset;
		start :: Date = gds.start,
		stop  :: Date = gds.stop,
	    overwrite :: Bool = false
    ) -> nothing

Downloads a NASA Precipitation dataset specified by `btd` for a GeoRegion specified by `geo`

Arguments
=========
- `btd` : a `NASAPrecipitationDataset` specifying the dataset details and date download range
- `geo` : a `GeoRegion` (see [GeoRegions.jl](https://github.com/JuliaClimate/GeoRegions.jl)) that sets the geographic bounds of the data array in lon-lat

Keyword Arguments
=================
- `overwrite` : If `true`, overwrite any existing files
"""
function download(
	gds   :: GOESDataset,
	geo   :: GeoRegion,
	gvar  :: String;
	start :: Date = gds.start,
	stop  :: Date = gds.stop,
	overwrite :: Bool = false
)

	@info "$(modulelog()) - Establishing AWS connection credentials and region ..."
	aws = AWSConfig(; creds=nothing, region="us-east-1")

	@info "$(modulelog()) - Downloading $(gds.name) data from $(gds.start) to $(gds.stop)"
	lon,lat = gdslonlat(gds); ntlon,ntlat = size(lon)
	ggrd  = RegionGrid(geo,Point2.(lon,lat)); nlon,nlat = size(ggrd.lon)
	tdata = zeros(Float32,ntlon,ntlat)
	vdata = zeros(Float32,nlon,nlat,288)
	t     = zeros(DateTime,288)
	vdict = Vector{Dict}(undef,2)

	for dt in start : Day(1) : stop

		fnc = gdsfnc(gds,geo,gvar,dt)
		jj = 0
		if overwrite || !isfile(fnc)

			@info "$(modulelog()) - Downloading $(gds.product) data from the Amazon Web Servers ..."

			yr = year(dt)
			dy = dayofyear(dt)
			for hr = 0 : 23

				prefix = "$product/$yr/$(@sprintf("%03d",dy))/$(@sprintf("%02d",hr))/"
				keys = s3_list_objects(aws,bucket,prefix)
				for (ii, obj) in enumerate(keys)
					jj += 1
					s3_get_file(aws,bucket,obj["Key"],joinpath(gds.path,"tmp.nc"))
					ds = NCDataset(joinpath(gds.path,"tmp.nc"))
					NCDatasets.load!(ds[gvar].var[:,:],views(vdata,:,:,jj),:,:); vdict[1] = Dict(ds[gvar].attrib)
					iit   = @view t[jj]; iit .= ds["t"][:]; vdict[2] = Dict(ds["t"].attrib)
					extract!(iivar,tdata,ggrd)
					close(ds)
					rm(joinpath(gds.path,"tmp.nc"),force=true)
   			 	end
			
			end

		else

			@info "$(modulelog()) - $(gds.product) data for $(dt)T$(hr)-step$(ii) exists in $(fnc), and we are not overwriting, skipping to next timestep ..."

		end

		flush(stderr)
		if jj < 288
			vdata[:,:,(jj+1):end] .= NaN
			t[(jj+1):end] .= DateTime(1900,1,1,0,0,0)
		end
		save(vdata,t,gvar,dt,gds,geo,ggrd,vdict)

	end

end