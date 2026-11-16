local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local parent = AvatarExperienceInspectAndBuy.Parent
require(parent.AXCommon)
require(parent.Foundation)
local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local getPriceStatus = require(AvatarExperienceInspectAndBuy.Utils.getPriceStatus)
require(AvatarExperienceInspectAndBuy.Types)
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialEnableProfileInspectAndBuy = SharedFlags.FFlagSocialEnableProfileInspectAndBuy
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXIaBDiscountPriceLine = AvatarExperienceFlags.FFlagAXIaBDiscountPriceLine
local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)
local FFlagAXIaBEnableShopContext = AvatarExperienceFlags2.FFlagAXIaBEnableShopContext

local v = FFlagSocialEnableProfileInspectAndBuy or FFlagAXIaBEnableShopContext
local getPriceStatusInShop

if v then
	getPriceStatusInShop = require(AvatarExperienceInspectAndBuy.Utils.getPriceStatusInShop)
else
	getPriceStatusInShop = nil
end

local function getPriceLineContent(data, p, p2, p3)
	local priceLineContent = {}
	local v2

	if v and p3 and p3.isShopContext then
		assert(
			not p3.disableResaleWhenStockIsAvailable,
			"disableResaleWhenStockIsAvailable is not applicable when isShopContext is true"
		)

		v2 = getPriceStatusInShop(data)
	else
		v2 = getPriceStatus(data, true)
	end

	local v3 = nil

	if FFlagAXIaBDiscountPriceLine and data.discountInformation then
		local discountInformation = data.discountInformation

		if discountInformation.totalDiscountAmount and discountInformation.totalDiscountAmount > 0 then
			v3 = discountInformation
		end
	end

	local v4 = {
		[PriceStatus.Owned] = {
			{ type = "text", text = p2[PriceStatus.Owned] }
		},
		[PriceStatus.Free] = {
			{ type = "text", text = p2[PriceStatus.Free] }
		},
		[PriceStatus.QuantityLimitReached] = {
			{
				type = "text",
				colorStyle = p.Color.System.Warning,
				text = p2[PriceStatus.QuantityLimitReached]
			}
		},
		[PriceStatus.InExperienceOnly] = {
			{
				type = "text",
				text = p2[PriceStatus.InExperienceOnly],
				colorStyle = p.Color.System.Warning
			}
		}
	}

	local purchaseFromRoblox = PriceStatus.PurchaseFromRoblox
	local v5

	if v3 then
		v5 = {
			{
				type = "price",
				price = v3.originalPrice,
				strikethrough = true,
				isOriginalPrice = true
			},
			{ type = "price", price = data.priceInRobux }
		}
	else
		v5 = {
			{ type = "price", price = data.priceInRobux }
		}
	end

	v4[purchaseFromRoblox] = v5

	local purchaseFromResale = PriceStatus.PurchaseFromResale
	local v6

	if data.isOffSale then
		v6 = {
			{
				type = "price",
				price = not data.collectibleItemDetails and 0 or data.collectibleItemDetails.lowestResalePrice
			}
		}
	else
		v6 = {
			{ type = "price", price = data.priceInRobux, strikethrough = true },
			{
				type = "price",
				price = not data.collectibleItemDetails and 0 or data.collectibleItemDetails.lowestResalePrice,
				colorStyle = p.Color.System.Warning
			}
		}
	end

	v4[purchaseFromResale] = v6

	v4[PriceStatus.SoldOut] = {
		{ type = "text", text = p2[PriceStatus.SoldOut], colorStyle = p.Color.System.Warning }
	}

	v4[PriceStatus.OffSale] = {
		{ type = "text", text = p2[PriceStatus.OffSale], colorStyle = p.Color.System.Warning }
	}

	v4[PriceStatus.Unavailable] = {
		{ type = "text", text = p2[PriceStatus.Unavailable], colorStyle = p.Color.System.Warning }
	}

	if v4[v2] then
		priceLineContent = v4[v2]
	end

	return priceLineContent
end

return getPriceLineContent
