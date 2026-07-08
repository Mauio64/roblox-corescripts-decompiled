local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local Constants = require(AvatarExperienceCommon.Constants)

local function createHumanoidDescriptionAccessoryInfo(s1: string, s2: string, t1: {[any]: any}) -- line: 22
	-- upvalues: Constants (copy)
	local num = tonumber(s2)

	assert(num ~= nil, "assetIdAsNumber is not nil. Silence type checker.")

	local v8 = t1 or {}

	return {
		AssetId = num,
		Order = v8.order,
		AccessoryType = v8.type or Constants.ASSET_TYPE_TO_ACCESSORY_TYPE[s1],
		IsLayered = v8.isLayered,
		Position = v8.position,
		Rotation = v8.rotation,
		Scale = v8.scale
	}
end

return createHumanoidDescriptionAccessoryInfo
