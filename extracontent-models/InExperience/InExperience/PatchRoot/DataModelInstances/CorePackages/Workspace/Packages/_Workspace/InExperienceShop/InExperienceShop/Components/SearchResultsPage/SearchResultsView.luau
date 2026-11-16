local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local View = Foundation.View
local Text = Foundation.Text
local ScrollView = Foundation.ScrollView

local ItemRow = require(InExperienceShop.Components.ItemRow)
local FFlagEnableInExperienceShopUnifiedLogging = require(InExperienceShop.Flags.FFlagEnableInExperienceShopUnifiedLogging)
local SharedFlags = require(parent.SharedFlags)
local FFlagPassShopPurchaseSurfaceToBuyModal = SharedFlags.FFlagPassShopPurchaseSurfaceToBuyModal
local Analytics

if FFlagEnableInExperienceShopUnifiedLogging then
	Analytics = require(InExperienceShop.Analytics)
end

local shopPageType

if Analytics then
	shopPageType = Analytics.Constants.ShopPageType
else
	shopPageType = nil
end

local shopPageType2

if FFlagPassShopPurchaseSurfaceToBuyModal then
	local Constants = require(InExperienceShop.Analytics.Constants)
	shopPageType2 = Constants.ShopPageType
else
	shopPageType2 = nil
end

local useShopImpressionsDetector = require(InExperienceShop.Hooks.useShopImpressionsDetector)

local Constants = require(InExperienceShop.Constants)
require(InExperienceShop.Types)

local v = string.format("Type at least %d characters to search", Constants.SEARCH_MIN_LENGTH)

local v2 = { emptyText = "CommonUI.Messages.Response.NoResults" }

local function SearchResultsView(props)
	local v3 = useLocalization(v2)

	local v4 = useShopImpressionsDetector({
		pageType = not shopPageType and "" or shopPageType.Search,
		isPageActive = true,
		externalScrollSignal = nil
	})

	local onCanvasPositionChanged = React.useCallback(function(_)
		if FFlagEnableInExperienceShopUnifiedLogging then
			v4.onLayoutChange()
		end
	end, { v4.onLayoutChange })

	local v5 = React.useMemo(function()
		if props.state ~= "results" then
			return {}
		end

		local children = {}

		for k, row in props.rows do
			local v5 = "Row" .. k
			local createElement = React.createElement
			local v6 = {
				items = row,
				columnCount = props.columnCount,
				rowIndex = k,
				onItemActivated = props.onItemActivated,
				shopPageType = 0,
				LayoutOrder = 0
			}
			local shopPageType3

			if shopPageType2 then
				shopPageType3 = shopPageType2.Search
			end

			v6.shopPageType = shopPageType3
			v6.LayoutOrder = k
			children[v5] = createElement(ItemRow, v6)
		end

		return children
	end, { props.rows, props.columnCount, props.onItemActivated, props.state })
	local text

	if props.state == "hint" then
		text = v
	elseif props.state == "empty" then
		text = v3.emptyText
	end

	local createElement = React.createElement
	local v6 = {
		tag = "fill size-full-0",
		testId = "SearchResultsView",
		LayoutOrder = props.LayoutOrder
	}
	local scroll

	if text == nil then
		local createElement2 = React.createElement
		local v7 = { Size = UDim2.fromScale(1, 1), onCanvasPositionChanged = 0, scroll = 0 }

		if not FFlagEnableInExperienceShopUnifiedLogging then
			onCanvasPositionChanged = nil
		end

		v7.onCanvasPositionChanged = onCanvasPositionChanged

		v7.scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			scrollBarVisibility = Foundation.Enums.Visibility.None
		}

		local createElement3 = React.createElement
		local ref

		if FFlagEnableInExperienceShopUnifiedLogging then
			ref = v4.gridRef
		end

		scroll = createElement2(ScrollView, v7, {
			Content = createElement3(View, {
				tag = "col gap-medium size-full-0 auto-y padding-x-xlarge padding-bottom-xlarge padding-top-medium",
				ref = ref,
				onAbsoluteSizeChanged = FFlagEnableInExperienceShopUnifiedLogging and function(_)
					v4.onLayoutChange()
				end or nil
			}, v5)
		})
	end

	local impressionsDetector

	if FFlagEnableInExperienceShopUnifiedLogging then
		impressionsDetector = v4.impressionsDetector
	end

	local message

	if text ~= nil then
		message = React.createElement(
			View,
			{
				tag = "col align-x-center align-y-center size-full padding-x-xlarge padding-y-xlarge",
				testId = "SearchResultsMessage"
			},
			{
				Label = React.createElement(Text, {
					tag = "auto-xy text-body-medium text-align-x-center content-default",
					Text = text
				})
			}
		)
	end

	return createElement(View, v6, {
		Scroll = scroll,
		ImpressionsDetector = impressionsDetector,
		Message = message
	})
end

return SearchResultsView
