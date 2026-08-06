local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local AvatarExperienceFlags = require(AvatarExperienceCommonParent.AvatarExperienceFlags)

require(AvatarExperienceCommon.Types.TryOnItemComparisonData)

local Constants = require(AvatarExperienceCommon.Constants)
local ItemTypeEnum = require(AvatarExperienceCommon.Enums.ItemTypeEnum)
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport

function shouldReplaceTryOn(p1, p2) -- line: 22
	-- upvalues: ItemTypeEnum (copy), FFlagAXCatalogMakeupSupport (copy), Constants (copy)
	if p1.isDynamicHead and p2.isClassicHeadOrFace then
		return true
	end

	if p1.isClassicHeadOrFace and p2.isDynamicHead then
		return true
	end

	if p1.itemType == ItemTypeEnum.Asset and p2.itemType == ItemTypeEnum.Asset then
		if p1.itemSubType == p2.itemSubType and (not FFlagAXCatalogMakeupSupport or not Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p2.itemSubType]) then
			return true
		end

		for v9, _ in p2.layeredClothingCategories do
			if p1.layeredClothingCategories[v9] then
				return true
			end
		end
	end

	if p1.itemType == ItemTypeEnum.Bundle then
		if p2.itemType == ItemTypeEnum.Bundle and p1.itemSubType == p2.itemSubType then
			return true
		end

		local v11 = p2.itemType == ItemTypeEnum.Bundle and p2.itemSubType == tostring(Enum.BundleType.BodyParts.Value)

		for v12, _ in p1.assetTypes do
			if p2.assetTypes[v12] and not v11 then
				return true
			end
		end

		for v14, _ in p1.layeredClothingCategories do
			if p2.layeredClothingCategories[v14] and not v11 then
				return true
			end
		end
	end

	return false
end

return shouldReplaceTryOn
