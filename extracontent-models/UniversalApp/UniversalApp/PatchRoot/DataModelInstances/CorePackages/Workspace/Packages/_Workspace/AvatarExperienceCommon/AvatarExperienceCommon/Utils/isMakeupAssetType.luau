local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local AvatarExperienceFlags = require(AvatarExperienceCommonParent.AvatarExperienceFlags)
local Constants = require(AvatarExperienceCommon.Constants)
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport

local function isMakeupAssetType(s1: string) -- line: 11
	-- upvalues: FFlagAXCustomizeMakeupSupport (copy), Constants (copy)
	if not FFlagAXCustomizeMakeupSupport then
		return false
	end

	return Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[s1] ~= nil
end

return isMakeupAssetType
