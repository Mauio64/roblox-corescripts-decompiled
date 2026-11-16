local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local parent = AvatarExperienceSave.Parent

require(AvatarExperienceSave.Context.AvatarSaveContext)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local FFlagAXBackgroundsPersistence = AvatarExperienceFlags.FFlagAXBackgroundsPersistence

local function selectCharacterData(p)
	local characterData = {
		tryOn = {
			TryOn = p.AvatarExperience.AvatarScene.TryOn,
			OutfitTryOn = p.AvatarExperience.AvatarScene.OutfitTryOn,
			LastSavedTriedOnOutfit = p.AvatarExperience.AvatarScene.LastSavedTriedOnOutfit
		},
		equipped = 0
	}

	local equipped = {
		AvatarType = p.AvatarExperience.AvatarEditor.Character.AvatarType,
		AvatarScales = p.AvatarExperience.AvatarEditor.Character.AvatarScales,
		BodyColor3s = p.AvatarExperience.AvatarEditor.Character.BodyColor3s,
		BodyPartRangeIds = p.AvatarExperience.AvatarEditor.Character.BodyPartRangeIds,
		EquippedAssets = p.AvatarExperience.AvatarEditor.Character.EquippedAssets,
		EquippedEmotes = p.AvatarExperience.AvatarEditor.EquippedEmotes,
		BackgroundAssetId = 0
	}
	local backgroundAssetId

	if FFlagAXBackgroundsPersistence then
		backgroundAssetId = p.AvatarExperience.AvatarScene.ProfileConfiguration.BackgroundAssetId
	end

	equipped.BackgroundAssetId = backgroundAssetId
	characterData.equipped = equipped
	return characterData
end

return selectCharacterData
