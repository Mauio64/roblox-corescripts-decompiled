local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useIsGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useIsGamepad
local module = require("@luauforge/deferred/hkg")
local module2 = require("@luauforge/bundled/dPH")
local module3 = require("@luauforge/bundled/dPN")

local function SortAggregationGroup(p2)
	local v5 = useLocalization({
		allTime = "Feature.Catalog.LabelAllTime",
		pastWeek = "Feature.Catalog.LabelPastWeek",
		pastDay = "Feature.Catalog.LabelPastDay"
	})

	local v6 = {
		{ text = v5.allTime, id = module2.AllTime },
		{ text = v5.pastWeek, id = module2.PastWeek },
		{ text = v5.pastDay, id = module2.PastDay }
	}

	local v7 = useIsGamepad()

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, module3.SortAndFiltersSmallRowHeight * #v6),
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}, {
		SortRadioButtons = React.createElement(module, {
			items = v6,
			hideDividers = true,
			itemHeight = module3.SortAndFiltersSmallRowHeight,
			selectedValue = p2.sortAggregation,
			onActivated = p2.setSortAggregation,
			useDefaultControlState = v7
		})
	})
end

return SortAggregationGroup
