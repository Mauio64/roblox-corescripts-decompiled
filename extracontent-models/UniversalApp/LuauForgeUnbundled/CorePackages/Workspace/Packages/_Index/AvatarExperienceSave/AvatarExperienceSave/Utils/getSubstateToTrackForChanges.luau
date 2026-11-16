local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/Dash")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/AvatarSaveContext")

local fFlagAXBackgroundsPersistence = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/AvatarExperienceFlags").FFlagAXBackgroundsPersistence

local function getSubstateToTrackForChanges(p2, p3)
	local tryOnItems = {}

	if p2.tryOn.OutfitTryOn.TryOnItems then
		for k, tryOnItem in p2.tryOn.OutfitTryOn.TryOnItems do
			if p3 then
				tryOnItem = Dash.omit(tryOnItem, { "order" })
			end

			tryOnItems[k] = tryOnItem
		end
	end

	local v5 = {}

	if p2.equipped.EquippedAssets then
		for k, equippedAsset in p2.equipped.EquippedAssets do
			v5[k] = {}

			for k2, v6 in equippedAsset do
				local v7 = v5[k]

				if p3 then
					v6 = Dash.omit(v6, { "order" })
				end

				v7[k2] = v6
			end
		end
	end

	local substateToTrackForChanges = {
		OutfitTryOn = {
			TryOnItems = tryOnItems,
			LookId = p2.tryOn.OutfitTryOn.LookId,
			LookType = p2.tryOn.OutfitTryOn.LookType,
			BodyColor3s = p2.tryOn.OutfitTryOn.BodyColor3s,
			BodyPartColorRangeIds = p2.tryOn.OutfitTryOn.BodyPartColorRangeIds,
			Scale = p2.tryOn.OutfitTryOn.Scale
		},
		LastSavedTriedOnOutfit = p2.tryOn.LastSavedTriedOnOutfit,
		AvatarType = p2.equipped.AvatarType,
		AvatarScales = p2.equipped.AvatarScales,
		BodyColor3s = p2.equipped.BodyColor3s,
		BodyPartRangeIds = p2.equipped.BodyPartRangeIds,
		EquippedAssets = v5,
		EquippedEmotes = { slotInfo = p2.equipped.EquippedEmotes.slotInfo },
		BackgroundAssetId = 0
	}

	local v6 = if fFlagAXBackgroundsPersistence then p2.equipped.BackgroundAssetId else nil
	substateToTrackForChanges.BackgroundAssetId = v6
	return substateToTrackForChanges
end

return getSubstateToTrackForChanges
