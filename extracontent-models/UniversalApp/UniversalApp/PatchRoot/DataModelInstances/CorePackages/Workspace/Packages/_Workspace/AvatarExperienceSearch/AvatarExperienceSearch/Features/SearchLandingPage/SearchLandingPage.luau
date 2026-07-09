local AvatarExperienceSearch = script:FindFirstAncestor("AvatarExperienceSearch")
local AvatarExperienceSearchParent = AvatarExperienceSearch.Parent
local React = require(AvatarExperienceSearchParent.React)
local FFlagRenameDeprecatedUIBloxTokens = require(AvatarExperienceSearchParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useDesignTokens = require(AvatarExperienceSearchParent.Style).useDesignTokens
local AXCommon = require(AvatarExperienceSearchParent.AXCommon)
local useNavigationFocus = require(AvatarExperienceSearchParent.Navigation).useNavigationFocus
local FlexLayout = require(AvatarExperienceSearch.Components.FlexLayout)
local SearchBar = require(AvatarExperienceSearch.Components.SearchBar)
local SuggestedItemList = require(AvatarExperienceSearch.Components.SuggestedItemList)
local SearchEmptyState = require(AvatarExperienceSearch.Components.SearchEmptyState)
local SearchLandingPageWidgets = require(AvatarExperienceSearch.Features.SearchLandingPageWidgets.SearchLandingPageWidgets)
local AXRecentlyViewedSearchItemsIXPTest = AXCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest

local function mapTokens(p1) -- line: 21
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy), AXRecentlyViewedSearchItemsIXPTest (copy)
	return {
		backgroundColor = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Background.Default else p1.Color.Surface.Surface_0)).Color3,
		backgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Background.Default else p1.Color.Surface.Surface_0)).Transparency,
		itemListPadding = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_200 else p1.Size.Size_400,
		searchBarPadding = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_150 else p1.Size.Size_300 else if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_200 else p1.Size.Size_400,
		emptyStatePadding = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_500 else p1.Size.Size_1000,
		spaceBetweenSearchAndList = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_100 else p1.Size.Size_200
	}
end
local function SearchLandingPage(p2) -- line: 57
	-- upvalues: useDesignTokens (copy), mapTokens (copy), AXRecentlyViewedSearchItemsIXPTest (copy), useNavigationFocus (copy), React (copy), FlexLayout (copy), SearchBar (copy), SuggestedItemList (copy), SearchEmptyState (copy), SearchLandingPageWidgets (copy)
	local v18 = useDesignTokens(mapTokens)

	if AXRecentlyViewedSearchItemsIXPTest.isEnabled() then
		local v19 = useNavigationFocus()

		React.useEffect(function() -- line: 66
			-- upvalues: v19 (copy), p2 (copy)
			if v19 and (p2.searchBarRef and p2.searchBarRef.current) then
				p2.searchBarRef.current:CaptureFocus()
			end
		end, { v19 })
	end

	local v20 = #p2.suggestedSearchTerms > 0

	return React.createElement(FlexLayout, {
		BorderSizePixel = 0,
		margin = 0,
		reverse = true,
		BackgroundColor3 = v18.backgroundColor,
		BackgroundTransparency = v18.backgroundTransparency,
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.XY,
		padding = p2.padding,
		flexDirection = Enum.FillDirection.Vertical,
		rigidSlot = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			SearchBarFramePadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v18.searchBarPadding),
				PaddingBottom = UDim.new(0, v18.searchBarPadding),
				PaddingLeft = UDim.new(0, v18.searchBarPadding),
				PaddingRight = UDim.new(0, v18.searchBarPadding)
			}),
			SearchBar = React.createElement(SearchBar, {
				showCancelButton = true,
				autofocus = true,
				onCancel = p2.onCancelSearch,
				onClear = p2.onClearSearch,
				onChange = p2.onChangeSearchQuery,
				onSubmit = p2.onSubmitSearch,
				ref = p2.searchBarRef,
				nextSelectionDown = p2.firstSuggestedItemRef
			})
		}),
		flexSlot = if AXRecentlyViewedSearchItemsIXPTest.isEnabled() or not v20 then if not p2.shouldShowEmptyState then if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then nil else React.createElement(SearchLandingPageWidgets, {
			hasQuery = p2.hasQuery,
			suggestedSearchTerms = p2.suggestedSearchTerms,
			recentlyViewedItems = p2.recentlyViewedItems,
			searchBarRef = p2.searchBarRef,
			firstSuggestedItemRef = p2.firstSuggestedItemRef
		}) else React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.fromScale(1, 0)
		}, {
			EmptyStatePadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v18.emptyStatePadding),
				PaddingLeft = UDim.new(0, v18.emptyStatePadding),
				PaddingRight = UDim.new(0, v18.emptyStatePadding)
			}),
			SearchEmptyState = React.createElement(SearchEmptyState)
		}) else React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.fromScale(1, 1)
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v18.itemListPadding),
				PaddingRight = UDim.new(0, v18.itemListPadding)
			}),
			SuggestedItemList = React.createElement(SuggestedItemList, {
				items = p2.suggestedSearchTerms,
				firstSuggestedItemRef = p2.firstSuggestedItemRef,
				nextSelectionUp = p2.searchBarRef
			})
		})
	})
end

return SearchLandingPage
