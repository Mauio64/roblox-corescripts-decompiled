local parent = script:FindFirstAncestor("GameFilters").Parent
local ArgCheck = require(parent.ArgCheck)
require(parent.DiscoveryTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppChartsFilterOptionTextTag = SharedFlags.FFlagLuaAppChartsFilterOptionTextTag

local GameFilterModel = {}

function GameFilterModel.new()
	return {}
end

function GameFilterModel.mockFromExploreApi(filterId: string, value: string?)
	local fromExploreJsonData = GameFilterModel.fromExploreJsonData

	local v = {
		optionId = filterId .. "_option",
		optionDisplayName = "",
		optionContextTag = 0
	}
	local optionContextTag

	if FFlagLuaAppChartsFilterOptionTextTag then
		optionContextTag = filterId .. "_context"
	end

	v.optionContextTag = optionContextTag
	local v2 = fromExploreJsonData({
		filterId = filterId,
		filterType = "",
		filterDisplayName = "",
		filterOptions = { v },
		defaultOptionId = filterId .. "_option",
		selectedOptionId = filterId .. "_option",
		inactiveOptionIds = { filterId .. "_option" }
	})

	v2.selectedOptionDisplayName = value or ""

	return v2
end

function GameFilterModel.fromExploreJsonData(data)
	local result = GameFilterModel.new()

	result.filterId = data.filterId
	result.filterType = data.filterType
	result.filterDisplayName = data.filterDisplayName
	result.defaultOptionId = data.defaultOptionId
	result.selectedOptionId = data.selectedOptionId

	if data.inactiveOptionIds then
		local inactiveOptionIdSet = {}

		for _, inactiveOptionId in data.inactiveOptionIds do
			inactiveOptionIdSet[inactiveOptionId] = true
		end

		result.inactiveOptionIds = inactiveOptionIdSet
	end

	local filterOptions = {}

	for _, filterOption in ipairs(data.filterOptions) do
		local v = {
			optionId = filterOption.optionId,
			optionDisplayName = filterOption.optionDisplayName,
			optionContextTag = 0
		}
		local optionContextTag

		if FFlagLuaAppChartsFilterOptionTextTag then
			optionContextTag = filterOption.optionContextTag
		end

		v.optionContextTag = optionContextTag

		table.insert(filterOptions, v)

		if filterOption.optionId ~= data.selectedOptionId then
			continue
		end

		ArgCheck.assert(result.selectedOptionDisplayName == nil, "Multiple selected options found")

		result.selectedOptionDisplayName = filterOption.optionDisplayName
	end

	result.filterOptions = filterOptions

	return result
end

return GameFilterModel
