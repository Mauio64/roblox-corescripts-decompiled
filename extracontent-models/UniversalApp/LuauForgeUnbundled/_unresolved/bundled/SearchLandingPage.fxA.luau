local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/Style").useDesignTokens
local module2 = require("@luauforge/bundled/fxu")
local useNavigationFocus = require("@luauforge/bundled/fxB").useNavigationFocus
local fFlagAXAddSearchTrendingChips = require("@luauforge/bundled/fxm").FFlagAXAddSearchTrendingChips
local module3 = require("@luauforge/bundled/fxC")

local fFlagAXUnifiedAutocompleteExposureLogging = require("@luauforge/bundled/fxm").FFlagAXUnifiedAutocompleteExposureLogging

local module4 = require("@luauforge/bundled/fxv")
local module5 = require("@luauforge/bundled/fxn")
local module6 = require("@luauforge/bundled/fxx")
local module7 = require("@luauforge/bundled/fxD")
local module8 = require("@luauforge/bundled/fxH")

local module9 = require("@luauforge/bundled/fxI")

local module10 = require("@luauforge/bundled/fyb")

local axRecentlyViewedSearchItemsIXPTest = module2.Experiments.AXRecentlyViewedSearchItemsIXPTest

local function mapTokens(p2)
	local v5 = {
		backgroundColor = p2.Color.Surface.Surface_0.Color3,
		backgroundTransparency = p2.Color.Surface.Surface_0.Transparency,
		itemListPadding = p2.Size.Size_400,
		searchBarPadding = 0,
		emptyStatePadding = 0,
		spaceBetweenSearchAndList = 0
	}
	local v6 = if axRecentlyViewedSearchItemsIXPTest.isEnabled() then p2.Size.Size_400 else p2.Size.Size_300
	v5.searchBarPadding = v6

	v5.emptyStatePadding = p2.Size.Size_1000
	v5.spaceBetweenSearchAndList = p2.Size.Size_200
	return v5
end

local function SearchLandingPage(props)
	local v5 = useDesignTokens(mapTokens)

	if axRecentlyViewedSearchItemsIXPTest.isEnabled() then
		local v6 = useNavigationFocus()

		React.useEffect(function()
			if v6 and props.searchBarRef and props.searchBarRef.current then
				props.searchBarRef.current:CaptureFocus()
			end
		end, { v6 })
	end

	local v6 = #props.suggestedSearchTerms > 0

	local v7 = fFlagAXAddSearchTrendingChips

	if module3 then
		v7 = v7 and not props.hasQuery
	end

	local createElement = React.createElement
	local v9 = {
		BorderSizePixel = 0,
		BackgroundColor3 = v5.backgroundColor,
		BackgroundTransparency = v5.backgroundTransparency,
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.XY,
		margin = 0,
		padding = props.padding,
		flexDirection = Enum.FillDirection.Vertical,
		reverse = true,
		rigidSlot = 0,
		flexSlot = 0
	}

	local createElement2 = React.createElement
	local v11 = {
		Size = UDim2.fromScale(1, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = 0
	}

	local v12 = {
		SearchBarFramePadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.searchBarPadding),
			PaddingBottom = UDim.new(0, v5.searchBarPadding),
			PaddingLeft = UDim.new(0, v5.searchBarPadding),
			PaddingRight = UDim.new(0, v5.searchBarPadding)
		}),
		Layout = 0,
		SearchBar = 0,
		SearchViewExposureLogger = 0,
		TrendingSearchTermsWidget = 0
	}

	local v13 = if fFlagAXAddSearchTrendingChips then React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, v5.spaceBetweenSearchAndList)
	}) else nil
	v12.Layout = v13

	v12.SearchBar = React.createElement(module5, {
		showCancelButton = true,
		autofocus = true,
		onCancel = props.onCancelSearch,
		onClear = props.onClearSearch,
		onChange = props.onChangeSearchQuery,
		onSubmit = props.onSubmitSearch,
		ref = props.searchBarRef,
		nextSelectionDown = props.firstSuggestedItemRef
	})

	local v14 = if fFlagAXUnifiedAutocompleteExposureLogging then React.createElement(module6) else nil
	v12.SearchViewExposureLogger = v14

	local v15 = if v7 then React.createElement(module10, {
		onSubmitSearch = props.onSubmitSearch,
		LayoutOrder = 1
	}) else nil
	v12.TrendingSearchTermsWidget = v15
	v9.rigidSlot = createElement2("Frame", v11, v12)
	local v16

	if axRecentlyViewedSearchItemsIXPTest.isEnabled() or not v6 then
		if props.shouldShowEmptyState then
			v16 = React.createElement(
				"Frame",
				{
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Size = UDim2.fromScale(1, 0)
				},
				{
					EmptyStatePadding = React.createElement("UIPadding", {
						PaddingTop = UDim.new(0, v5.emptyStatePadding),
						PaddingLeft = UDim.new(0, v5.emptyStatePadding),
						PaddingRight = UDim.new(0, v5.emptyStatePadding)
					}),
					SearchEmptyState = React.createElement(module8)
				}
			)
		elseif axRecentlyViewedSearchItemsIXPTest.isEnabled() then
			v16 = React.createElement(module9, {
				hasQuery = props.hasQuery,
				suggestedSearchTerms = props.suggestedSearchTerms,
				recentlyViewedItems = props.recentlyViewedItems,
				searchBarRef = props.searchBarRef,
				firstSuggestedItemRef = props.firstSuggestedItemRef
			})
		end
	else
		v16 = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.fromScale(1, 1),
			LayoutOrder = 1
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v5.itemListPadding),
				PaddingRight = UDim.new(0, v5.itemListPadding)
			}),
			SuggestedItemList = React.createElement(module7, {
				items = props.suggestedSearchTerms,
				firstSuggestedItemRef = props.firstSuggestedItemRef,
				nextSelectionUp = props.searchBarRef
			})
		})
	end

	v9.flexSlot = v16
	return createElement(module4, v9)
end

return SearchLandingPage
