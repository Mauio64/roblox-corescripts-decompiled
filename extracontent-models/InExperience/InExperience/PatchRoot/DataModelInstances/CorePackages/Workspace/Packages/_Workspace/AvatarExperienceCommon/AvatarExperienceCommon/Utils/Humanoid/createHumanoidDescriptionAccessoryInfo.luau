local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local Constants = require(AvatarExperienceCommon.Constants)

require(AvatarExperienceCommon.Types.CategoryTypes.CategoryTypes)
require(AvatarExperienceCommon.Types.CommonTypes)

local function createHumanoidDescriptionAccessoryInfo(p1, p2, t1: {[any]: any}) -- line: 27
	-- upvalues: Constants (copy)
	local num = tonumber(p2)

	assert(num ~= nil, "assetIdAsNumber is not nil. Silence type checker.")

	local v8 = t1 or {}

	return {
		AssetId = num,
		Order = v8.order,
		AccessoryType = v8.type or Constants.ASSET_TYPE_TO_ACCESSORY_TYPE[p1],
		IsLayered = v8.isLayered,
		Position = v8.position,
		Rotation = v8.rotation,
		Scale = v8.scale
	}
end

return createHumanoidDescriptionAccessoryInfo
