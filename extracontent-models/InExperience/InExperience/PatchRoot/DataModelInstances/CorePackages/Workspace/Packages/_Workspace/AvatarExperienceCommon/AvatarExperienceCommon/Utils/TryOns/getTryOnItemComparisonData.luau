local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceModel = require(AvatarExperienceCommon.Parent.AvatarExperienceModel)

local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

require(AvatarExperienceCommon.Types.TryOnItemComparisonData)

local v = {
	[tostring(Enum.AssetType.ShirtAccessory.Value)] = "LCTops",
	[tostring(Enum.AssetType.TShirtAccessory.Value)] = "LCTops",
	[tostring(Enum.AssetType.SweaterAccessory.Value)] = "LCTops",
	[tostring(Enum.AssetType.PantsAccessory.Value)] = "LCBottoms",
	[tostring(Enum.AssetType.ShortsAccessory.Value)] = "LCBottoms",
	[tostring(Enum.AssetType.DressSkirtAccessory.Value)] = "LCBottoms"
}

function getTryOnItemComparisonData(data)
	local set = {}
	local set2 = {}
	local isClassicHeadOrFace = false
	local isDynamicHead = false

	local function addAssetTypeAndLayeredClothingCategory(p: string) -- 2 equivalent calls inferred from this helper
		set[p] = true
		local v2 = v[p]

		if v2 then
			set2[v2] = true
		end
	end

	if data.itemType == ItemTypeEnum.Asset then
		addAssetTypeAndLayeredClothingCategory(data.itemSubType) -- inferred equivalent call

		if
			data.itemSubType == tostring(Enum.AssetType.Head.Value)
			or data.itemSubType == tostring(Enum.AssetType.Face.Value)
		then
			isClassicHeadOrFace = true
		end
	elseif data.itemType == ItemTypeEnum.Bundle and data.bundleInfo then
		isDynamicHead = data.itemSubType == tostring(Enum.BundleType.DynamicHead.Value) or false

		for _, v2 in data.bundleInfo do
			addAssetTypeAndLayeredClothingCategory(v2.assetType) -- inferred equivalent call
		end
	end

	return {
		assetTypes = set,
		layeredClothingCategories = set2,
		isClassicHeadOrFace = isClassicHeadOrFace,
		isDynamicHead = isDynamicHead,
		itemType = data.itemType,
		itemSubType = data.itemSubType
	}
end

return getTryOnItemComparisonData
