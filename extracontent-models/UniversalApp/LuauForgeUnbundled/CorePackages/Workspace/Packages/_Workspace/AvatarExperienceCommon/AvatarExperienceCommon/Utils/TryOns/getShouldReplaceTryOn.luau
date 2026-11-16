local AvatarExperienceModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceModel")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceFlags")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/TryOnItemComparisonData")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")
local itemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

local fFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport

function LUAUFORGE_MODULE_GLOBALS_avh_shouldReplaceTryOn(data, data2): boolean
	if
		data.isDynamicHead and data2.isClassicHeadOrFace
		or data.isClassicHeadOrFace and data2.isDynamicHead
	then
		return true
	end

	if data.itemType == itemTypeEnum.Asset and data2.itemType == itemTypeEnum.Asset then
		if
			data.itemSubType == data2.itemSubType
			and not (fFlagAXCatalogMakeupSupport and Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[data2.itemSubType])
		then
			return true
		end

		for k, layeredClothingCategory in data2.layeredClothingCategories do
			if data.layeredClothingCategories[k] then
				return true
			end
		end
	end

	if data.itemType ~= itemTypeEnum.Bundle then
		return false
	end

	if data2.itemType == itemTypeEnum.Bundle and data.itemSubType == data2.itemSubType then
		return true
	end

	local v5

	if data2.itemType == itemTypeEnum.Bundle then
		v5 = data2.itemSubType == tostring(Enum.BundleType.BodyParts.Value)
	else
		v5 = false
	end

	for k, assetType in data.assetTypes do
		if data2.assetTypes[k] and not v5 then
			return true
		end
	end

	for k, layeredClothingCategory in data.layeredClothingCategories do
		if data2.layeredClothingCategories[k] and not v5 then
			return true
		end
	end

	return false
end

return LUAUFORGE_MODULE_GLOBALS_avh_shouldReplaceTryOn
