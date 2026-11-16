local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local ASSET_TYPE_NAME_TO_ID_STRING = AvatarExperienceCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING

local assetCategory = { LCTops = "LCTops", LCBottoms = "LCBottoms" }

local assetCategoryToAssetTypes = {
	[assetCategory.LCTops] = {
		ASSET_TYPE_NAME_TO_ID_STRING.ShirtAccessory,
		ASSET_TYPE_NAME_TO_ID_STRING.TShirtAccessory,
		ASSET_TYPE_NAME_TO_ID_STRING.SweaterAccessory
	},
	[assetCategory.LCBottoms] = {
		ASSET_TYPE_NAME_TO_ID_STRING.PantsAccessory,
		ASSET_TYPE_NAME_TO_ID_STRING.ShortsAccessory,
		ASSET_TYPE_NAME_TO_ID_STRING.DressSkirtAccessory
	}
}

local assetTypeToAssetCategory = {}

for k, v in assetCategoryToAssetTypes do
	for _, v2 in v do
		assetTypeToAssetCategory[v2] = k
	end
end

return {
	AssetCategory = assetCategory,
	AssetCategoryToAssetTypes = assetCategoryToAssetTypes,
	AssetTypeToAssetCategory = assetTypeToAssetCategory
}
