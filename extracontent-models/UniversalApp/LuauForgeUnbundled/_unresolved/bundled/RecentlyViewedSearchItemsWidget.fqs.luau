local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")
local module2 = require("@luauforge/bundled/fqa")
local module3 = require("@luauforge/bundled/fqp")
local module4 = require("@luauforge/bundled/fpX")
local avatarScreen = require("@luauforge/bundled/fqt").Enums.AvatarScreen
local useTokens = require("@luauforge/bundled/fpW").Hooks.useTokens
local useLocalization = require("@luauforge/bundled/fpQ").Hooks.useLocalization
local useNavigation = require("@luauforge/bundled/fqh").useNavigation
local catalogItemCard = module2.Components.CatalogItemCard.CatalogItemCard
local module5 = require("@luauforge/bundled/fqr")
local itemCardThumbnail = module5.ItemCardComponents.ItemCardThumbnail
local widgetHeader = module5.WidgetComponents.WidgetHeader
local widgetLayout = module5.WidgetComponents.WidgetLayout

local module6 = require("@luauforge/bundled/fqu")
local module7 = require("@luauforge/bundled/fqy")
local getRbxThumbType = module2.Utils.getRbxThumbType

require("@luauforge/bundled/fqz")

local axRecentlyViewedSearchItemsIXPTest = module2.Experiments.AXRecentlyViewedSearchItemsIXPTest

local v5 = {
	widgetTitleSearchItems = "Feature.Avatar.Label.SearchLandingPage.Title.RecentlyViewedSearchItems",
	widgetTitleAllItems = "Feature.Avatar.Label.SearchLandingPage.Title.RecentlyViewedItems"
}

local function RecentlyViewedSearchItemsWidget(props)
	local v6 = useNavigation()
	local v7 = useTokens()
	local items = props.items or {}

	local v8 = useLocalization(v5)
	local testVariable = module3.readTestVariable(axRecentlyViewedSearchItemsIXPTest.EnabledSaveInCatalog)

	local v9 = props.itemWidth

	if props.itemsPerRow > 0 and #items > props.itemsPerRow then
		v9 = math.floor(v9 * 0.95)
	end

	local v10 = React.useCallback(function()
		local children = {}

		for k, item in items do
			local formatted = `RecentlyViewedSearchItemTile-{item.id}`
			local rbxThumbType = getRbxThumbType(item.itemType)
			local lowestPrice = item.lowestPrice or item.priceInRobux or nil

			if rbxThumbType == nil then
				continue
			end

			local createElement = React.createElement
			local v12 = {
				onActivated = item.onActivated,
				presentationSlot = React.createElement(
					module4.Focusable.Frame,
					{
						Size = UDim2.fromScale(1, 1),
						ClipsDescendants = true,
						BackgroundTransparency = 1,
						BorderSizePixel = 0
					},
					{
						CornerRadius = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, v7.Size.Size_600)
						}),
						Thumbnail = React.createElement(itemCardThumbnail, {
							url = `rbxthumb://type={rbxThumbType}&id={item.id}&w=150&h=150`
						})
					}
				),
				priceLineContent = item.priceStatus and {
					type = "text",
					text = item.priceStatus
				} or lowestPrice and {
					type = "price",
					price = lowestPrice or 0
				} or nil,
				title = item.name,
				Size = UDim2.fromOffset(v9, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				ref = 0,
				nextSelectionDown = 0,
				nextSelectionUp = 0,
				LayoutOrder = 0
			}
			local v13 = if k == 1 then props.firstSuggestedItemRef else nil
			v12.ref = v13
			v12.nextSelectionDown = props.nextSelectionDown
			v12.nextSelectionUp = props.nextSelectionUp
			v12.LayoutOrder = k
			children[formatted] = createElement(catalogItemCard, v12)
		end

		return children
	end, {
		items,
		props.firstSuggestedItemRef,
		props.nextSelectionDown,
		props.nextSelectionUp,
		v9
	})

	local createElement = React.createElement
	local children = {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromScale(1, 1),
		LayoutOrder = props.LayoutOrder,
		padding = {
			left = UDim.new(0, v7.Size.Size_400),
			right = UDim.new(0, v7.Size.Size_400)
		},
		headerSlot = 0,
		contentSlot = 0
	}

	local createElement2 = React.createElement

	local v14 = if testVariable then v8.widgetTitleAllItems else v8.widgetTitleSearchItems
	children.headerSlot = createElement2(widgetHeader, {
		titleText = v14,
		seeAllCallback = function()
			v6.navigate(avatarScreen.SearchLandingFocusedWidgetPage, {
				widgetType = module7.RecentlyViewedItems
			})
		end,
		NextSelectionDown = props.firstSuggestedItemRef,
		NextSelectionUp = props.nextSelectionUp
	})

	children.contentSlot = React.createElement(
		"Frame",
		{
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.fromScale(1, 0)
		},
		{
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, -v7.Size.Size_600),
				PaddingRight = UDim.new(0, -v7.Size.Size_600)
			}),
			RecentlyViewedSearchItemsWidgetContent = React.createElement(
				module6,
				{ itemPadding = v7.Size.Size_250, carouselMargin = v7.Size.Size_600 },
				v10()
			)
		}
	)
	return createElement(widgetLayout, children)
end

return RecentlyViewedSearchItemsWidget
