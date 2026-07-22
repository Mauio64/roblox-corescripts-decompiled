local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local AvatarExperienceSaveParent = AvatarExperienceSave.Parent
local Dash = require(AvatarExperienceSaveParent.Dash)

require(AvatarExperienceSave.Context.AvatarSaveContext)

local FFlagAXBackgroundsPersistence = require(AvatarExperienceSaveParent.AvatarExperienceFlags).FFlagAXBackgroundsPersistence

local function getSubstateToTrackForChanges(p1, b1: boolean?) -- line: 25
	-- upvalues: Dash (copy), FFlagAXBackgroundsPersistence (copy)
	local t1 = {}

	if p1.tryOn.OutfitTryOn.TryOnItems then
		for v9, v10 in p1.tryOn.OutfitTryOn.TryOnItems do
			t1[v9] = if not b1 then v10 else Dash.omit(v10, { "order" })
		end
	end

	local t2 = {}

	if p1.equipped.EquippedAssets then
		for v12, v13 in p1.equipped.EquippedAssets do
			t2[v12] = {}

			for v14, v15 in v13 do
				t2[v12][v14] = if not b1 then v15 else Dash.omit(v15, { "order" })
			end
		end
	end

	return {
		OutfitTryOn = {
			TryOnItems = t1,
			LookId = p1.tryOn.OutfitTryOn.LookId,
			LookType = p1.tryOn.OutfitTryOn.LookType,
			BodyColor3s = p1.tryOn.OutfitTryOn.BodyColor3s,
			BodyPartColorRangeIds = p1.tryOn.OutfitTryOn.BodyPartColorRangeIds,
			Scale = p1.tryOn.OutfitTryOn.Scale
		},
		LastSavedTriedOnOutfit = p1.tryOn.LastSavedTriedOnOutfit,
		AvatarType = p1.equipped.AvatarType,
		AvatarScales = p1.equipped.AvatarScales,
		BodyColor3s = p1.equipped.BodyColor3s,
		BodyPartRangeIds = p1.equipped.BodyPartRangeIds,
		EquippedAssets = t2,
		EquippedEmotes = {
			slotInfo = p1.equipped.EquippedEmotes.slotInfo
		},
		BackgroundAssetId = if not FFlagAXBackgroundsPersistence then nil else p1.equipped.BackgroundAssetId
	}
end

return getSubstateToTrackForChanges
