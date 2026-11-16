local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
require("@luauforge/deferred/gYc")
local useIsGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useIsGamepad
local module = require("@luauforge/deferred/gXU")
local module2 = require("@luauforge/deferred/gYd")
local module3 = require("@luauforge/bundled/dMq")
local module4 = require("@luauforge/bundled/dMx")
local module5 = require("@luauforge/bundled/dME")
local module6 = require("@luauforge/bundled/fuL")
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable

local udim = UDim.new(0, 12)

local v5 = 6 + module4.SortAndFiltersSmallRowHeight * 3

local function getTotalHeight(p2)
	return p2 + udim.Offset * 2
end

local function Sorts(props)
	local sortsController = props.sortsController

	local v6 = useLocalization(module5.SortTypeLocalization)

	local recentlyCreated = module3.RecentlyCreated

	local v7 = {
		{ text = v6.Relevance, id = module3.Relevance },
		{
			text = v6.MostFavorited,
			id = module3.MostFavorited,
			expandedViewHeight = v5,
			expandedView = React.createElement(module2, {
				sortAggregation = sortsController.mostFavoritedAggregation,
				setSortAggregation = sortsController.setMostFavoritedAggregation
			})
		},
		{
			text = v6.Bestselling,
			id = module3.Bestselling,
			expandedViewHeight = v5,
			expandedView = React.createElement(module2, {
				sortAggregation = sortsController.bestSellingAggregation,
				setSortAggregation = sortsController.setBestSellingAggregation
			})
		},
		{ text = v6[recentlyCreated], id = recentlyCreated },
		{ text = v6.PriceLowToHigh, id = module3.PriceLowToHigh },
		{ text = v6.PriceHighToLow, id = module3.PriceHighToLow }
	}

	local v8 = useIsGamepad()

	local v9, v10 = React.useBinding(0)

	local function onHeightChanged(p2)
		v10(p2)

		if props.onHeightChanged then
			props.onHeightChanged(p2 + udim.Offset * 2)
		end
	end

	return React.createElement(focusable.Frame, {
		Size = v9:map(function(p2)
			return UDim2.new(1, 0, 0, p2 + udim.Offset * 2)
		end),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ref = props.frameRef,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = udim
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = udim,
			PaddingBottom = udim,
			PaddingLeft = udim
		}),
		RadioButtonGroupContainer = React.createElement(
			"Frame",
			{
				Size = v9:map(module6.mapHeightToSize),
				BackgroundTransparency = 1,
				LayoutOrder = 2
			},
			{
				SortRadioButtons = React.createElement(module, {
					items = v7,
					itemHeight = module4.SortAndFiltersRowHeight,
					selectedValue = sortsController.sortType,
					onActivated = function(p2)
						sortsController.setSortType(p2)
					end,
					useDefaultControlState = v8,
					onHeightChanged = onHeightChanged
				})
			}
		)
	})
end

return Sorts
