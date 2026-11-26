local dynamicHead = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants").ASSET_TYPE_NAME_TO_ID_STRING.DynamicHead
local defineFastFlag = game:DefineFastFlag("AXDHEquippedAssetsNilCheck", false)

local function selectHasDynamicHead(p2): boolean
	local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets

	if defineFastFlag and not equippedAssets then
		return false
	end

	local equippedAsset = equippedAssets[dynamicHead]

	if equippedAsset then
		for k in equippedAsset do
			return true
		end
	end

	local tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn
		and p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	if tryOnItems then
		for k, tryOnItem in tryOnItems do
			if tryOnItem.assetType == dynamicHead then
				return true
			end
		end
	end

	return false
end

return selectHasDynamicHead
