local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local PurchasePrompt = require(InExperienceShopParent.PurchasePrompt)
local SharedFlags = require(InExperienceShopParent.SharedFlags)
local getShopPurchasePayload = require(InExperienceShop.Utils.getShopPurchasePayload)
local FFlagEnablePurchasePayloadInExperienceShop = SharedFlags.FFlagEnablePurchasePayloadInExperienceShop
local FFlagPassShopPurchaseSurfaceToBuyModal = SharedFlags.FFlagPassShopPurchaseSurfaceToBuyModal
local FFlagSkipBuyDelayForExperienceShop = SharedFlags.FFlagSkipBuyDelayForExperienceShop

require(InExperienceShop.Types)

local function initiateShopItemPurchase(s1: string, p1, s2: string?) -- line: 33
	-- upvalues: FFlagEnablePurchasePayloadInExperienceShop (copy), getShopPurchasePayload (copy), PurchasePrompt (copy), FFlagPassShopPurchaseSurfaceToBuyModal (copy), InExperienceShop (copy), FFlagSkipBuyDelayForExperienceShop (copy)
	if tonumber(s1) == nil then
		return
	end

	local v13 = if not FFlagEnablePurchasePayloadInExperienceShop then nil else getShopPurchasePayload()
	local initiatePurchaseForProductPayload = PurchasePrompt.initiatePurchaseForProductPayload

	if FFlagPassShopPurchaseSurfaceToBuyModal and s2 ~= nil then
		local t1 = {
			surface = require(InExperienceShop.Analytics.getShopPurchaseAnalyticsSurface)(s2)
		}

		function initiatePurchaseForProductPayload(p2) -- line: 49
			-- upvalues: PurchasePrompt (copy), t1 (copy)
			PurchasePrompt.initiatePurchaseForProductPayload(p2, t1)
		end
	end

	if p1 == "GamePass" then
		initiatePurchaseForProductPayload({
			kind = "Gamepass",
			id = s1,
			purchasePayload = v13,
			isFromInExperienceShop = not not FFlagSkipBuyDelayForExperienceShop or nil
		})

		return
	end

	if p1 == "Product" then
		initiatePurchaseForProductPayload({
			kind = "Product",
			equipIfPurchased = false,
			id = s1,
			purchasePayload = v13,
			isFromInExperienceShop = not not FFlagSkipBuyDelayForExperienceShop or nil
		})
	end
end

return initiateShopItemPurchase
