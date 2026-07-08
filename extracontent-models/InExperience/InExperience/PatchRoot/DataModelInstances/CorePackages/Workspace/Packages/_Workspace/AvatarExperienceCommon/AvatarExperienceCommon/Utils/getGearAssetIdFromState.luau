local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local ASSET_TYPE_NAME_TO_ID_STRING = require(AvatarExperienceCommon.Constants).ASSET_TYPE_NAME_TO_ID_STRING
local getEquippedAssetIdsForType = require(script.Parent.getEquippedAssetIdsForType)

return function(p1) -- line: 6
	-- upvalues: getEquippedAssetIdsForType (copy), ASSET_TYPE_NAME_TO_ID_STRING (copy)
	local EquippedAssets = p1.AvatarEditor.Character.EquippedAssets

	if EquippedAssets == nil then
		return 0
	end

	local v6 = getEquippedAssetIdsForType(EquippedAssets, ASSET_TYPE_NAME_TO_ID_STRING.Gear)
	local _, v8 = next(v6)

	if v8 then
		return tonumber(v8) or 0
	end

	return 0
end
