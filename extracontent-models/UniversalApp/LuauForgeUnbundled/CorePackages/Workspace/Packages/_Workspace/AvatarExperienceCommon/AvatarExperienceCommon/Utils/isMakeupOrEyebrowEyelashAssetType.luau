local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")

local set = {
	[Constants.ASSET_TYPE_NAME_TO_ID_STRING.EyebrowAccessory] = true,
	[Constants.ASSET_TYPE_NAME_TO_ID_STRING.EyelashAccessory] = true
}

local function isMakeupOrEyebrowEyelashAssetType(p2): boolean
	return Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p2] ~= nil or set[p2] == true
end

return isMakeupOrEyebrowEyelashAssetType
