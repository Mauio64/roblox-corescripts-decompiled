require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceCommon")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/Foundation")
local PriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Enums/PriceStatus")
local getPriceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceStatus")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Types")
local fFlagSocialEnableProfileInspectAndBuy = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/SharedFlags").FFlagSocialEnableProfileInspectAndBuy
local fFlagAXIaBDiscountPriceLine = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceFlags").FFlagAXIaBDiscountPriceLine
local fFlagAXIaBEnableShopContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceFlags").FFlagAXIaBEnableShopContext

local v5 = fFlagSocialEnableProfileInspectAndBuy or fFlagAXIaBEnableShopContext

local v6 = if v5 then require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/AvatarExperienceInspectAndBuy/Utils/getPriceStatusInShop") else nil

local function getPriceLineContent(data, p2, p3, p4)
	local priceLineContent = {}
	local v7

	if v5 and p4 and p4.isShopContext then
		assert(
			not p4.disableResaleWhenStockIsAvailable,
			"disableResaleWhenStockIsAvailable is not applicable when isShopContext is true"
		)

		v7 = v6(data)
	else
		v7 = getPriceStatus(data, true)
	end

	local v8 = nil

	if fFlagAXIaBDiscountPriceLine and data.discountInformation then
		local discountInformation = data.discountInformation

		if discountInformation.totalDiscountAmount and discountInformation.totalDiscountAmount > 0 then
			v8 = discountInformation
		end
	end

	local v9 = {
		[PriceStatus.Owned] = {
			{ type = "text", text = p3[PriceStatus.Owned] }
		},
		[PriceStatus.Free] = {
			{ type = "text", text = p3[PriceStatus.Free] }
		},
		[PriceStatus.QuantityLimitReached] = {
			{
				type = "text",
				colorStyle = p2.Color.System.Warning,
				text = p3[PriceStatus.QuantityLimitReached]
			}
		},
		[PriceStatus.InExperienceOnly] = {
			{
				type = "text",
				text = p3[PriceStatus.InExperienceOnly],
				colorStyle = p2.Color.System.Warning
			}
		}
	}

	local purchaseFromRoblox = PriceStatus.PurchaseFromRoblox
	local v10 = if v8 then {
		{
			type = "price",
			price = v8.originalPrice,
			strikethrough = true,
			isOriginalPrice = true
		},
		{ type = "price", price = data.priceInRobux }
	} else {
		{ type = "price", price = data.priceInRobux }
	}
	v9[purchaseFromRoblox] = v10

	local purchaseFromResale = PriceStatus.PurchaseFromResale
	local v11 = if data.isOffSale then {
		{
			type = "price",
			price = not data.collectibleItemDetails and 0 or data.collectibleItemDetails.lowestResalePrice
		}
	} else {
		{ type = "price", price = data.priceInRobux, strikethrough = true },
		{
			type = "price",
			price = not data.collectibleItemDetails and 0 or data.collectibleItemDetails.lowestResalePrice,
			colorStyle = p2.Color.System.Warning
		}
	}
	v9[purchaseFromResale] = v11

	v9[PriceStatus.SoldOut] = {
		{
			type = "text",
			text = p3[PriceStatus.SoldOut],
			colorStyle = p2.Color.System.Warning
		}
	}

	v9[PriceStatus.OffSale] = {
		{
			type = "text",
			text = p3[PriceStatus.OffSale],
			colorStyle = p2.Color.System.Warning
		}
	}

	v9[PriceStatus.Unavailable] = {
		{
			type = "text",
			text = p3[PriceStatus.Unavailable],
			colorStyle = p2.Color.System.Warning
		}
	}

	if v9[v7] then
		priceLineContent = v9[v7]
	end

	return priceLineContent
end

return getPriceLineContent
