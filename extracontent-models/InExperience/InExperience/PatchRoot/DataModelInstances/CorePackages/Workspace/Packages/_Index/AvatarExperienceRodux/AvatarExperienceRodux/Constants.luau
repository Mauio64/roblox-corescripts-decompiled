local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local ASSET_TYPE_NAME_TO_ID_STRING = require(Parent.AvatarExperienceCommon).Constants.ASSET_TYPE_NAME_TO_ID_STRING
local t1 = {
	LCTops = "LCTops",
	LCBottoms = "LCBottoms"
}
local t2 = {
	[t1.LCTops] = {
		ASSET_TYPE_NAME_TO_ID_STRING.ShirtAccessory,
		ASSET_TYPE_NAME_TO_ID_STRING.TShirtAccessory,
		ASSET_TYPE_NAME_TO_ID_STRING.SweaterAccessory
	},
	[t1.LCBottoms] = {
		ASSET_TYPE_NAME_TO_ID_STRING.PantsAccessory,
		ASSET_TYPE_NAME_TO_ID_STRING.ShortsAccessory,
		ASSET_TYPE_NAME_TO_ID_STRING.DressSkirtAccessory
	}
}
local t3 = {}

for v6, v7 in t2 do
	for _, v9 in v7 do
		t3[v9] = v6
	end
end

return {
	AssetCategory = t1,
	AssetCategoryToAssetTypes = t2,
	AssetTypeToAssetCategory = t3
}
