local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")

local function getEquippedLayeredMakeupAssets(p2)
	if p2 == nil then
		return {}
	end

	local result = {}

	for k, v5 in Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE do
		if not p2[k] then
			continue
		end

		for k2, v6 in p2[k] do
			table.insert(result, v6)
		end
	end

	return result
end

return getEquippedLayeredMakeupAssets
