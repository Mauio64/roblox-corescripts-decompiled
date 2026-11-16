local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local Constants = require(AvatarExperienceCommon.Constants)
local ASSET_TYPE_NAME_TO_ID_STRING = Constants.ASSET_TYPE_NAME_TO_ID_STRING
local isMakeupAssetType = require(AvatarExperienceCommon.Utils.isMakeupAssetType)

require(AvatarExperienceCommon.Types.CategoryTypes.CategoryTypes)
local OutfitTypes = require(AvatarExperienceCommon.Enums.OutfitTypes)

local function isValidAssetTypeForOutfitType(p: string, p2)
	if not p2 then
		return true
	end

	if p2 == OutfitTypes.Makeup then
		return isMakeupAssetType(p)
			or p == ASSET_TYPE_NAME_TO_ID_STRING.EyebrowAccessory
			or p == ASSET_TYPE_NAME_TO_ID_STRING.EyelashAccessory
	end

	return p2 == OutfitTypes.Avatar or p2 == OutfitTypes.EditableAvatar or true
end

return isValidAssetTypeForOutfitType
