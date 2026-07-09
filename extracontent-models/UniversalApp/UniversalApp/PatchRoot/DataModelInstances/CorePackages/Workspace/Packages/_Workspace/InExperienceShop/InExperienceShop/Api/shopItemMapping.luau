local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)

local formatUpdatedDate = require(InExperienceShop.Utils.formatUpdatedDate)
local FFlagShopProductsUseDisplayName = require(InExperienceShop.Flags.FFlagShopProductsUseDisplayName)

local function toShopItemName(p1) -- line: 76
	-- upvalues: FFlagShopProductsUseDisplayName (copy)
	if FFlagShopProductsUseDisplayName then
		return p1.DisplayName or p1.Name
	end

	return p1.Name
end

return {
	makeRequestKey = function(n1: number, p2) -- line: 28
		return tostring(n1) .. ":" .. tostring(p2)
	end,
	toShopItemThumbnail = function(p3) -- line: 37
		if p3 == nil then
			return ""
		end

		return "rbxassetid://" .. tostring(p3)
	end,
	toShopItemCreator = function(p4) -- line: 50
		if p4 == nil then
			return nil
		end

		return {
			name = p4.Name,
			hasVerifiedBadge = p4.HasVerifiedBadge == true
		}
	end,
	toShopItem = function(p5, p6, n2: number) -- line: 83
		-- upvalues: FFlagShopProductsUseDisplayName (copy), formatUpdatedDate (copy)
		local v13 = if p6 ~= "Product" then tostring(n2) else tostring(p5.ProductId)
		local t1 = {
			isOwned = false,
			id = v13,
			name = if not FFlagShopProductsUseDisplayName then p5.Name else p5.DisplayName or p5.Name
		}
		local IconImageAssetId = p5.IconImageAssetId

		t1.thumbnail = if IconImageAssetId ~= nil then "rbxassetid://" .. tostring(IconImageAssetId) else ""
		t1.price = p5.PriceInRobux
		t1.description = p5.Description
		t1.updated = formatUpdatedDate(p5.Updated)
		t1.itemType = p6

		local Creator = p5.Creator

		t1.creator = if Creator ~= nil then {
			name = Creator.Name,
			hasVerifiedBadge = Creator.HasVerifiedBadge == true
		} else nil

		return t1
	end
}
