return {
	new = function()
		return {}
	end,
	fromWeb = function(options)
		local v5 = options or {}
		v5.placeId = tostring(v5.placeId)

		return v5
	end
}
