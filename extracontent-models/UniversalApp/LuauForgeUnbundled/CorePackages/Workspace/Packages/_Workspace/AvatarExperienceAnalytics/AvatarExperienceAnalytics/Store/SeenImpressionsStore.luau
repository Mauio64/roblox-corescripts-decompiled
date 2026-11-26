local v5 = {}

local function getOrCreateCategory(p2)
	if not v5[p2] then
		v5[p2] = {}
	end

	return v5[p2]
end

return {
	Category = {
		WidgetItems = "WidgetItems",
		UnifiedImpressions = "UnifiedImpressions"
	},
	hasSeen = function(p2, p3): boolean
		local v6 = v5[p2]
		return v6 ~= nil and v6[p3] == true
	end,
	markSeen = function(p2, p3)
		if not v5[p2] then
			v5[p2] = {}
		end

		v5[p2][p3] = true
	end,
	clearCategory = function(p2)
		v5[p2] = nil
	end,
	clear = function()
		table.clear(v5)
	end
}
