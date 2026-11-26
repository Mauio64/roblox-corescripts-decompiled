local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/fCn")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local inventorySorts = module.Enums.InventorySorts
require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local inventoryFilters = module.Enums.InventoryFilters

local module3 = require("@luauforge/deferred/hkd")
local module4 = require("@luauforge/bundled/dPN")
local module5 = require("@luauforge/deferred/hkg")

local module6 = require("@luauforge/deferred/hjX")
local fFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter

local function InventorySortAndFilters(props)
	local v5 = useLocalization({
		sortBy = fFlagAXInventoryDurablesExpiredFilter and "Feature.Avatar.Heading.SortBy" or nil,
		filter = fFlagAXInventoryDurablesExpiredFilter and "Feature.Avatar.Heading.Filter" or nil,
		newest = "Feature.Avatar.Label.Newest",
		recentlyWorn = "Feature.Avatar.Label.RecentlyWorn",
		activeItems = fFlagAXInventoryDurablesExpiredFilter and "Feature.Avatar.Heading.Active" or nil,
		expiredItems = fFlagAXInventoryDurablesExpiredFilter and "Feature.Avatar.Heading.Expired" or nil
	})

	local v6 = {
		{ text = v5.newest, id = inventorySorts.Newest },
		{ text = v5.recentlyWorn, id = inventorySorts.RecentlyWorn }
	}

	local v7 = fFlagAXInventoryDurablesExpiredFilter and {
		{ text = v5.activeItems, id = inventoryFilters.Active },
		{ text = v5.expiredItems, id = inventoryFilters.Expired }
	} or nil

	local createElement = React.createElement
	local v9 = {
		canApply = props.canApply,
		canReset = props.canReset,
		onApply = props.onApply,
		onReset = props.onReset,
		closePeekViewSignal = props.closePeekViewSignal,
		totalSize = UDim2.fromScale(1, 0),
		useAutomaticSize = true
	}

	local v10 = {
		SortsSection = React.createElement(module3, {
			title = not fFlagAXInventoryDurablesExpiredFilter and "Sort by" or v5.sortBy,
			Size = UDim2.fromScale(1, 0),
			contentSize = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			RadioButtons = React.createElement(module5, {
				items = v6,
				itemHeight = module4.SortAndFiltersRowHeight,
				selectedValue = props.currentSort,
				onActivated = props.setCurrentSort
			})
		}),
		FiltersSection = 0
	}

	local v11 = if fFlagAXInventoryDurablesExpiredFilter then React.createElement(
		module3,
		{
			title = v5.filter,
			Size = UDim2.fromScale(1, 0),
			contentSize = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		},
		{
			RadioButtons = React.createElement(module5, {
				items = v7,
				itemHeight = module4.SortAndFiltersRowHeight,
				selectedValue = props.currentFilter,
				onActivated = props.setCurrentFilter
			})
		}
	) else nil
	v10.FiltersSection = v11
	return createElement(module6, v9, v10)
end

return InventorySortAndFilters
