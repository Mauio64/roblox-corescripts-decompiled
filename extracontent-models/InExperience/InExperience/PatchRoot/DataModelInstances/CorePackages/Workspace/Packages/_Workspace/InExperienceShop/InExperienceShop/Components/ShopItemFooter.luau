local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(InExperienceShop.Types)

local initiateShopItemPurchase = require(InExperienceShop.initiateShopItemPurchase)
local FFlagCategoryLoggingInShopPurchase = require(InExperienceShop.Flags.FFlagCategoryLoggingInShopPurchase)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local FFlagLuaAppEnableGamePassFreeTrials = require(InExperienceShop.Flags.FFlagLuaAppEnableGamePassFreeTrials)

local v = {
	owned = "Feature.Catalog.Label.Owned",
	buy = "Feature.Catalog.Action.Buy",
	try = "Feature.Catalog.Action.Try"
}

local function ShopItemFooter(props)
	local v2 = useLocalization(v)
	local isOwned = props.isOwned or false

	local purchaseCategoryLocation = props.purchaseCategoryLocation
	local onActivated = React.useCallback(function()
		if FFlagCategoryLoggingInShopPurchase and purchaseCategoryLocation ~= nil then
			initiateShopItemPurchase(props.itemId, props.itemType, props.shopPageType, purchaseCategoryLocation)
		else
			initiateShopItemPurchase(props.itemId, props.itemType, props.shopPageType)
		end
	end, { props.itemId, props.itemType, props.shopPageType, purchaseCategoryLocation })

	if isOwned then
		return React.createElement(Button, {
			text = v2.owned,
			variant = ButtonVariant.Standard,
			size = InputSize.Small,
			width = UDim.new(1, 0),
			isDisabled = true,
			LayoutOrder = props.LayoutOrder,
			onActivated = function() end
		})
	end

	if not (FFlagLuaAppEnableGamePassFreeTrials and props.showTry) then
		return React.createElement(Button, {
			text = v2.buy,
			variant = ButtonVariant.Standard,
			size = InputSize.Small,
			width = UDim.new(1, 0),
			onActivated = onActivated,
			isDisabled = props.isActionDisabled == true,
			LayoutOrder = props.LayoutOrder
		})
	end

	return React.createElement(Button, {
		text = v2.try,
		variant = ButtonVariant.Standard,
		size = InputSize.Small,
		width = UDim.new(1, 0),
		onActivated = props.onTryActivated or function() end,
		isLoading = props.isActionLoading,
		isDisabled = props.isActionDisabled == true and props.isActionLoading ~= true,
		LayoutOrder = props.LayoutOrder
	})
end

return React.memo(ShopItemFooter)
