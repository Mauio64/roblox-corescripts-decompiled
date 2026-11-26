local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")

return function(p2)
	local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets

	if equippedAssets == nil then
		return {}
	end

	local result = {}

	for k, v5 in Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE do
		if not equippedAssets[k] then
			continue
		end

		for k2, v6 in equippedAssets[k] do
			table.insert(result, v6)
		end
	end

	return result
end
