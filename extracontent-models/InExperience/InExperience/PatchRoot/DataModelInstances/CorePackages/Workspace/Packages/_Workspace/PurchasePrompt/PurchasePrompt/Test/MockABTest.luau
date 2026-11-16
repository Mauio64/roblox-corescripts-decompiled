return {
	new = function(options)
		local v = options or {}
		return {
			getLayerData = function(p)
				return v[p]
			end,
			logUserLayerExposure = function(p)
				return v[p]
			end
		}
	end
}
