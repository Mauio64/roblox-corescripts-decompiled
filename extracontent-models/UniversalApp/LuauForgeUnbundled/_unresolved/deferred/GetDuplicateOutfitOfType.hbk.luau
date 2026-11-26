local selectActiveBackground = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Backgrounds.selectActiveBackground
local module = require("@luauforge/bundled/fCI")
require("@luauforge/bundled/dRd")
require("@luauforge/bundled/dPs")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXOutfitPageRevamp = AvatarExperienceFlags.FFlagAXOutfitPageRevamp
local fFlagAXBackgroundsOutfitHighlight = AvatarExperienceFlags.FFlagAXBackgroundsOutfitHighlight

local function fn(p2, character, outfitInfos, p3)
	return module.getIdOfOutfitBeingWorn(p2, outfitInfos, character, p3)
end

local function GetDuplicateOutfitOfType(p2, p3)
	if not fFlagAXOutfitPageRevamp then
		return nil
	end

	local ownedItemIdsBySubtype = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
	local character = p2.AvatarExperience.AvatarEditor.Character
	local outfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos

	local v5 = ownedItemIdsBySubtype[module.getOutfitSubtypeKey(p3, true)] or {}

	local v6 = if fFlagAXBackgroundsOutfitHighlight then selectActiveBackground(p2) else nil
	return fn(v5, character, outfitInfos, v6)
end

return GetDuplicateOutfitOfType
