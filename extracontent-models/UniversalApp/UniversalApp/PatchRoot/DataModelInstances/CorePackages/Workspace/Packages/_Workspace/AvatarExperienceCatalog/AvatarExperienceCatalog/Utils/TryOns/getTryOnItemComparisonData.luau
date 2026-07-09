local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local AvatarExperienceCommon = require(AvatarExperienceCatalogParent.AvatarExperienceCommon)

require(AvatarExperienceCatalog.Types)

local ItemTypeEnum = AvatarExperienceCommon.Enums.ItemTypeEnum
local t1 = {
	[tostring(Enum.AssetType.ShirtAccessory.Value)] = "LCTops",
	[tostring(Enum.AssetType.TShirtAccessory.Value)] = "LCTops",
	[tostring(Enum.AssetType.SweaterAccessory.Value)] = "LCTops",
	[tostring(Enum.AssetType.PantsAccessory.Value)] = "LCBottoms",
	[tostring(Enum.AssetType.ShortsAccessory.Value)] = "LCBottoms",
	[tostring(Enum.AssetType.DressSkirtAccessory.Value)] = "LCBottoms"
}

function getTryOnItemComparisonData(t2: {[any]: any}) -- line: 19
	-- upvalues: t1 (copy), ItemTypeEnum (copy)
	local t3 = {}
	local t4 = {}
	local v9 = false
	local v10 = false

	local function addAssetTypeAndLayeredClothingCategory(s1: string) -- line: 29
		-- upvalues: t3 (copy), t1 (copy), t4 (copy)
		t3[s1] = true

		local v19 = t1[s1]

		if v19 then
			t4[v19] = true
		end
	end

	if t2.itemType == ItemTypeEnum.Asset then
		local itemSubType = t2.itemSubType

		t3[itemSubType] = true

		local v13 = t1[itemSubType]

		if v13 then
			t4[v13] = true
		end

		if t2.itemSubType == tostring(Enum.AssetType.Head.Value) or t2.itemSubType == tostring(Enum.AssetType.Face.Value) then
			v9 = true
		end
	elseif t2.itemType == ItemTypeEnum.Bundle and t2.bundleInfo then
		if t2.itemSubType == tostring(Enum.BundleType.DynamicHead.Value) then
			v10 = true
		end

		for _, v15 in t2.bundleInfo do
			local assetType = v15.assetType

			t3[assetType] = true

			local v17 = t1[assetType]

			if v17 then
				t4[v17] = true
			end
		end
	end

	return {
		assetTypes = t3,
		layeredClothingCategories = t4,
		isClassicHeadOrFace = v9,
		isDynamicHead = v10,
		itemType = t2.itemType,
		itemSubType = t2.itemSubType
	}
end

return getTryOnItemComparisonData
