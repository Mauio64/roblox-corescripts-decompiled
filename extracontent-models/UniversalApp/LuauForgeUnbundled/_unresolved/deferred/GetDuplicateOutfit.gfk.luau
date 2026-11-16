local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize

local module = require("@luauforge/bundled/dNQ")
local module2 = require("@luauforge/bundled/fvh")
require("@luauforge/bundled/dNN")
require("@luauforge/bundled/dMc")
local fFlagAXBackgroundsOutfitHighlight = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXBackgroundsOutfitHighlight

local selectActiveBackground = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Backgrounds.selectActiveBackground

local fFlagAXMigrateOutfitsToUserInventory = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMigrateOutfitsToUserInventory

local avatarEditorCategories = require("@luauforge/bundled/dMd").Enums.AvatarEditorCategories

local v5 = memoize(function(p2, p3, p4, p5, p6)
	return module2.getIdOfOutfitBeingWorn(p3, p5, p4, p6) or module2.getIdOfOutfitBeingWorn(p2, p5, p4, p6)
end)

local function GetDuplicateOutfit(p2)
	local ownedItemIdsBySubtype = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
	local v6 = ownedItemIdsBySubtype[module.PurchasedCharacterKey] or {}

	local v7 = if fFlagAXMigrateOutfitsToUserInventory then avatarEditorCategories.Avatars else module.EditableCharacterKey
	local v8 = ownedItemIdsBySubtype[v7] or {}
	local character = p2.AvatarExperience.AvatarEditor.Character
	local outfitInfos = p2.AvatarExperience.AvatarEditor.OutfitInfos

	local v9 = if fFlagAXBackgroundsOutfitHighlight then selectActiveBackground(p2) else nil
	return v5(v6, v8, character, outfitInfos, v9)
end

return GetDuplicateOutfit
