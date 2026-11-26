local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/ArgCheck")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/DiscoveryTypes")

local filterImpressionsEvent = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Analytics/filterImpressionsEvent")
local getOptionContextTag = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/GameFilters/Analytics/getOptionContextTag")

local fFlagLuaAppChartsFilterOptionTextTag = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/SharedFlags").FFlagLuaAppChartsFilterOptionTextTag

local function sendFilterImpressions(p2, list, list2, p3, data)
	if not p2 or (not list or #list == 0) then
		return
	end

	if not list2 or #list2 == 0 then
		return
	end

	local v5 = {
		gameSetTypeId = data.gameSetTypeId,
		gameSetTargetId = data.gameSetTargetId,
		sortPos = data.sortPos
	}

	local v6 = fFlagLuaAppChartsFilterOptionTextTag and {} or nil
	local v7 = {}
	local filterIds = {}
	local selectedOptionIds = {}

	for k, item in list do
		local item2 = list2[item]

		if not item2 then
			continue
		end

		table.insert(v7, item)
		table.insert(filterIds, item2.filterId)
		table.insert(selectedOptionIds, item2.selectedOptionId)

		if fFlagLuaAppChartsFilterOptionTextTag then
			table.insert(v6, getOptionContextTag(item2, item2.selectedOptionId) or "0")
		end
	end

	local count = #filterIds
	ArgCheck.assert(count == #v7)
	ArgCheck.assert(count == #selectedOptionIds)

	if fFlagLuaAppChartsFilterOptionTextTag then
		ArgCheck.assert(count == #v6)
	end

	v5.absPositions = table.concat(v7, ",")
	v5.filterIds = table.concat(filterIds, ",")
	v5.selectedOptionIds = table.concat(selectedOptionIds, ",")

	local v8 = if fFlagLuaAppChartsFilterOptionTextTag then table.concat(v6, ",") else nil
	v5.selectedOptionContextTags = v8

	filterImpressionsEvent(p2, p3, v5)
end

return sendFilterImpressions
