return {
	new = function() -- line: 3
		return {}
	end,
	fromWeb = function(p1) -- line: 9
		local v2 = p1 or {}

		v2.placeId = tostring(v2.placeId)

		return v2
	end
}
