local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local Constants = require(AvatarExperienceCommon.Constants)

local function isSpawnEffectAssetType(p: string): boolean
	return p == Constants.SPAWN_EFFECT_ASSET_TYPE_ID_STRING
end

return isSpawnEffectAssetType
