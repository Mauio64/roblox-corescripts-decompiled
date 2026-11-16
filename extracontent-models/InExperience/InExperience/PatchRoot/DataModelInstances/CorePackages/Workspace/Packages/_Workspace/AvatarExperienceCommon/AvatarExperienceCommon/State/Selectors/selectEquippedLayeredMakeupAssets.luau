local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local Constants = require(AvatarExperienceCommon.Constants)

return function(p)
	local equippedAssets = p.AvatarExperience.AvatarEditor.Character.EquippedAssets

	if equippedAssets == nil then
		return {}
	end

	local result = {}

	for k, _ in Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE do
		if not equippedAssets[k] then
			continue
		end

		for _, v in equippedAssets[k] do
			table.insert(result, v)
		end
	end

	return result
end
