local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useIsGamepad = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useIsGamepad
local RadioButtonGroup = require(Modules.AvatarExperience.Catalog.Components.Filters.RadioButtonGroup)
local SortAggregation = require(Modules.AvatarExperience.Common.Enum.SortAggregation)
local Constants = require(Modules.AvatarExperience.Common.Constants)

local function SortAggregationGroup(t1: {[any]: any}) -- line: 26
	-- upvalues: useLocalization (copy), SortAggregation (copy), useIsGamepad (copy), React (copy), Constants (copy), RadioButtonGroup (copy)
	local v11 = useLocalization({
		allTime = "Feature.Catalog.LabelAllTime",
		pastWeek = "Feature.Catalog.LabelPastWeek",
		pastDay = "Feature.Catalog.LabelPastDay"
	})
	local t2 = {
		{
			text = v11.allTime,
			id = SortAggregation.AllTime
		},
		{
			text = v11.pastWeek,
			id = SortAggregation.PastWeek
		},
		{
			text = v11.pastDay,
			id = SortAggregation.PastDay
		}
	}
	local v13 = useIsGamepad()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, Constants.SortAndFiltersSmallRowHeight * #t2)
	}, {
		SortRadioButtons = React.createElement(RadioButtonGroup, {
			hideDividers = true,
			items = t2,
			itemHeight = Constants.SortAndFiltersSmallRowHeight,
			selectedValue = t1.sortAggregation,
			onActivated = t1.setSortAggregation,
			useDefaultControlState = v13
		})
	})
end

return SortAggregationGroup
