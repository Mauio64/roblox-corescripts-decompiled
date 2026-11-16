local function createCloudClientSessionStore()
	local set = {}

	return {
		isPlaceRefused = function(p: string): boolean
			return set[p] == true
		end,
		markPlaceRefused = function(p: string)
			set[p] = true
		end,
		reset = function()
			table.clear(set)
		end
	}
end

return createCloudClientSessionStore
