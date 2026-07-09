local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local InventorySorts = AvatarExperienceSlotBasedEditor.Enums.InventorySorts

require(CorePackages.Workspace.Packages.AppCommonLib)

local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local InventoryFilters = AvatarExperienceSlotBasedEditor.Enums.InventoryFilters
local FilterSection = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterSection)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local RadioButtonGroup = require(Modules.AvatarExperience.Catalog.Components.Filters.RadioButtonGroup)
local FormPeekview = require(Modules.AvatarExperience.Common.Components.FormPeekview)
local FFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter

local function InventorySortAndFilters(t1: {[any]: any}) -- line: 41
	-- upvalues: useLocalization (copy), FFlagAXInventoryDurablesExpiredFilter (copy), InventorySorts (copy), InventoryFilters (copy), React (copy), FormPeekview (copy), FilterSection (copy), RadioButtonGroup (copy), Constants (copy)
	local v16 = useLocalization({
		newest = "Feature.Avatar.Label.Newest",
		recentlyWorn = "Feature.Avatar.Label.RecentlyWorn",
		sortBy = if not FFlagAXInventoryDurablesExpiredFilter then nil else "Feature.Avatar.Heading.SortBy",
		filter = if not FFlagAXInventoryDurablesExpiredFilter then nil else "Feature.Avatar.Heading.Filter",
		activeItems = if not FFlagAXInventoryDurablesExpiredFilter then nil else "Feature.Avatar.Heading.Active",
		expiredItems = if not FFlagAXInventoryDurablesExpiredFilter then nil else "Feature.Avatar.Heading.Expired"
	})
	local t2 = {
		{
			text = v16.newest,
			id = InventorySorts.Newest
		},
		{
			text = v16.recentlyWorn,
			id = InventorySorts.RecentlyWorn
		}
	}
	local v18 = if not FFlagAXInventoryDurablesExpiredFilter then nil else {
		{
			text = v16.activeItems,
			id = InventoryFilters.Active
		},
		{
			text = v16.expiredItems,
			id = InventoryFilters.Expired
		}
	}

	return React.createElement(FormPeekview, {
		useAutomaticSize = true,
		canApply = t1.canApply,
		canReset = t1.canReset,
		onApply = t1.onApply,
		onReset = t1.onReset,
		closePeekViewSignal = t1.closePeekViewSignal,
		totalSize = UDim2.fromScale(1, 0)
	}, {
		SortsSection = React.createElement(FilterSection, {
			title = not FFlagAXInventoryDurablesExpiredFilter and "Sort by" or v16.sortBy,
			Size = UDim2.fromScale(1, 0),
			contentSize = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			RadioButtons = React.createElement(RadioButtonGroup, {
				items = t2,
				itemHeight = Constants.SortAndFiltersRowHeight,
				selectedValue = t1.currentSort,
				onActivated = t1.setCurrentSort
			})
		}),
		FiltersSection = if not FFlagAXInventoryDurablesExpiredFilter then nil else React.createElement(FilterSection, {
			title = v16.filter,
			Size = UDim2.fromScale(1, 0),
			contentSize = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			RadioButtons = React.createElement(RadioButtonGroup, {
				items = v18,
				itemHeight = Constants.SortAndFiltersRowHeight,
				selectedValue = t1.currentFilter,
				onActivated = t1.setCurrentFilter
			})
		})
	})
end

return InventorySortAndFilters
