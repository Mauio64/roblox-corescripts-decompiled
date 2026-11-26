local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")
local module2 = require("@luauforge/bundled/fxu")
local module3 = require("@luauforge/bundled/fxp")
local useTokens = require("@luauforge/bundled/fxq").Hooks.useTokens
local module4 = require("@luauforge/bundled/fxJ")

local gridMetrics = module3.App.Grid.GridMetrics

require("@luauforge/bundled/fxD")
local module5 = require("@luauforge/bundled/fxK")

local module6 = require("@luauforge/bundled/fxM")

require("@luauforge/bundled/fxT")

local axRecentlyViewedSearchItemsIXPTest = module2.Experiments.AXRecentlyViewedSearchItemsIXPTest

local function SearchLandingPageWidgets(props)
	local v5 = useTokens()
	local state, setState = React.useState(0)

	local v6 = React.useRef(nil)
	local v7 = React.useRef(nil)

	local v8 = React.useMemo(function()
		return gridMetrics.getSmallMetrics(math.max(state - v5.Size.Size_400 * 2, 0), v5.Size.Size_250)
	end, { state })

	local function fn(p2)
		setState(p2.AbsoluteSize.X)
	end

	local testVariable = module4.readTestVariable(axRecentlyViewedSearchItemsIXPTest.EnabledForUser)
	local v9, v10

	if testVariable and module4.readTestVariable(axRecentlyViewedSearchItemsIXPTest.EnabledTopVariant) then
		v9 = 2
		v10 = 1
	else
		v9 = 1
		v10 = 2
	end

	local createElement = React.createElement
	local v12 = {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		CanvasSize = UDim2.fromScale(1, 1),
		Size = UDim2.fromScale(1, 1),
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		[React.Change.AbsoluteSize] = fn
	}
	local v13 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v5.Size.Size_600)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v5.Size.Size_1200)
		}),
		RecentSearchTermsWidget = 0,
		RecentlyViewedSearchItemsWidget = 0
	}
	local v14

	if #props.suggestedSearchTerms > 0 then
		local createElement2 = React.createElement
		local v16 = {
			hasQuery = props.hasQuery,
			items = props.suggestedSearchTerms,
			firstSuggestedItemRef = 0,
			searchBarRef = 0,
			LayoutOrder = 0
		}
		local v17 = if v9 == 1 then props.firstSuggestedItemRef else v6
		v16.firstSuggestedItemRef = v17

		v16.searchBarRef = props.searchBarRef
		v16.LayoutOrder = v9
		v14 = createElement2(module5, v16)
	end

	v13.RecentSearchTermsWidget = v14
	local v15

	if
		testVariable
		and not props.hasQuery
		and props.recentlyViewedItems
		and #props.recentlyViewedItems > 0
	then
		local createElement2 = React.createElement
		local v17 = {
			items = props.recentlyViewedItems,
			firstSuggestedItemRef = 0,
			nextSelectionDown = 0,
			nextSelectionUp = 0,
			itemWidth = 0,
			itemsPerRow = 0,
			LayoutOrder = 0
		}

		if v10 == 1 then
			v7 = props.firstSuggestedItemRef
		end

		v17.firstSuggestedItemRef = v7

		local v18 = if v10 == 1 then v6 else props.searchBarRef
		v17.nextSelectionDown = v18

		if v10 == 1 then
			v6 = props.searchBarRef
		end

		v17.nextSelectionUp = v6

		v17.itemWidth = v8.itemWidth
		v17.itemsPerRow = v8.itemsPerRow
		v17.LayoutOrder = v10
		v15 = createElement2(module6, v17)
	end

	v13.RecentlyViewedSearchItemsWidget = v15
	return createElement("ScrollingFrame", v12, v13)
end

return SearchLandingPageWidgets
