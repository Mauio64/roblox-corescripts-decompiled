local BulkPurchaseApp = script:FindFirstAncestor("BulkPurchaseApp")
local parent = BulkPurchaseApp.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Localization2 = require(parent.Localization)
local LocalizationRoactContext = Localization2.LocalizationRoactContext
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local UIBlox = require(parent.UIBlox)

local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ReactFocusNavigation = require(parent.ReactFocusNavigation)

local FullPagePrompt = require(BulkPurchaseApp.Components.FullPagePrompt)
local PriceBox = require(BulkPurchaseApp.Components.PriceBox)
local LineItemLayout = require(BulkPurchaseApp.Components.LineItemLayout)
local FullPagePromptTwoPanelLayout = require(BulkPurchaseApp.Components.FullPagePromptTwoPanelLayout)
local Divider = require(BulkPurchaseApp.Components.Divider)
local FullPagePromptScrollList = require(BulkPurchaseApp.Components.FullPagePromptScrollList)
local FFlagFixVP8143 = require(BulkPurchaseApp.Flags.FFlagFixVP8143)
local FFlagBulkPurchaseEnablePurchaseOptions = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseEnablePurchaseOptions)
local FFlagAXAddPlusUpsellToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddPlusUpsellToBulkPurchase)
local FFlagAXAddOffersToBulkPurchase = require(BulkPurchaseApp.Flags.FFlagAXAddOffersToBulkPurchase)
local FFlagBulkPurchaseTestPurchaseHint = require(BulkPurchaseApp.Flags.FFlagBulkPurchaseTestPurchaseHint)

local ItemList = require(BulkPurchaseApp.Components.ItemList)
require(parent.AvatarExperienceCommon)
require(parent.RobloxSubscriptionPurchaseApp)
local ItemStatusKeyToLocalizationKey = require(BulkPurchaseApp.Enums.ItemStatusKeyToLocalizationKey)
require(BulkPurchaseApp.Store.Types)

require(script.Parent.BulkPurchaseRequestItem)
require(script.Parent.BulkPurchaseRequestOwnedItem)
require(script.Parent.BulkPurchaseRequestUnpurchasableItem)

local ItemPresentationMapper = require(script.Parent.ItemPresentationMapper)
local mapItemsToRowPresentation = ItemPresentationMapper.mapItemsToRowPresentation
local mapOwnedItemsToRowPresentation = ItemPresentationMapper.mapOwnedItemsToRowPresentation
local mapUnpurchasableItemsToRowPresentation = ItemPresentationMapper.mapUnpurchasableItemsToRowPresentation

local v = {
	heading = "CoreScripts.BulkPurchasePrompt.RequestPrompt.Heading",
	listHeading = "CoreScripts.BulkPurchasePrompt.RequestPrompt.ItemListPurchaseHeading",
	itemCount = "CoreScripts.BulkPurchasePrompt.RequestPrompt.ItemListPurchaseCount",
	itemOwned = "CoreScripts.BulkPurchasePrompt.RequestPrompt.ItemOwned"
}

local function BulkPurchaseRequest(props)
	local v2 = useLocalization(v)
	local v3 = React.useContext(LocalizationRoactContext)
	local v4, ref = ReactFocusNavigation.useDefaultFocusBehavior()
	local buttonRef

	if FFlagFixVP8143 then
		buttonRef = React.useCallback(function(current)
			if typeof(props.purchaseButtonRef) == "table" then
				props.purchaseButtonRef.current = current
			end

			if typeof(v4) == "function" then
				v4(current)
			elseif typeof(v4) == "table" then
				v4.current = current
			end
		end, { props.purchaseButtonRef })
	end

	local v5 = useDesignTokens()
	local fontStyle = {
		LineHeight = v5.Typography.BodyLarge.LineHeight,
		Font = v5.Typography.TitleLarge.Font,
		FontSize = v5.Typography.BodyLarge.FontSize,
		LetterSpacing = v5.Typography.BodyLarge.LetterSpacing
	}

	local emphasis = v5.Color.Content.Emphasis

	local v6, v7 = React.useBinding(Vector2.new(0, 0))

	local v8 = useLocalization(ItemStatusKeyToLocalizationKey)
	local success = v5.Color.System.Success
	local alert = v5.Color.System.Alert

	local items = props.items

	if not FFlagBulkPurchaseEnablePurchaseOptions then
		v3 = nil
	end

	local items2 = mapItemsToRowPresentation(items, v3)
	local items3 = {}
	local v9 = mapOwnedItemsToRowPresentation(props.ownedItems, emphasis, v2)

	local v10 = mapUnpurchasableItemsToRowPresentation(props.unpurchasableItems, v8, success, alert)
	table.move(v9, 1, #v9, #items3 + 1, items3)
	table.move(v10, 1, #v10, #items3 + 1, items3)

	local v11 = #items3 > 0

	local createElement = React.createElement

	local v12 = { onClose = props.onClose, title = v2.heading, ref = ref }
	local createElement2 = React.createElement
	local children = {
		size = React.createBinding(UDim2.fromScale(1, 1)),
		startSlot = 0,
		endSlot = 0
	}
	local createElement3 = React.createElement

	local v13 = { BorderSizePixel = 0, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }

	local element = React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		Padding = UDim.new(0, v5.Size.Size_600)
	})

	local element2 = React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1,
		[React.Change.AbsoluteSize] = function(p)
			v7(p.AbsoluteSize)
		end
	}, React.createElement("UIPadding", { PaddingRight = UDim.new(0, v5.Size.Size_250) }), React.createElement(LineItemLayout, {
		startSlot = React.createElement(StyledTextLabel, {
			fontStyle = fontStyle,
			colorStyle = emphasis,
			text = v2.listHeading
		}),
		endSlot = React.createElement(StyledTextLabel, {
			fontStyle = fontStyle,
			colorStyle = emphasis,
			text = v2.itemCount:gsub("{.*}", (tostring(#props.items)))
		}),
		LayoutOrder = 1
	}))

	local createElement4 = React.createElement

	local v14 = {
		LayoutOrder = 2,
		size = v6:map(function(vector2: Vector2)
			return UDim2.new(1, 0, 1, -(vector2.Y + v5.Size.Size_600))
		end)
	}

	local element3 = React.createElement(ItemList, { items = items2 })
	local v15

	if v11 then
		v15 = React.createElement(Divider)
	end

	local v16

	if v11 then
		v16 = React.createElement(ItemList, { items = items3 })
	end

	children.startSlot = createElement3(
		"Frame",
		v13,
		element,
		element2,
		createElement4(FullPagePromptScrollList, v14, element3, v15, v16)
	)

	local createElement5 = React.createElement
	local v17 = {
		currentBalance = props.currentBalance,
		totalCost = props.totalCost,
		discountInformation = props.discountInformation,
		missingRobux = props.currentBalance - props.totalCost < 0,
		onAccept = props.onAccept,
		buttonRef = 0,
		isDisabled = 0,
		shouldShowBlackbirdUpsellBanner = 0,
		blackbirdUpsellBannerProductInfo = 0,
		onBlackbirdUpsellActivated = 0,
		offerData = 0,
		toggleOfferSelected = 0,
		isTestPurchase = 0
	}

	if not FFlagFixVP8143 then
		buttonRef = v4
	end

	v17.buttonRef = buttonRef
	v17.isDisabled = props.isDisabled
	local shouldShowBlackbirdUpsellBanner

	if FFlagAXAddPlusUpsellToBulkPurchase then
		shouldShowBlackbirdUpsellBanner = props.shouldShowBlackbirdUpsellBanner
	end

	v17.shouldShowBlackbirdUpsellBanner = shouldShowBlackbirdUpsellBanner
	local blackbirdUpsellBannerProductInfo

	if FFlagAXAddPlusUpsellToBulkPurchase then
		blackbirdUpsellBannerProductInfo = props.blackbirdUpsellBannerProductInfo
	end

	v17.blackbirdUpsellBannerProductInfo = blackbirdUpsellBannerProductInfo
	local onBlackbirdUpsellActivated

	if FFlagAXAddPlusUpsellToBulkPurchase then
		onBlackbirdUpsellActivated = props.onBlackbirdUpsellActivated
	end

	v17.onBlackbirdUpsellActivated = onBlackbirdUpsellActivated
	local offerData

	if FFlagAXAddOffersToBulkPurchase then
		offerData = props.offerData
	end

	v17.offerData = offerData
	local toggleOfferSelected

	if FFlagAXAddOffersToBulkPurchase then
		toggleOfferSelected = props.toggleOfferSelected
	end

	v17.toggleOfferSelected = toggleOfferSelected
	local isTestPurchase

	if FFlagBulkPurchaseTestPurchaseHint then
		isTestPurchase = props.isTestPurchase
	end

	v17.isTestPurchase = isTestPurchase
	children.endSlot = createElement5(PriceBox, v17)
	return createElement(FullPagePrompt, v12, createElement2(FullPagePromptTwoPanelLayout, children))
end

return BulkPurchaseRequest
