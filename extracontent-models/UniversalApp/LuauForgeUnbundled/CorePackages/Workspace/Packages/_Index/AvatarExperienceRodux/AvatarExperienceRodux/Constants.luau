local ASSET_TYPE_NAME_TO_ID_STRING = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceCommon").Constants.ASSET_TYPE_NAME_TO_ID_STRING

local v5 = { LCTops = "LCTops", LCBottoms = "LCBottoms" }

local v6 = {
	[v5.LCTops] = {
		ASSET_TYPE_NAME_TO_ID_STRING.ShirtAccessory,
		ASSET_TYPE_NAME_TO_ID_STRING.TShirtAccessory,
		ASSET_TYPE_NAME_TO_ID_STRING.SweaterAccessory
	},
	[v5.LCBottoms] = {
		ASSET_TYPE_NAME_TO_ID_STRING.PantsAccessory,
		ASSET_TYPE_NAME_TO_ID_STRING.ShortsAccessory,
		ASSET_TYPE_NAME_TO_ID_STRING.DressSkirtAccessory
	}
}

local v7 = {}

for k, v8 in v6 do
	for k2, v9 in v8 do
		v7[v9] = k
	end
end

return {
	AssetCategory = v5,
	AssetCategoryToAssetTypes = v6,
	AssetTypeToAssetCategory = v7
}
