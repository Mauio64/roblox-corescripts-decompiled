local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local Constants = require(AvatarExperienceCommon.Constants)

return function(p1) -- line: 5
	-- upvalues: Constants (copy)
	local EquippedAssets = p1.AvatarExperience.AvatarEditor.Character.EquippedAssets

	if EquippedAssets == nil then
		return {}
	end

	local t1 = {}

	for v6, _ in Constants.ASSET_TYPE_ID_STRING_TO_MAKEUP_TYPE do
		if EquippedAssets[v6] then
			for _, v9 in EquippedAssets[v6] do
				table.insert(t1, v9)
			end
		end
	end

	return t1
end
