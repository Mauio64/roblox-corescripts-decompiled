local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local parent = AvatarExperienceCommon.Parent
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

require(AvatarExperienceCommon.Types.TryOnItemComparisonData)
local Constants = require(AvatarExperienceCommon.Constants)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport

function shouldReplaceTryOn(data, data2): boolean
	if data.isDynamicHead and data2.isClassicHeadOrFace or data.isClassicHeadOrFace and data2.isDynamicHead then
		return true
	end

	if data.itemType == ItemTypeEnum.Asset and data2.itemType == ItemTypeEnum.Asset then
		if
			data.itemSubType == data2.itemSubType
			and not (FFlagAXCatalogMakeupSupport and Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[data2.itemSubType])
		then
			return true
		end

		for k, _ in data2.layeredClothingCategories do
			if data.layeredClothingCategories[k] then
				return true
			end
		end
	end

	if data.itemType ~= ItemTypeEnum.Bundle then
		return false
	end

	if data2.itemType == ItemTypeEnum.Bundle and data.itemSubType == data2.itemSubType then
		return true
	end

	local v

	if data2.itemType == ItemTypeEnum.Bundle then
		v = data2.itemSubType == tostring(Enum.BundleType.BodyParts.Value)
	else
		v = false
	end

	for k, _ in data.assetTypes do
		if data2.assetTypes[k] and not v then
			return true
		end
	end

	for k, _ in data.layeredClothingCategories do
		if data2.layeredClothingCategories[k] and not v then
			return true
		end
	end

	return false
end

return shouldReplaceTryOn
