local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local Foundation = require(InExperienceShopParent.Foundation)
local useLocalization = require(InExperienceShopParent.Localization).Hooks.useLocalization

require(InExperienceShop.Types)

local initiateShopItemPurchase = require(InExperienceShop.initiateShopItemPurchase)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local t1 = {
	owned = "Feature.Catalog.Label.Owned",
	buy = "Feature.Catalog.Action.Buy"
}

local function ShopItemFooter(t2: {[any]: any}) -- line: 31
	-- upvalues: useLocalization (copy), t1 (copy), React (copy), initiateShopItemPurchase (copy), Button (copy), ButtonVariant (copy), InputSize (copy)
	local v13 = useLocalization(t1)
	local v14 = t2.isOwned or false
	local v15 = React.useCallback(function() -- line: 35
		-- upvalues: initiateShopItemPurchase (copy), t2 (copy)
		initiateShopItemPurchase(t2.itemId, t2.itemType, t2.shopPageType)
	end, {
		t2.itemId,
		t2.itemType,
		t2.shopPageType
	})

	if v14 then
		return React.createElement(Button, {
			isDisabled = true,
			text = v13.owned,
			variant = ButtonVariant.Standard,
			size = InputSize.Small,
			width = UDim.new(1, 0),
			LayoutOrder = t2.LayoutOrder,
			onActivated = function() -- line: 47
			end
		})
	end

	return React.createElement(Button, {
		text = v13.buy,
		variant = ButtonVariant.Standard,
		size = InputSize.Small,
		width = UDim.new(1, 0),
		onActivated = v15,
		LayoutOrder = t2.LayoutOrder
	})
end

return React.memo(ShopItemFooter)
