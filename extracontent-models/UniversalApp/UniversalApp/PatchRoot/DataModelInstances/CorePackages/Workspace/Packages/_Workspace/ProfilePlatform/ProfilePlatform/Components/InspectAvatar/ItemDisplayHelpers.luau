local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Enums = require(ProfilePlatform.Common.Enums)
local UserLib = require(ProfilePlatformParent.UserLib)
local AvatarExperienceInspectAndBuy = require(ProfilePlatformParent.AvatarExperienceInspectAndBuy)
local Constants = AvatarExperienceInspectAndBuy.Constants
local getPriceStatusInShop = AvatarExperienceInspectAndBuy.Utils.getPriceStatusInShop
local PriceStatus = AvatarExperienceInspectAndBuy.Enums.PriceStatus
local Constants2 = UserLib.Utils.Constants
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions

require(ProfilePlatform.Common.Types)

local Asset = Constants2.RbxthumbTypes.Asset
local BundleThumbnail = Constants2.RbxthumbTypes.BundleThumbnail
local t1 = {
	Shirt = "Classic Shirt",
	Pants = "Classic Pants",
	TShirt = "Classic T-Shirt",
	TShirtAccessory = "T-Shirt",
	DressSkirtAccessory = "Dresses & Skirts"
}

local function isBundle(p1) -- line: 38
	-- upvalues: Enums (copy)
	return p1.itemType == Enums.ItemTypes.Bundle or p1.itemType == "Bundle"
end
local function getAssetTypeDisplayName(s1: string?, t2: {[any]: any}?) -- line: 47
	-- upvalues: t1 (copy)
	if not s1 then
		return ""
	end

	if t2 and t2[s1] then
		return t2[s1]
	end

	local num = tonumber(s1)

	if not num then
		return t1[s1] or s1
	end

	for _, v24 in Enum.AvatarAssetType:GetEnumItems() do
		if num == v24.Value then
			return t1[v24.Name] or v24.Name:gsub("(%l)(%u)", "%1 %2")
		end
	end

	return ""
end

return {
	isPurchasableStatus = function(s2: string) -- line: 32
		-- upvalues: PriceStatus (copy)
		return s2 == PriceStatus.Free or (s2 == PriceStatus.PurchaseFromRoblox or s2 == PriceStatus.PurchaseFromResale)
	end,
	getPriceStatus = function(p2) -- line: 96
		-- upvalues: getPriceStatusInShop (copy)
		return getPriceStatusInShop(p2)
	end,
	PriceStatusEnum = PriceStatus,
	getThumbnailUrl = function(p3) -- line: 42
		-- upvalues: Enums (copy), BundleThumbnail (copy), Asset (copy), getRbxthumbWithTypeSizeAndOptions (copy)
		local v19 = if not (p3.itemType == Enums.ItemTypes.Bundle or p3.itemType == "Bundle") then Asset else BundleThumbnail

		return getRbxthumbWithTypeSizeAndOptions(p3.id, v19, 150)
	end,
	getItemTypeDisplayName = function(p4, p5) -- line: 69
		-- upvalues: Enums (copy), getAssetTypeDisplayName (copy)
		if p4.taxonomyName then
			return p4.taxonomyName
		end

		local assetTypeNames = p5.assetTypeNames

		if p4.itemType == Enums.ItemTypes.Bundle or p4.itemType == "Bundle" then
			if p4.itemSubType and assetTypeNames and assetTypeNames[p4.itemSubType] then
				return assetTypeNames[p4.itemSubType]
			end

			if p5 and p5.bundle then
				return p5.bundle
			end

			return "Bundle"
		end

		return (getAssetTypeDisplayName(p4.itemSubType, assetTypeNames))
	end,
	shouldShowBundleParts = function(p6) -- line: 86
		-- upvalues: getPriceStatusInShop (copy), PriceStatus (copy)
		local v29 = getPriceStatusInShop(p6)

		if p6.isOwned or v29 ~= PriceStatus.Free and (v29 ~= PriceStatus.PurchaseFromRoblox and v29 ~= PriceStatus.PurchaseFromResale) then
			return false
		end

		return p6.bundlePartsCount ~= nil and p6.bundlePartsCount > 0
	end,
	ASSET_TYPE_LOCALIZATION_KEYS = Constants.AssetLocalizationKeys,
	BUNDLE_TYPE_LOCALIZATION_KEYS = Constants.BundleLocalizationKeys,
	PRICE_STATUS_LOCALIZATION_KEYS = Constants.PriceStatusLocalizationKeys
}
