local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local PurchasePrompt = require(parent.PurchasePrompt)
local SharedFlags = require(parent.SharedFlags)

local getShopPurchasePayload = require(InExperienceShop.Utils.getShopPurchasePayload)
local FFlagCategoryLoggingInShopPurchase = require(InExperienceShop.Flags.FFlagCategoryLoggingInShopPurchase)

local FFlagEnablePurchasePayloadInExperienceShop = SharedFlags.FFlagEnablePurchasePayloadInExperienceShop
local FFlagPassShopPurchaseSurfaceToBuyModal = SharedFlags.FFlagPassShopPurchaseSurfaceToBuyModal
local FFlagSkipBuyDelayForExperienceShop = SharedFlags.FFlagSkipBuyDelayForExperienceShop

require(InExperienceShop.Types)

local function initiateShopItemPurchase(id: string, p, p2: string?, p3)
	if tonumber(id) == nil then
		return
	end

	local purchasePayload

	if FFlagEnablePurchasePayloadInExperienceShop then
		if not FFlagCategoryLoggingInShopPurchase then
			p3 = nil
		end

		purchasePayload = getShopPurchasePayload(p3)
	end

	local v = PurchasePrompt.initiatePurchaseForProductPayload

	if FFlagPassShopPurchaseSurfaceToBuyModal and p2 ~= nil then
		local getShopPurchaseAnalyticsSurface = require(InExperienceShop.Analytics.getShopPurchaseAnalyticsSurface)
		local v2 = {
			surface = getShopPurchaseAnalyticsSurface(p2)
		}

		v = function(p4)
			PurchasePrompt.initiatePurchaseForProductPayload(p4, v2)
		end
	end

	if p == "GamePass" then
		v({
			id = id,
			kind = "Gamepass",
			purchasePayload = purchasePayload,
			isFromInExperienceShop = FFlagSkipBuyDelayForExperienceShop and true or nil
		})
	elseif p == "Product" then
		v({
			id = id,
			kind = "Product",
			equipIfPurchased = false,
			purchasePayload = purchasePayload,
			isFromInExperienceShop = FFlagSkipBuyDelayForExperienceShop and true or nil
		})
	end
end

return initiateShopItemPurchase
