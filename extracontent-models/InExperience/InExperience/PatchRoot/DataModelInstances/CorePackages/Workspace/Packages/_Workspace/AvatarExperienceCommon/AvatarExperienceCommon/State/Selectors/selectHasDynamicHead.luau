local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local Constants = require(AvatarExperienceCommon.Constants)

local DynamicHead = Constants.ASSET_TYPE_NAME_TO_ID_STRING.DynamicHead
local defineFastFlag = game:DefineFastFlag("AXDHEquippedAssetsNilCheck", false)

local function selectHasDynamicHead(p): boolean
	local equippedAssets = p.AvatarExperience.AvatarEditor.Character.EquippedAssets

	if defineFastFlag and not equippedAssets then
		return false
	end

	local equippedAsset = equippedAssets[DynamicHead]

	if equippedAsset then
		for _ in equippedAsset do
			return true
		end
	end

	local tryOnItems = p.AvatarExperience.AvatarScene.OutfitTryOn
		and p.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	if tryOnItems then
		for _, tryOnItem in tryOnItems do
			if tryOnItem.assetType == DynamicHead then
				return true
			end
		end
	end

	return false
end

return selectHasDynamicHead
