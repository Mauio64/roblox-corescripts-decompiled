local GameFilters = script:FindFirstAncestor("GameFilters")
local GameFiltersParent = GameFilters.Parent
local ArgCheck = require(GameFiltersParent.ArgCheck)

require(GameFiltersParent.DiscoveryTypes)

local filterImpressionsEvent = require(GameFilters.Analytics.filterImpressionsEvent)
local getOptionContextTag = require(GameFilters.Analytics.getOptionContextTag)
local FFlagLuaAppChartsFilterOptionTextTag = require(GameFiltersParent.SharedFlags).FFlagLuaAppChartsFilterOptionTextTag

local function sendFilterImpressions(p1, t1: {[any]: any}, t2: {[any]: any}, s1: string, p2) -- line: 12
	-- upvalues: FFlagLuaAppChartsFilterOptionTextTag (copy), getOptionContextTag (copy), ArgCheck (copy), filterImpressionsEvent (copy)
	if not p1 then
		return
	end

	if not t1 or #t1 == 0 then
		return
	end

	if not t2 or #t2 == 0 then
		return
	end

	local t3 = {
		gameSetTypeId = p2.gameSetTypeId,
		gameSetTargetId = p2.gameSetTargetId,
		sortPos = p2.sortPos
	}
	local t4 = {}
	local t5 = {}
	local t6 = {}
	local v17 = if not FFlagLuaAppChartsFilterOptionTextTag then nil else {}

	for _, v19 in t1 do
		local v20 = t2[v19]

		if v20 then
			table.insert(t4, v19)
			table.insert(t5, v20.filterId)
			table.insert(t6, v20.selectedOptionId)

			if FFlagLuaAppChartsFilterOptionTextTag then
				table.insert(v17, getOptionContextTag(v20, v20.selectedOptionId) or "0")
			end
		end
	end

	local v21 = #t5

	ArgCheck.assert(v21 == #t4)
	ArgCheck.assert(v21 == #t6)

	if FFlagLuaAppChartsFilterOptionTextTag then
		ArgCheck.assert(v21 == #v17)
	end

	t3.absPositions = table.concat(t4, ",")
	t3.filterIds = table.concat(t5, ",")
	t3.selectedOptionIds = table.concat(t6, ",")
	t3.selectedOptionContextTags = if not FFlagLuaAppChartsFilterOptionTextTag then nil else table.concat(v17, ",")
	filterImpressionsEvent(p1, s1, t3)
end

return sendFilterImpressions
