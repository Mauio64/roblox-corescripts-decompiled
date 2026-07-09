local ArgCheck = require(script.Parent.ArgCheck)
local t1 = {
	minimumCardCount = 2,
	minimumCardWidth = 160
}
local t2 = {
	minimumCardCount = 1,
	minimumCardWidth = 330
}

local function getGridLayoutSettingsHelper(p1, p2, p3) -- line: 18
	-- upvalues: ArgCheck (copy)
	ArgCheck.isNonNegativeNumber(p1, "GetGridLayoutSettings: containerWidth")
	ArgCheck.isNonNegativeNumber(p2, "GetGridLayoutSettings: cardPadding")
	ArgCheck.isType(p3, "table", "GetGridLayoutSettings: settingsTable")

	local v8 = math.floor((p1 + p2) / (p3.minimumCardWidth + p2))
	local v9 = math.max(p3.minimumCardCount, v8)

	return v9, (math.floor((p1 - (v9 - 1) * p2) / v9))
end

return {
	Small = function(p4, p5) -- line: 36
		-- upvalues: getGridLayoutSettingsHelper (copy), t1 (copy)
		local v12, _ = getGridLayoutSettingsHelper(p4, p5, t1)
		local v14 = v12 + 1

		return v14, (math.floor((p4 - (v14 - 1) * p5) / v14))
	end,
	Medium = function(p6, p7) -- line: 48
		-- upvalues: getGridLayoutSettingsHelper (copy), t1 (copy)
		return getGridLayoutSettingsHelper(p6, p7, t1)
	end,
	Large = function(p8, p9) -- line: 52
		-- upvalues: getGridLayoutSettingsHelper (copy), t2 (copy)
		return getGridLayoutSettingsHelper(p8, p9, t2)
	end
}
