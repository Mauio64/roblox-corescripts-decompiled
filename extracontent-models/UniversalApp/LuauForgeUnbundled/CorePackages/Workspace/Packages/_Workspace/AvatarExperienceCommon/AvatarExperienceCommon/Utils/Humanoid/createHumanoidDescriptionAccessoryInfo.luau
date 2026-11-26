local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/CategoryTypes/CategoryTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Types/CommonTypes")

local function createHumanoidDescriptionAccessoryInfo(p2, p3, options)
	local v5 = tonumber(p3)
	assert(v5 ~= nil, "assetIdAsNumber is not nil. Silence type checker.")
	local v6 = options or {}
	return {
		AssetId = v5,
		Order = v6.order,
		AccessoryType = v6.type or Constants.ASSET_TYPE_TO_ACCESSORY_TYPE[p2],
		IsLayered = v6.isLayered,
		Position = v6.position,
		Rotation = v6.rotation,
		Scale = v6.scale
	}
end

return createHumanoidDescriptionAccessoryInfo
