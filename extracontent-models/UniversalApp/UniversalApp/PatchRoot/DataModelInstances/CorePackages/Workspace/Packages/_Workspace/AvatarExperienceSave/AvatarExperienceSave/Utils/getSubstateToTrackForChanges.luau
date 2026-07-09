local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local AvatarExperienceSaveParent = AvatarExperienceSave.Parent
local Dash = require(AvatarExperienceSaveParent.Dash)

require(AvatarExperienceSave.Context.AvatarSaveContext)

local AvatarExperienceFlags = require(AvatarExperienceSaveParent.AvatarExperienceFlags)
local v5 = game:DefineFastFlag("AXPickStateInsteadOfOmit", false)
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXBackgroundsPersistence = AvatarExperienceFlags.FFlagAXBackgroundsPersistence

local function getSubstateToTrackForChanges(p1, b1: boolean?) -- line: 27
	-- upvalues: FFlagAXCustomizeMakeupSupport (copy), Dash (copy), v5 (copy), FFlagAXBackgroundsPersistence (copy)
	local v11 = if not FFlagAXCustomizeMakeupSupport then nil else {}

	if FFlagAXCustomizeMakeupSupport and p1.tryOn.OutfitTryOn.TryOnItems then
		for v12, v13 in p1.tryOn.OutfitTryOn.TryOnItems do
			v11[v12] = if not b1 then v13 else Dash.omit(v13, { "order" })
		end
	end

	local v14 = if not FFlagAXCustomizeMakeupSupport then nil else {}

	if FFlagAXCustomizeMakeupSupport and p1.equipped.EquippedAssets then
		for v15, v16 in p1.equipped.EquippedAssets do
			v14[v15] = {}

			for v17, v18 in v16 do
				v14[v15][v17] = if not b1 then v18 else Dash.omit(v18, { "order" })
			end
		end
	end

	return {
		OutfitTryOn = if not v5 then Dash.omit(p1.tryOn.OutfitTryOn, {
			"OutfitIdMap",
			"LastAnimOrEmoteToggledItem",
			"LastToggledItem",
			"LookAnalyticsInfo",
			"DefaultTryOnBodyColorsToggled"
		}) else {
			TryOnItems = if not FFlagAXCustomizeMakeupSupport then p1.tryOn.OutfitTryOn.TryOnItems else v11,
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
		EquippedAssets = if not FFlagAXCustomizeMakeupSupport then p1.equipped.EquippedAssets else v14,
		EquippedEmotes = if not v5 then Dash.omit(p1.equipped.EquippedEmotes, { "selectedSlot" }) else {
			slotInfo = p1.equipped.EquippedEmotes.slotInfo
		},
		BackgroundAssetId = if not FFlagAXBackgroundsPersistence then nil else p1.equipped.BackgroundAssetId
	}
end

return getSubstateToTrackForChanges
