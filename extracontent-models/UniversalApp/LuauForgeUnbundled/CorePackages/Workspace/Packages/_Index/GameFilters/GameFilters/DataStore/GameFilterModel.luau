local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/GameFilters/ArgCheck")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/DiscoveryTypes")
local fFlagLuaAppChartsFilterOptionTextTag = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/SharedFlags").FFlagLuaAppChartsFilterOptionTextTag

local v5 = {}

function v5.new()
	return {}
end

function v5.mockFromExploreApi(p2, value)
	local fromExploreJsonData = v5.fromExploreJsonData

	local v8 = {
		optionId = p2 .. "_option",
		optionDisplayName = "",
		optionContextTag = 0
	}

	local v9 = if fFlagLuaAppChartsFilterOptionTextTag then p2 .. "_context" else nil
	v8.optionContextTag = v9
	local v10 = fromExploreJsonData({
		filterId = p2,
		filterType = "",
		filterDisplayName = "",
		filterOptions = { v8 },
		defaultOptionId = p2 .. "_option",
		selectedOptionId = p2 .. "_option",
		inactiveOptionIds = { p2 .. "_option" }
	})

	v10.selectedOptionDisplayName = value or ""

	return v10
end

function v5.fromExploreJsonData(data)
	local result = v5.new()

	result.filterId = data.filterId
	result.filterType = data.filterType
	result.filterDisplayName = data.filterDisplayName
	result.defaultOptionId = data.defaultOptionId
	result.selectedOptionId = data.selectedOptionId

	if data.inactiveOptionIds then
		local inactiveOptionIdSet = {}

		for k, inactiveOptionId in data.inactiveOptionIds do
			inactiveOptionIdSet[inactiveOptionId] = true
		end

		result.inactiveOptionIds = inactiveOptionIdSet
	end

	local v6 = {}

	for i, filterOption in ipairs(data.filterOptions) do
		local v7 = {
			optionId = filterOption.optionId,
			optionDisplayName = filterOption.optionDisplayName,
			optionContextTag = 0
		}
		local v8 = if fFlagLuaAppChartsFilterOptionTextTag then filterOption.optionContextTag else nil
		v7.optionContextTag = v8

		table.insert(v6, v7)

		if filterOption.optionId ~= data.selectedOptionId then
			continue
		end

		ArgCheck.assert(result.selectedOptionDisplayName == nil, "Multiple selected options found")

		result.selectedOptionDisplayName = filterOption.optionDisplayName
	end

	result.filterOptions = v6

	return result
end

return v5
