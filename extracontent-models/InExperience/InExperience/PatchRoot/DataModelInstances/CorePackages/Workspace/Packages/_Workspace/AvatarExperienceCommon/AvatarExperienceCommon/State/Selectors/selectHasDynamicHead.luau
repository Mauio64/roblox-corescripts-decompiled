local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local DynamicHead = require(AvatarExperienceCommon.Constants).ASSET_TYPE_NAME_TO_ID_STRING.DynamicHead
local v3 = game:DefineFastFlag("AXDHEquippedAssetsNilCheck", false)

local function selectHasDynamicHead(p1) -- line: 7
	-- upvalues: v3 (copy), DynamicHead (copy)
	local EquippedAssets = p1.AvatarExperience.AvatarEditor.Character.EquippedAssets

	if v3 and not EquippedAssets then
		return false
	end

	local v7 = EquippedAssets[DynamicHead]

	if v7 then
		for _ in v7 do
			return true
		end
	end

	local v9 = p1.AvatarExperience.AvatarScene.OutfitTryOn and p1.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	if v9 then
		for _, v11 in v9 do
			if v11.assetType == DynamicHead then
				return true
			end
		end
	end

	return false
end

return selectHasDynamicHead
