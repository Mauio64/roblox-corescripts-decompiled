require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/AvatarSaveContext")
local fFlagAXBackgroundsPersistence = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/AvatarExperienceFlags").FFlagAXBackgroundsPersistence

local function selectCharacterData(p2)
	local characterData = {
		tryOn = {
			TryOn = p2.AvatarExperience.AvatarScene.TryOn,
			OutfitTryOn = p2.AvatarExperience.AvatarScene.OutfitTryOn,
			LastSavedTriedOnOutfit = p2.AvatarExperience.AvatarScene.LastSavedTriedOnOutfit
		},
		equipped = 0
	}

	local v5 = {
		AvatarType = p2.AvatarExperience.AvatarEditor.Character.AvatarType,
		AvatarScales = p2.AvatarExperience.AvatarEditor.Character.AvatarScales,
		BodyColor3s = p2.AvatarExperience.AvatarEditor.Character.BodyColor3s,
		BodyPartRangeIds = p2.AvatarExperience.AvatarEditor.Character.BodyPartRangeIds,
		EquippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		EquippedEmotes = p2.AvatarExperience.AvatarEditor.EquippedEmotes,
		BackgroundAssetId = 0
	}

	local v6 = if fFlagAXBackgroundsPersistence then p2.AvatarExperience.AvatarScene.ProfileConfiguration.BackgroundAssetId else nil
	v5.BackgroundAssetId = v6
	characterData.equipped = v5
	return characterData
end

return selectCharacterData
