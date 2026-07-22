local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local Constants = require(AvatarExperienceCommon.Constants)

local function isMakeupAssetType(s1: string) -- line: 7
	-- upvalues: Constants (copy)
	return Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[s1] ~= nil
end

return isMakeupAssetType
