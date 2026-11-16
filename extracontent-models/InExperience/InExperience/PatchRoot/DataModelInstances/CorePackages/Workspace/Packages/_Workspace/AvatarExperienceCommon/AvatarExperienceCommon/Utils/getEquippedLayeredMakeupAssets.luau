local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local Constants = require(AvatarExperienceCommon.Constants)

local function getEquippedLayeredMakeupAssets(p)
	if p == nil then
		return {}
	end

	local result = {}

	for k, _ in Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE do
		if not p[k] then
			continue
		end

		for _, v in p[k] do
			table.insert(result, v)
		end
	end

	return result
end

return getEquippedLayeredMakeupAssets
