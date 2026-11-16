local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local Constants = require(AvatarExperienceCommon.Constants)
local ASSET_TYPE_NAME_TO_ID_STRING = Constants.ASSET_TYPE_NAME_TO_ID_STRING
local getEquippedAssetIdsForType = require(script.Parent.getEquippedAssetIdsForType)

return function(p)
	local equippedAssets = p.AvatarEditor.Character.EquippedAssets

	if equippedAssets == nil then
		return 0
	end

	local equippedAssetIdsForType = getEquippedAssetIdsForType(equippedAssets, ASSET_TYPE_NAME_TO_ID_STRING.Gear)
	local _, v = next(equippedAssetIdsForType)

	if v then
		return tonumber(v) or 0
	end

	return 0
end
