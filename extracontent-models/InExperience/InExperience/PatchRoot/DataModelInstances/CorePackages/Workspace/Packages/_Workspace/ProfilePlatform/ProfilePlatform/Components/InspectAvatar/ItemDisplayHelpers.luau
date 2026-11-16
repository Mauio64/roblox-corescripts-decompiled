local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Enums = require(ProfilePlatform.Common.Enums)
local UserLib = require(parent.UserLib)
local AvatarExperienceInspectAndBuy = require(parent.AvatarExperienceInspectAndBuy)
local Constants = AvatarExperienceInspectAndBuy.Constants
local getPriceStatusInShop = AvatarExperienceInspectAndBuy.Utils.getPriceStatusInShop
local PriceStatus = AvatarExperienceInspectAndBuy.Enums.PriceStatus

local constants = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

require(ProfilePlatform.Common.Types)

local Asset = constants.RbxthumbTypes.Asset
local BundleThumbnail = constants.RbxthumbTypes.BundleThumbnail

local v = {
	Shirt = "Classic Shirt",
	Pants = "Classic Pants",
	TShirt = "Classic T-Shirt",
	TShirtAccessory = "T-Shirt",
	DressSkirtAccessory = "Dresses & Skirts"
}

local function isBundle(p): boolean -- 1 equivalent call inferred from this helper
	return p.itemType == Enums.ItemTypes.Bundle or p.itemType == "Bundle"
end

local function getAssetTypeDisplayName(itemSubType: string?, assetTypeNames)
	if not itemSubType then
		return ""
	end

	if assetTypeNames and assetTypeNames[itemSubType] then
		return assetTypeNames[itemSubType]
	end

	local v2 = tonumber(itemSubType)

	if not v2 then
		return v[itemSubType] or itemSubType
	end

	for _, v3 in Enum.AvatarAssetType:GetEnumItems() do
		if v3.Value == v2 then
			return v[v3.Name] or v3.Name:gsub("(%l)(%u)", "%1 %2")
		end
	end

	return ""
end

local ItemDisplayHelpers = {}

function ItemDisplayHelpers.isPurchasableStatus(p: string): boolean
	return p == PriceStatus.Free or p == PriceStatus.PurchaseFromRoblox or p == PriceStatus.PurchaseFromResale
end

function ItemDisplayHelpers.getPriceStatus(p)
	return getPriceStatusInShop(p)
end

ItemDisplayHelpers.PriceStatusEnum = PriceStatus

function ItemDisplayHelpers.getThumbnailUrl(p)
	local v2

	if isBundle(p) then -- inferred equivalent call
		v2 = BundleThumbnail
	else
		v2 = Asset
	end

	return getRbxthumbWithTypeSizeAndOptions(p.id, v2, 150)
end

function ItemDisplayHelpers.getItemTypeDisplayName(data, p)
	if data.taxonomyName then
		return data.taxonomyName
	end

	local assetTypeNames = p.assetTypeNames

	if data.itemType ~= Enums.ItemTypes.Bundle and data.itemType ~= "Bundle" then
		return getAssetTypeDisplayName(data.itemSubType, assetTypeNames)
	end

	if data.itemSubType and assetTypeNames and assetTypeNames[data.itemSubType] then
		return assetTypeNames[data.itemSubType]
	end

	return if p and p.bundle then p.bundle else "Bundle"
end

function ItemDisplayHelpers.shouldShowBundleParts(p): boolean
	local priceStatusInShop = getPriceStatusInShop(p)

	if
		p.isOwned
		or priceStatusInShop ~= PriceStatus.Free
		and priceStatusInShop ~= PriceStatus.PurchaseFromRoblox
		and priceStatusInShop ~= PriceStatus.PurchaseFromResale
	then
		return false
	end

	return p.bundlePartsCount ~= nil and p.bundlePartsCount > 0
end

ItemDisplayHelpers.ASSET_TYPE_LOCALIZATION_KEYS = Constants.AssetLocalizationKeys
ItemDisplayHelpers.BUNDLE_TYPE_LOCALIZATION_KEYS = Constants.BundleLocalizationKeys
ItemDisplayHelpers.PRICE_STATUS_LOCALIZATION_KEYS = Constants.PriceStatusLocalizationKeys
return ItemDisplayHelpers
