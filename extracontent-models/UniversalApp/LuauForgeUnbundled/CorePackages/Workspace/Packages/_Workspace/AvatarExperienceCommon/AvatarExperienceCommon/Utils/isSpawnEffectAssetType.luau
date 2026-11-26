local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")

local function isSpawnEffectAssetType(p2): boolean
	return p2 == Constants.SPAWN_EFFECT_ASSET_TYPE_ID_STRING
end

return isSpawnEffectAssetType
