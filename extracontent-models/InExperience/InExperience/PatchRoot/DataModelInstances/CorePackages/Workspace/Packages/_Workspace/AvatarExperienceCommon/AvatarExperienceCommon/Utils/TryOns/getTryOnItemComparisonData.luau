local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local ItemTypeEnum = require(AvatarExperienceCommon.Enums.ItemTypeEnum)

require(AvatarExperienceCommon.Types.TryOnItemComparisonData)

local t1 = {
	[tostring(Enum.AssetType.ShirtAccessory.Value)] = "LCTops",
	[tostring(Enum.AssetType.TShirtAccessory.Value)] = "LCTops",
	[tostring(Enum.AssetType.SweaterAccessory.Value)] = "LCTops",
	[tostring(Enum.AssetType.PantsAccessory.Value)] = "LCBottoms",
	[tostring(Enum.AssetType.ShortsAccessory.Value)] = "LCBottoms",
	[tostring(Enum.AssetType.DressSkirtAccessory.Value)] = "LCBottoms"
}

function getTryOnItemComparisonData(t2: {[any]: any}) -- line: 16
	-- upvalues: t1 (copy), ItemTypeEnum (copy)
	local t3 = {}
	local t4 = {}
	local v7 = false
	local v8 = false

	local function addAssetTypeAndLayeredClothingCategory(s1: string) -- line: 26
		-- upvalues: t3 (copy), t1 (copy), t4 (copy)
		t3[s1] = true

		local v17 = t1[s1]

		if v17 then
			t4[v17] = true
		end
	end

	if t2.itemType == ItemTypeEnum.Asset then
		local itemSubType = t2.itemSubType

		t3[itemSubType] = true

		local v11 = t1[itemSubType]

		if v11 then
			t4[v11] = true
		end

		if t2.itemSubType == tostring(Enum.AssetType.Head.Value) or t2.itemSubType == tostring(Enum.AssetType.Face.Value) then
			v7 = true
		end
	elseif t2.itemType == ItemTypeEnum.Bundle and t2.bundleInfo then
		if t2.itemSubType == tostring(Enum.BundleType.DynamicHead.Value) then
			v8 = true
		end

		for _, v13 in t2.bundleInfo do
			local assetType = v13.assetType

			t3[assetType] = true

			local v15 = t1[assetType]

			if v15 then
				t4[v15] = true
			end
		end
	end

	return {
		assetTypes = t3,
		layeredClothingCategories = t4,
		isClassicHeadOrFace = v7,
		isDynamicHead = v8,
		itemType = t2.itemType,
		itemSubType = t2.itemSubType
	}
end

return getTryOnItemComparisonData
