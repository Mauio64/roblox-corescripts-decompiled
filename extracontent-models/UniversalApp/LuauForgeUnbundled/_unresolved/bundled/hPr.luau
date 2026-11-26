local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local topicInfosReducer = require("@luauforge/bundled/dCQ").TopicInfosReducer
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize

local omniFeedTypes = require("@luauforge/bundled/cBc").OmniFeedTypes

local module = require("@luauforge/bundled/hPs")

local isSduiGameOmniFeedItem = require("@luauforge/bundled/dDZ").isSduiGameOmniFeedItem

local fFlagLuaAppEnableSduiHomePage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEnableSduiHomePage

local extended = Roact.PureComponent:extend("GamesDropDownList")

function extended:init()
	self.state = {}

	function self.dropDownSelectedCallback(p3, p4)
		if self.props.onSelected then
			local items = self.props.items
			local dropdownPositionToStoreIndex = self.props.dropdownPositionToStoreIndex
			assert(dropdownPositionToStoreIndex)

			local v5 = p4 <= #items and dropdownPositionToStoreIndex[p4]

			if v5 then
				return self.props.onSelected(p3, v5, p4)
			end
		end
	end
end

function extended.render(p2)
	local items = p2.props.items
	local itemSelected = p2.props.itemSelected
	local position = p2.props.position
	local size = p2.props.size

	return Roact.createElement(module, {
		position = position,
		size = size,
		items = items,
		itemSelected = itemSelected,
		onSelected = p2.dropDownSelectedCallback
	})
end

local v5 = memoize(function(p2, p3, list, items, options)
	local result = {}
	local result2 = {}

	local function addSortToResult(p4, p5)
		table.insert(result, p4)
		result2[#result] = p5
	end

	for k, item in pairs(items) do
		if item.isOmni then
			if fFlagLuaAppEnableSduiHomePage then
				for k2, v6 in options or {} do
					local storeIndex = v6.storeIndex
					table.insert(result, v6)
					result2[#result] = storeIndex
				end
			else
				for i, item2 in ipairs(list) do
					local v6 = p2[item2.topicId]

					if not (v6 ~= nil and (v6.treatmentType == omniFeedTypes.Carousel or isSduiGameOmniFeedItem(v6.treatmentType, v6.topicId))) then
						continue
					end

					table.insert(result, v6)
					result2[#result] = i
				end
			end
		else
			for i, sort in ipairs(p3[item.sortType].sorts) do
				table.insert(result, p2[sort])
				result2[#result] = i
			end
		end
	end

	return result, result2
end)

local v6 = {}
return RoactRodux.connect(function(data, data2)
	local v7 = nil
	local v8 = data.Personalization[topicInfosReducer.key][data2.selectedSortName]
	local v9 = {}

	if fFlagLuaAppEnableSduiHomePage then
		v7 = if data2.isOmni or data2.includeOmniSorts then data2.omniSortOptions or v6 else v6

		for k, v11 in v7 do
			if
				data2.selectedSortIndex ~= nil and v11.storeIndex == data2.selectedSortIndex
				or data2.selectedSortIndex == nil and v11.topicId == data2.selectedSortName
			then
				v8 = v11
				break
			end
		end
	elseif data2.isOmni or data2.includeOmniSorts then
		local sortType = data2.sortCategories.OMNI_HOME.sortType

		if data.OmniRecommendations and data.OmniRecommendations[sortType] then
			v9 = data.OmniRecommendations[sortType].sorts or {}
		end
	end

	local v10, v11 = v5(
		data.Personalization[topicInfosReducer.key],
		data.GameSortGroups,
		v9,
		data2.sortCategories,
		v7
	)

	return {
		items = v10 or {},
		itemSelected = v8 or {},
		dropdownPositionToStoreIndex = v11
	}
end)(extended)
