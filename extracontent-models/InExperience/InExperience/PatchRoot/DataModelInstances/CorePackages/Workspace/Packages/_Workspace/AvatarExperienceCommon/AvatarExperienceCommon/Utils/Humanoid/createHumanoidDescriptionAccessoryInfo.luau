local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local Constants = require(AvatarExperienceCommon.Constants)
require(AvatarExperienceCommon.Types.CategoryTypes.CategoryTypes)
require(AvatarExperienceCommon.Types.CommonTypes)

local function createHumanoidDescriptionAccessoryInfo(p, p2, options)
	local assetId = tonumber(p2)
	assert(assetId ~= nil, "assetIdAsNumber is not nil. Silence type checker.")
	local v = options or {}
	return {
		AssetId = assetId,
		Order = v.order,
		AccessoryType = v.type or Constants.ASSET_TYPE_TO_ACCESSORY_TYPE[p],
		IsLayered = v.isLayered,
		Position = v.position,
		Rotation = v.rotation,
		Scale = v.scale
	}
end

return createHumanoidDescriptionAccessoryInfo
