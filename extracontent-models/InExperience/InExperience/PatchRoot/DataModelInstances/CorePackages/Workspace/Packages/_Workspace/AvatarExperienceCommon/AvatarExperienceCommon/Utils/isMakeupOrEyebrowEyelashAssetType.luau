local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local Constants = require(AvatarExperienceCommon.Constants)
local t1 = {
	[Constants.ASSET_TYPE_NAME_TO_ID_STRING.EyebrowAccessory] = true,
	[Constants.ASSET_TYPE_NAME_TO_ID_STRING.EyelashAccessory] = true
}

local function isMakeupOrEyebrowEyelashAssetType(s1: string) -- line: 12
	-- upvalues: Constants (copy), t1 (copy)
	return Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[s1] ~= nil or t1[s1] == true
end

return isMakeupOrEyebrowEyelashAssetType
