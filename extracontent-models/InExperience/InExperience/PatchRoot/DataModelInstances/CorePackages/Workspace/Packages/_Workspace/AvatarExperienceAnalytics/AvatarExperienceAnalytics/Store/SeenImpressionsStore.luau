local t1 = {}

local function getOrCreateCategory(s1: string) -- line: 20
	-- upvalues: t1 (copy)
	if not t1[s1] then
		t1[s1] = {}
	end

	return t1[s1]
end

return {
	Category = {
		WidgetItems = "WidgetItems",
		UnifiedImpressions = "UnifiedImpressions"
	},
	hasSeen = function(s2: string, s3: string) -- line: 27
		-- upvalues: t1 (copy)
		local v6 = t1[s2]

		return v6 ~= nil and v6[s3] == true
	end,
	markSeen = function(s4: string, s5: string) -- line: 32
		-- upvalues: t1 (copy)
		if not t1[s4] then
			t1[s4] = {}
		end

		t1[s4][s5] = true
	end,
	clearCategory = function(s6: string) -- line: 36
		-- upvalues: t1 (copy)
		t1[s6] = nil
	end,
	clear = function() -- line: 40
		-- upvalues: t1 (copy)
		table.clear(t1)
	end
}
