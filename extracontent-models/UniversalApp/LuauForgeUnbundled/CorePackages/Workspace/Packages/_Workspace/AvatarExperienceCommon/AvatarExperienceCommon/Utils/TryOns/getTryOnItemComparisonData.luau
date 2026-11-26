local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceModel").Enums.ItemTypeEnum

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/TryOnItemComparisonData")

local v5 = {
	[tostring(Enum.AssetType.ShirtAccessory.Value)] = "LCTops",
	[tostring(Enum.AssetType.TShirtAccessory.Value)] = "LCTops",
	[tostring(Enum.AssetType.SweaterAccessory.Value)] = "LCTops",
	[tostring(Enum.AssetType.PantsAccessory.Value)] = "LCBottoms",
	[tostring(Enum.AssetType.ShortsAccessory.Value)] = "LCBottoms",
	[tostring(Enum.AssetType.DressSkirtAccessory.Value)] = "LCBottoms"
}

function LUAUFORGE_MODULE_GLOBALS_aws_getTryOnItemComparisonData(data)
	local set = {}
	local set2 = {}
	local v6 = false
	local v7 = false

	local function addAssetTypeAndLayeredClothingCategory(p2)
		set[p2] = true
		local v8 = v5[p2]

		if v8 then
			set2[v8] = true
		end
	end

	if data.itemType == itemTypeEnum.Asset then
		local itemSubType = data.itemSubType
		set[itemSubType] = true
		local v8 = v5[itemSubType]

		if v8 then
			set2[v8] = true
		end

		if
			data.itemSubType == tostring(Enum.AssetType.Head.Value)
			or data.itemSubType == tostring(Enum.AssetType.Face.Value)
		then
			v6 = true
		end
	elseif data.itemType == itemTypeEnum.Bundle and data.bundleInfo then
		v7 = data.itemSubType == tostring(Enum.BundleType.DynamicHead.Value) or false

		for k, v8 in data.bundleInfo do
			local assetType = v8.assetType
			set[assetType] = true
			local v9 = v5[assetType]

			if v9 then
				set2[v9] = true
			end
		end
	end

	return {
		assetTypes = set,
		layeredClothingCategories = set2,
		isClassicHeadOrFace = v6,
		isDynamicHead = v7,
		itemType = data.itemType,
		itemSubType = data.itemSubType
	}
end

return LUAUFORGE_MODULE_GLOBALS_aws_getTryOnItemComparisonData
