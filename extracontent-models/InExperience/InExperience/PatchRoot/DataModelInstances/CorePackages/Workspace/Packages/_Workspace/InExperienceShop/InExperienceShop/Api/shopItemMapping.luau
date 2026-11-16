local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)
local formatUpdatedDate = require(InExperienceShop.Utils.formatUpdatedDate)
local FFlagShopProductsUseDisplayName = require(InExperienceShop.Flags.FFlagShopProductsUseDisplayName)

local function toShopItemThumbnail(iconImageAssetId) -- 1 equivalent call inferred from this helper
	if iconImageAssetId == nil then
		return ""
	end

	return "rbxassetid://" .. tostring(iconImageAssetId)
end

local function toShopItemCreator(creator) -- 1 equivalent call inferred from this helper
	if creator == nil then
		return nil
	end

	return {
		name = creator.Name,
		hasVerifiedBadge = creator.HasVerifiedBadge == true
	}
end

local function toShopItemName(data) -- 1 equivalent call inferred from this helper
	if FFlagShopProductsUseDisplayName then
		return data.DisplayName or data.Name
	end

	return data.Name
end

local ShopItemMapping = {}

function ShopItemMapping.makeRequestKey(p: number, p2)
	return tostring(p) .. ":" .. tostring(p2)
end

ShopItemMapping.toShopItemThumbnail = toShopItemThumbnail
ShopItemMapping.toShopItemCreator = toShopItemCreator

function ShopItemMapping.toShopItem(data, itemType, p: number)
	local id

	if itemType == "Product" then
		id = tostring(data.ProductId)
	else
		id = tostring(p)
	end

	return {
		id = id,
		name = toShopItemName(data), -- inferred equivalent call
		thumbnail = toShopItemThumbnail(data.IconImageAssetId), -- inferred equivalent call
		price = data.PriceInRobux,
		userBasePriceInRobux = data.UserBasePriceInRobux or data.BasePriceInRobux,
		description = data.Description,
		updated = formatUpdatedDate(data.Updated),
		isOwned = false,
		itemType = itemType,
		creator = toShopItemCreator(data.Creator) -- inferred equivalent call
	}
end

return ShopItemMapping
