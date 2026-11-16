local v5 = {}
return {
	GameSortLoadSourceType = {
		API = "API",
		ClientFallbackCache = "ClientFallbackCache"
	},
	setSortLoadSource = function(p2, p3)
		if p3 then
			v5[p2] = p3
		else
			v5[p2] = nil
		end
	end,
	getSortLoadSource = function(p2)
		return v5[p2]
	end
}
