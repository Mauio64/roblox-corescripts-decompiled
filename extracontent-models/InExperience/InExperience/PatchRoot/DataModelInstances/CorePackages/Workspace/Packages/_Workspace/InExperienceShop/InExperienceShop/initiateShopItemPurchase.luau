local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local PurchasePrompt = require(InExperienceShopParent.PurchasePrompt)
local SharedFlags = require(InExperienceShopParent.SharedFlags)
local getShopPurchasePayload = require(InExperienceShop.Utils.getShopPurchasePayload)
local FFlagEnablePurchasePayloadInExperienceShop = SharedFlags.FFlagEnablePurchasePayloadInExperienceShop

require(InExperienceShop.Types)

local function initiateShopItemPurchase(s1: string, p1) -- line: 31
	-- upvalues: FFlagEnablePurchasePayloadInExperienceShop (copy), getShopPurchasePayload (copy), PurchasePrompt (copy)
	if tonumber(s1) == nil then
		return
	end

	local v10 = if not FFlagEnablePurchasePayloadInExperienceShop then nil else getShopPurchasePayload()

	if p1 == "GamePass" then
		PurchasePrompt.initiatePurchaseForProductPayload({
			kind = "Gamepass",
			id = s1,
			purchasePayload = v10
		})

		return
	end

	if p1 == "Product" then
		PurchasePrompt.initiatePurchaseForProductPayload({
			kind = "Product",
			equipIfPurchased = false,
			id = s1,
			purchasePayload = v10
		})
	end
end

return initiateShopItemPurchase
