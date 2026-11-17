local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local AvatarExperienceInspectAndBuy = require(parent.AvatarExperienceInspectAndBuy)
require(parent.Foundation)
require(ProfilePlatform.Common.Types)
local InspectAvatarUtils = require(script.Parent.Parent.InspectAvatarUtils)
require(script.Parent.CalloutScoring)

local getPriceLineContent = AvatarExperienceInspectAndBuy.Utils.getPriceLineContent
local isItemPurchasable = InspectAvatarUtils.isItemPurchasable
local getPriceStatus = InspectAvatarUtils.getPriceStatus
local PriceStatusEnum = InspectAvatarUtils.PriceStatusEnum
local CalloutItemInfo = {}

function CalloutItemInfo.getStatusKind(p): string
	local priceStatus = getPriceStatus(p)

	if p.isOwned or priceStatus == PriceStatusEnum.Owned then
		return "owned"
	end

	if not isItemPurchasable(p) then
		return "unavailable"
	end

	if priceStatus == PriceStatusEnum.PurchaseFromResale then
		return "resale"
	end

	return "purchasable"
end

function CalloutItemInfo.getCurrentPriceLine(p, p2, p3)
	local priceLineContent = getPriceLineContent(p, p2, p3, { isShopContext = true })

	if not priceLineContent then
		return nil
	end

	for i = #priceLineContent, 1, -1 do
		local v = priceLineContent[i]

		if v.strikethrough then
			continue
		end

		if v.type == "price" then
			return { type = "price", price = v.price, colorStyle = v.colorStyle }
		end

		if v.type == "text" then
			return { type = "text", text = v.text, colorStyle = v.colorStyle }
		end
	end

	return nil
end

return CalloutItemInfo
