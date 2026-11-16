local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")
local useLocalization = require("@luauforge/bundled/fpQ").Hooks.useLocalization

local useTokens = require("@luauforge/bundled/fpW").Hooks.useTokens
local module2 = require("@luauforge/bundled/fqr")
local widgetHeader = module2.WidgetComponents.WidgetHeader
local widgetLayout = module2.WidgetComponents.WidgetLayout

local module3 = require("@luauforge/bundled/fqj")

local v5 = {
	widgetTitle = "Feature.Avatar.Label.SearchLandingPage.Title.RecentSearches"
}

local function RecentSearchTermsWidget(props)
	local v6 = useTokens()
	local v7 = useLocalization(v5)

	local createElement = React.createElement
	local v9 = {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromScale(1, 1),
		LayoutOrder = props.LayoutOrder,
		padding = {
			left = UDim.new(0, v6.Size.Size_400),
			right = UDim.new(0, v6.Size.Size_400)
		},
		headerSlot = 0,
		contentSlot = 0
	}

	local v10 = if not props.hasQuery then React.createElement(widgetHeader, {
		titleText = v7.widgetTitle
	}) else nil
	v9.headerSlot = v10

	v9.contentSlot = React.createElement(module3, {
		items = props.items,
		firstSuggestedItemRef = props.firstSuggestedItemRef,
		disableScroll = true
	})
	return createElement(widgetLayout, v9)
end

return RecentSearchTermsWidget
