local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local Constants = require(AvatarExperienceCommon.Constants)

local set = {
	[Constants.ASSET_TYPE_NAME_TO_ID_STRING.EyebrowAccessory] = true,
	[Constants.ASSET_TYPE_NAME_TO_ID_STRING.EyelashAccessory] = true
}

local function isMakeupOrEyebrowEyelashAssetType(p: string): boolean
	return Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p] ~= nil or set[p] == true
end

return isMakeupOrEyebrowEyelashAssetType
