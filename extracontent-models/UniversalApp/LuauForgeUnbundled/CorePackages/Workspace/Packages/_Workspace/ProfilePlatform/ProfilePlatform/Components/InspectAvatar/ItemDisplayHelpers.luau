local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserLib")
local AvatarExperienceInspectAndBuy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AvatarExperienceInspectAndBuy")
local constants = AvatarExperienceInspectAndBuy.Constants
local getPriceStatusInShop = AvatarExperienceInspectAndBuy.Utils.getPriceStatusInShop
local priceStatus = AvatarExperienceInspectAndBuy.Enums.PriceStatus

local constants2 = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")

local asset = constants2.RbxthumbTypes.Asset
local bundleThumbnail = constants2.RbxthumbTypes.BundleThumbnail

local v5 = {
	Shirt = "Classic Shirt",
	Pants = "Classic Pants",
	TShirt = "Classic T-Shirt",
	TShirtAccessory = "T-Shirt",
	DressSkirtAccessory = "Dresses & Skirts"
}

local function isBundle(p2): boolean
	return p2.itemType == Enums.ItemTypes.Bundle or p2.itemType == "Bundle"
end

local function getAssetTypeDisplayName(itemSubType, assetTypeNames)
	if not itemSubType then
		return ""
	end

	if assetTypeNames and assetTypeNames[itemSubType] then
		return assetTypeNames[itemSubType]
	end

	local v6 = tonumber(itemSubType)

	if not v6 then
		return v5[itemSubType] or itemSubType
	end

	for k, v7 in Enum.AvatarAssetType:GetEnumItems() do
		if v7.Value == v6 then
			return v5[v7.Name] or v7.Name:gsub("(%l)(%u)", "%1 %2")
		end
	end

	return ""
end

return {
	isPurchasableStatus = function(p2): boolean
		return p2 == priceStatus.Free
			or p2 == priceStatus.PurchaseFromRoblox
			or p2 == priceStatus.PurchaseFromResale
	end,
	getPriceStatus = function(p2)
		return getPriceStatusInShop(p2)
	end,
	PriceStatusEnum = priceStatus,
	getThumbnailUrl = function(p2)
		local v6 = if p2.itemType == Enums.ItemTypes.Bundle or p2.itemType == "Bundle" then bundleThumbnail else asset

		return getRbxthumbWithTypeSizeAndOptions(p2.id, v6, 150)
	end,
	getItemTypeDisplayName = function(data, p2)
		if data.taxonomyName then
			return data.taxonomyName
		end

		local assetTypeNames = p2.assetTypeNames

		if data.itemType ~= Enums.ItemTypes.Bundle and data.itemType ~= "Bundle" then
			return getAssetTypeDisplayName(data.itemSubType, assetTypeNames)
		end

		if data.itemSubType and assetTypeNames and assetTypeNames[data.itemSubType] then
			return assetTypeNames[data.itemSubType]
		end

		if p2 and p2.bundle then
			return p2.bundle
		end

		return "Bundle"
	end,
	shouldShowBundleParts = function(p2): boolean
		local priceStatusInShop = getPriceStatusInShop(p2)

		if
			p2.isOwned
			or priceStatusInShop ~= priceStatus.Free
			and priceStatusInShop ~= priceStatus.PurchaseFromRoblox
			and priceStatusInShop ~= priceStatus.PurchaseFromResale
		then
			return false
		end

		return p2.bundlePartsCount ~= nil and p2.bundlePartsCount > 0
	end,
	ASSET_TYPE_LOCALIZATION_KEYS = constants.AssetLocalizationKeys,
	BUNDLE_TYPE_LOCALIZATION_KEYS = constants.BundleLocalizationKeys,
	PRICE_STATUS_LOCALIZATION_KEYS = constants.PriceStatusLocalizationKeys
}
