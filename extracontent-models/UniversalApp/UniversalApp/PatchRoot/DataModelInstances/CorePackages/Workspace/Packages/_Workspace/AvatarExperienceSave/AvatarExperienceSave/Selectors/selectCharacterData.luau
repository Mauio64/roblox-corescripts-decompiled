local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local AvatarExperienceSaveParent = AvatarExperienceSave.Parent

require(AvatarExperienceSave.Context.AvatarSaveContext)

local FFlagAXBackgroundsPersistence = require(AvatarExperienceSaveParent.AvatarExperienceFlags).FFlagAXBackgroundsPersistence

local function selectCharacterData(p1) -- line: 9
	-- upvalues: FFlagAXBackgroundsPersistence (copy)
	return {
		tryOn = {
			TryOn = p1.AvatarExperience.AvatarScene.TryOn,
			OutfitTryOn = p1.AvatarExperience.AvatarScene.OutfitTryOn,
			LastSavedTriedOnOutfit = p1.AvatarExperience.AvatarScene.LastSavedTriedOnOutfit
		},
		equipped = {
			AvatarType = p1.AvatarExperience.AvatarEditor.Character.AvatarType,
			AvatarScales = p1.AvatarExperience.AvatarEditor.Character.AvatarScales,
			BodyColor3s = p1.AvatarExperience.AvatarEditor.Character.BodyColor3s,
			BodyPartRangeIds = p1.AvatarExperience.AvatarEditor.Character.BodyPartRangeIds,
			EquippedAssets = p1.AvatarExperience.AvatarEditor.Character.EquippedAssets,
			EquippedEmotes = p1.AvatarExperience.AvatarEditor.EquippedEmotes,
			BackgroundAssetId = if not FFlagAXBackgroundsPersistence then nil else p1.AvatarExperience.AvatarScene.ProfileConfiguration.BackgroundAssetId
		}
	}
end

return selectCharacterData
