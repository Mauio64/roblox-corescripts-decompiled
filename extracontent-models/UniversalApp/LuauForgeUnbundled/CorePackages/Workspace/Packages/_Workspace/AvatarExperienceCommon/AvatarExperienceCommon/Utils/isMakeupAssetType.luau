local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")

local function isMakeupAssetType(p2): boolean
	return Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE[p2] ~= nil
end

return isMakeupAssetType
