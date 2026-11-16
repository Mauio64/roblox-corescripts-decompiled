local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local parent = AvatarExperienceSave.Parent

local Dash = require(parent.Dash)

require(AvatarExperienceSave.Context.AvatarSaveContext)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local FFlagAXBackgroundsPersistence = AvatarExperienceFlags.FFlagAXBackgroundsPersistence

local function getSubstateToTrackForChanges(p, flag: boolean?)
	local tryOnItems = {}

	if p.tryOn.OutfitTryOn.TryOnItems then
		for k, tryOnItem in p.tryOn.OutfitTryOn.TryOnItems do
			if flag then
				tryOnItem = Dash.omit(tryOnItem, { "order" })
			end

			tryOnItems[k] = tryOnItem
		end
	end

	local equippedAssets = {}

	if p.equipped.EquippedAssets then
		for k, equippedAsset in p.equipped.EquippedAssets do
			equippedAssets[k] = {}

			for k2, v in equippedAsset do
				local v2 = equippedAssets[k]

				if flag then
					v = Dash.omit(v, { "order" })
				end

				v2[k2] = v
			end
		end
	end

	local substateToTrackForChanges = {
		OutfitTryOn = {
			TryOnItems = tryOnItems,
			LookId = p.tryOn.OutfitTryOn.LookId,
			LookType = p.tryOn.OutfitTryOn.LookType,
			BodyColor3s = p.tryOn.OutfitTryOn.BodyColor3s,
			BodyPartColorRangeIds = p.tryOn.OutfitTryOn.BodyPartColorRangeIds,
			Scale = p.tryOn.OutfitTryOn.Scale
		},
		LastSavedTriedOnOutfit = p.tryOn.LastSavedTriedOnOutfit,
		AvatarType = p.equipped.AvatarType,
		AvatarScales = p.equipped.AvatarScales,
		BodyColor3s = p.equipped.BodyColor3s,
		BodyPartRangeIds = p.equipped.BodyPartRangeIds,
		EquippedAssets = equippedAssets,
		EquippedEmotes = { slotInfo = p.equipped.EquippedEmotes.slotInfo },
		BackgroundAssetId = 0
	}
	local backgroundAssetId

	if FFlagAXBackgroundsPersistence then
		backgroundAssetId = p.equipped.BackgroundAssetId
	end

	substateToTrackForChanges.BackgroundAssetId = backgroundAssetId
	return substateToTrackForChanges
end

return getSubstateToTrackForChanges
