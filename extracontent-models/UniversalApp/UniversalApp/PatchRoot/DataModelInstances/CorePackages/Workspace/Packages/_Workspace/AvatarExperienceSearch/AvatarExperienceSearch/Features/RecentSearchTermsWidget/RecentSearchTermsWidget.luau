local AvatarExperienceSearch = script:FindFirstAncestor("AvatarExperienceSearch")
local AvatarExperienceSearchParent = AvatarExperienceSearch.Parent
local React = require(AvatarExperienceSearchParent.React)
local useLocalization = require(AvatarExperienceSearchParent.Localization).Hooks.useLocalization
local useTokens = require(AvatarExperienceSearchParent.Foundation).Hooks.useTokens
local AvatarExperienceUIKit = require(AvatarExperienceSearchParent.AvatarExperienceUIKit)
local WidgetHeader = AvatarExperienceUIKit.WidgetComponents.WidgetHeader
local WidgetLayout = AvatarExperienceUIKit.WidgetComponents.WidgetLayout
local SuggestedItemList = require(AvatarExperienceSearch.Components.SuggestedItemList)
local t1 = {
	widgetTitle = "Feature.Avatar.Label.SearchLandingPage.Title.RecentSearches"
}

local function RecentSearchTermsWidget(t2: {[any]: any}) -- line: 26
	-- upvalues: useTokens (copy), useLocalization (copy), t1 (copy), React (copy), WidgetLayout (copy), WidgetHeader (copy), SuggestedItemList (copy)
	local v13 = useTokens()
	local v14 = useLocalization(t1)

	return React.createElement(WidgetLayout, {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromScale(1, 1),
		LayoutOrder = t2.LayoutOrder,
		padding = {
			left = UDim.new(0, v13.Size.Size_400),
			right = UDim.new(0, v13.Size.Size_400)
		},
		headerSlot = if not t2.hasQuery then React.createElement(WidgetHeader, {
			titleText = v14.widgetTitle
		}) else nil,
		contentSlot = React.createElement(SuggestedItemList, {
			disableScroll = true,
			items = t2.items,
			firstSuggestedItemRef = t2.firstSuggestedItemRef
		})
	})
end

return RecentSearchTermsWidget
