local AvatarExperienceSearch = script:FindFirstAncestor("AvatarExperienceSearch")
local AvatarExperienceSearchParent = AvatarExperienceSearch.Parent
local React = require(AvatarExperienceSearchParent.React)
local AXCommon = require(AvatarExperienceSearchParent.AXCommon)
local UIBlox = require(AvatarExperienceSearchParent.UIBlox)
local useTokens = require(AvatarExperienceSearchParent.Foundation).Hooks.useTokens
local IxpUtils = require(AvatarExperienceSearchParent.IxpUtils)
local GridMetrics = UIBlox.App.Grid.GridMetrics

require(AvatarExperienceSearch.Components.SuggestedItemList)

local RecentSearchTermsWidget = require(AvatarExperienceSearch.Features.RecentSearchTermsWidget.RecentSearchTermsWidget)
local RecentlyViewedSearchItemsWidget = require(AvatarExperienceSearch.Features.RecentlyViewedSearchItemsWidget.RecentlyViewedSearchItemsWidget)

require(AvatarExperienceSearch.Features.RecentlyViewedSearchItemsWidget.useRecentlyViewedSearchItemsWidgetProps)

local AXRecentlyViewedSearchItemsIXPTest = AXCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest

local function SearchLandingPageWidgets(t1: {[any]: any}) -- line: 31
	-- upvalues: useTokens (copy), React (copy), GridMetrics (copy), IxpUtils (copy), AXRecentlyViewedSearchItemsIXPTest (copy), RecentSearchTermsWidget (copy), RecentlyViewedSearchItemsWidget (copy)
	local v14 = useTokens()
	local v15, v16 = React.useState(0)
	local v17 = React.useRef(nil)
	local v18 = React.useRef(nil)
	local v19 = React.useMemo(function() -- line: 40
		-- upvalues: GridMetrics (copy), v15 (copy), v14 (copy)
		return GridMetrics.getSmallMetrics(math.max(v15 - v14.Size.Size_400 * 2, 0), v14.Size.Size_250)
	end, { v15 })
	local n1 = 1
	local n2 = 2
	local v22 = IxpUtils.readTestVariable(AXRecentlyViewedSearchItemsIXPTest.EnabledForUser)

	if v22 and IxpUtils.readTestVariable(AXRecentlyViewedSearchItemsIXPTest.EnabledTopVariant) then
		n1 = 2
		n2 = 1
	end

	return React.createElement("ScrollingFrame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		CanvasSize = UDim2.fromScale(1, 1),
		Size = UDim2.fromScale(1, 1),
		ScrollBarThickness = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		[React.Change.AbsoluteSize] = function(p1) -- line: 44
			-- upvalues: v16 (copy)
			v16(p1.AbsoluteSize.X)
		end
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v14.Size.Size_600)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v14.Size.Size_1200)
		}),
		RecentSearchTermsWidget = if not (#t1.suggestedSearchTerms > 0) then nil else React.createElement(RecentSearchTermsWidget, {
			hasQuery = t1.hasQuery,
			items = t1.suggestedSearchTerms,
			firstSuggestedItemRef = if n1 ~= 1 then v17 else t1.firstSuggestedItemRef,
			searchBarRef = t1.searchBarRef,
			LayoutOrder = n1
		}),
		RecentlyViewedSearchItemsWidget = if not v22 or (t1.hasQuery or (not t1.recentlyViewedItems or not (#t1.recentlyViewedItems > 0))) then nil else React.createElement(RecentlyViewedSearchItemsWidget, {
			items = t1.recentlyViewedItems,
			firstSuggestedItemRef = if n2 ~= 1 then v18 else t1.firstSuggestedItemRef,
			nextSelectionDown = if n2 ~= 1 then t1.searchBarRef else v17,
			nextSelectionUp = if n2 ~= 1 then v17 else t1.searchBarRef,
			itemWidth = v19.itemWidth,
			itemsPerRow = v19.itemsPerRow,
			LayoutOrder = n2
		})
	})
end

return SearchLandingPageWidgets
