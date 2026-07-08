local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local AvatarExperienceFlags = require(AvatarExperienceCommonParent.AvatarExperienceFlags)
local Constants = require(AvatarExperienceCommon.Constants)
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local t1 = {
	[Constants.ASSET_TYPE_NAME_TO_ID_STRING.EyebrowAccessory] = true,
	[Constants.ASSET_TYPE_NAME_TO_ID_STRING.EyelashAccessory] = true
}

local function isMakeupOrEyebrowEyelashAssetType(s1: string) -- line: 16
	-- upvalues: FFlagAXCustomizeMakeupSupport (copy), Constants (copy), t1 (copy)
	if not FFlagAXCustomizeMakeupSupport then
		return false
	end

	return Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[s1] ~= nil or t1[s1] == true
end

return isMakeupOrEyebrowEyelashAssetType
