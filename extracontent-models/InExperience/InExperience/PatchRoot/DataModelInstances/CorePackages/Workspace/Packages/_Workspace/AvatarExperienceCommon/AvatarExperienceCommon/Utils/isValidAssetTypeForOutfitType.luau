local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local ASSET_TYPE_NAME_TO_ID_STRING = require(AvatarExperienceCommon.Constants).ASSET_TYPE_NAME_TO_ID_STRING
local isMakeupAssetType = require(AvatarExperienceCommon.Utils.isMakeupAssetType)

require(AvatarExperienceCommon.Types.CategoryTypes.CategoryTypes)

local OutfitTypes = require(AvatarExperienceCommon.Enums.OutfitTypes)

local function isValidAssetTypeForOutfitType(s1: string, p1) -- line: 11
	-- upvalues: OutfitTypes (copy), isMakeupAssetType (copy), ASSET_TYPE_NAME_TO_ID_STRING (copy)
	if not p1 then
		return true
	end

	if p1 == OutfitTypes.Makeup then
		return isMakeupAssetType(s1) or (s1 == ASSET_TYPE_NAME_TO_ID_STRING.EyebrowAccessory or s1 == ASSET_TYPE_NAME_TO_ID_STRING.EyelashAccessory)
	end

	if p1 == OutfitTypes.Avatar or p1 == OutfitTypes.EditableAvatar then
		return true
	end

	return true
end

return isValidAssetTypeForOutfitType
