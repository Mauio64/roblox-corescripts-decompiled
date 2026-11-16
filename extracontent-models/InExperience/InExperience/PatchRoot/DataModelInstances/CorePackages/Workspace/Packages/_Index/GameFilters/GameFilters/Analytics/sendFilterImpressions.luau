local GameFilters = script:FindFirstAncestor("GameFilters")

local parent = GameFilters.Parent
local ArgCheck = require(parent.ArgCheck)
require(parent.DiscoveryTypes)

local filterImpressionsEvent = require(GameFilters.Analytics.filterImpressionsEvent)
local getOptionContextTag = require(GameFilters.Analytics.getOptionContextTag)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppChartsFilterOptionTextTag = SharedFlags.FFlagLuaAppChartsFilterOptionTextTag

local function sendFilterImpressions(p, list, list2, p2: string, data)
	if not p or (not list or #list == 0) then
		return
	end

	if not list2 or #list2 == 0 then
		return
	end

	local v = {
		gameSetTypeId = data.gameSetTypeId,
		gameSetTargetId = data.gameSetTargetId,
		sortPos = data.sortPos
	}

	local v2 = FFlagLuaAppChartsFilterOptionTextTag and {} or nil
	local v3 = {}
	local filterIds = {}
	local selectedOptionIds = {}

	for _, item in list do
		local item2 = list2[item]

		if not item2 then
			continue
		end

		table.insert(v3, item)
		table.insert(filterIds, item2.filterId)
		table.insert(selectedOptionIds, item2.selectedOptionId)

		if FFlagLuaAppChartsFilterOptionTextTag then
			table.insert(v2, getOptionContextTag(item2, item2.selectedOptionId) or "0")
		end
	end

	local count = #filterIds
	ArgCheck.assert(count == #v3)
	ArgCheck.assert(count == #selectedOptionIds)

	if FFlagLuaAppChartsFilterOptionTextTag then
		ArgCheck.assert(count == #v2)
	end

	v.absPositions = table.concat(v3, ",")
	v.filterIds = table.concat(filterIds, ",")
	v.selectedOptionIds = table.concat(selectedOptionIds, ",")
	local selectedOptionContextTags

	if FFlagLuaAppChartsFilterOptionTextTag then
		selectedOptionContextTags = table.concat(v2, ",")
	end

	v.selectedOptionContextTags = selectedOptionContextTags

	filterImpressionsEvent(p, p2, v)
end

return sendFilterImpressions
