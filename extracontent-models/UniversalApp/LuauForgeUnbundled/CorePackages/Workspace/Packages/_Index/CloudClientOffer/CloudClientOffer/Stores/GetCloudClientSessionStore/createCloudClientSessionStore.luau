local function createCloudClientSessionStore()
	local set = {}

	return {
		isPlaceRefused = function(p2): boolean
			return set[p2] == true
		end,
		markPlaceRefused = function(p2)
			set[p2] = true
		end,
		reset = function()
			table.clear(set)
		end
	}
end

return createCloudClientSessionStore
