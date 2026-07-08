local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent

require(AvatarExperienceInspectAndBuyParent.AXCommon)
require(AvatarExperienceInspectAndBuyParent.Foundation)

local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)
local getPriceStatus = require(AvatarExperienceInspectAndBuy.Utils.getPriceStatus)

require(AvatarExperienceInspectAndBuy.Types)

local FFlagSocialEnableProfileInspectAndBuy = require(AvatarExperienceInspectAndBuyParent.SharedFlags).FFlagSocialEnableProfileInspectAndBuy
local v6 = if not FFlagSocialEnableProfileInspectAndBuy then nil else require(AvatarExperienceInspectAndBuy.Utils.getPriceStatusInShop)

local function getPriceLineContent(p1, p2, t1: {[any]: any}, t2: {[any]: any}?) -- line: 27
	-- upvalues: FFlagSocialEnableProfileInspectAndBuy (copy), v6 (copy), getPriceStatus (copy), PriceStatus (copy)
	local t3 = {}
	local v13

	if FFlagSocialEnableProfileInspectAndBuy and (t2 and t2.isShopContext) then
		assert(not t2.disableResaleWhenStockIsAvailable, "disableResaleWhenStockIsAvailable is not applicable when isShopContext is true")
		v13 = v6(p1)
	else
		v13 = getPriceStatus(p1, true)
	end

	local t4 = {
		[PriceStatus.Owned] = {{
			type = "text",
			text = t1[PriceStatus.Owned]
		}},
		[PriceStatus.Free] = {{
			type = "text",
			text = t1[PriceStatus.Free]
		}},
		[PriceStatus.QuantityLimitReached] = {{
			type = "text",
			colorStyle = p2.Color.System.Warning,
			text = t1[PriceStatus.QuantityLimitReached]
		}},
		[PriceStatus.InExperienceOnly] = {{
			type = "text",
			text = t1[PriceStatus.InExperienceOnly],
			colorStyle = p2.Color.System.Warning
		}},
		[PriceStatus.PurchaseFromRoblox] = {{
			type = "price",
			price = p1.priceInRobux
		}},
		[PriceStatus.PurchaseFromResale] = if not p1.isOffSale then {
			{
				type = "price",
				strikethrough = true,
				price = p1.priceInRobux
			},
			{
				type = "price",
				price = not p1.collectibleItemDetails and 0 or p1.collectibleItemDetails.lowestResalePrice,
				colorStyle = p2.Color.System.Warning
			}
		} else {{
			type = "price",
			price = not p1.collectibleItemDetails and 0 or p1.collectibleItemDetails.lowestResalePrice
		}},
		[PriceStatus.SoldOut] = {{
			type = "text",
			text = t1[PriceStatus.SoldOut],
			colorStyle = p2.Color.System.Warning
		}},
		[PriceStatus.OffSale] = {{
			type = "text",
			text = t1[PriceStatus.OffSale],
			colorStyle = p2.Color.System.Warning
		}},
		[PriceStatus.Unavailable] = {{
			type = "text",
			text = t1[PriceStatus.Unavailable],
			colorStyle = p2.Color.System.Warning
		}}
	}

	if t4[v13] then
		t3 = t4[v13]
	end

	return t3
end

return getPriceLineContent
