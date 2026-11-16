local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local Constants = require(AvatarExperienceCommon.Constants)

local function isMakeupAssetType(p: string): boolean
	return Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p] ~= nil
end

return isMakeupAssetType
