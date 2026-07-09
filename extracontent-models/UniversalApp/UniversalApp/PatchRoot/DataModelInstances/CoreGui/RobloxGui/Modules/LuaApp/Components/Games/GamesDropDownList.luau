local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local TopicInfosReducer = require(CorePackages.Workspace.Packages.TopicInfosRodux).TopicInfosReducer
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local OmniFeedTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes).OmniFeedTypes
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local DropDownList = require(Modules.LuaApp.Components.DropDownList)
local isSduiGameOmniFeedItem = require(CorePackages.Workspace.Packages.ServerDrivenUi).isSduiGameOmniFeedItem
local v10 = Roact.PureComponent:extend("GamesDropDownList")

function v10.init(p1) -- line: 30
	p1.state = {}

	function p1.dropDownSelectedCallback(p2, p3) -- line: 33
		-- upvalues: p1 (copy)
		if p1.props.onSelected then
			local items = p1.props.items
			local dropdownPositionToStoreIndex = p1.props.dropdownPositionToStoreIndex

			assert(dropdownPositionToStoreIndex)

			if p3 <= #items then
				local v43 = dropdownPositionToStoreIndex[p3]

				if v43 then
					return p1.props.onSelected(p2, v43, p3)
				end
			end
		end
	end
end
function v10.render(p4) -- line: 49
	-- upvalues: Roact (copy), DropDownList (copy)
	local items = p4.props.items
	local itemSelected = p4.props.itemSelected
	local position = p4.props.position
	local size = p4.props.size

	return Roact.createElement(DropDownList, {
		position = position,
		size = size,
		items = items,
		itemSelected = itemSelected,
		onSelected = p4.dropDownSelectedCallback
	})
end

local v11 = memoize(function(p5, p6, p7, p8) -- line: 65
	-- upvalues: OmniFeedTypes (copy), isSduiGameOmniFeedItem (copy)
	local t1 = {}
	local t2 = {}

	local function addSortToResult(p9, p10) -- line: 69
		-- upvalues: t1 (copy), t2 (copy)
		table.insert(t1, p9)
		t2[#t1] = p10
	end

	for _, v in pairs(p8) do
		if v.isOmni then
			for i, v2 in ipairs(p7) do
				local v29 = p5[v2.topicId]

				if v29.treatmentType == OmniFeedTypes.Carousel or isSduiGameOmniFeedItem(v29.treatmentType, v29.topicId) then
					table.insert(t1, v29)
					t2[#t1] = i
				end
			end
		else
			for i, v3 in ipairs(p6[v.sortType].sorts) do
				table.insert(t1, p5[v3])
				t2[#t1] = i
			end
		end
	end

	return t1, t2
end)

return RoactRodux.connect(function(p11, p12) -- line: 96
	-- upvalues: TopicInfosReducer (copy), v11 (copy)
	local v34 = p11.Personalization[TopicInfosReducer.key][p12.selectedSortName]
	local t3 = {}

	if p12.isOmni then
		local sortType = p12.sortCategories.OMNI_HOME.sortType

		if p11.OmniRecommendations and p11.OmniRecommendations[sortType] then
			t3 = p11.OmniRecommendations[sortType].sorts or {}
		end
	end

	local v37, v38 = v11(p11.Personalization[TopicInfosReducer.key], p11.GameSortGroups, t3, p12.sortCategories)

	return {
		items = v37 or {},
		itemSelected = v34 or {},
		dropdownPositionToStoreIndex = v38
	}
end)(v10)
