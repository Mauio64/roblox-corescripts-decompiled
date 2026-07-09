local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)

require(Modules.AvatarExperience.AvatarEditor.Reducers.Character)
require(Modules.AvatarExperience.Common.Types)

local FFlagAXBackgroundsOutfitPersistence = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXBackgroundsOutfitPersistence
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local selectActiveBackground = AvatarExperienceCommon.Backgrounds.selectActiveBackground
local NO_BACKGROUND_ASSET_ID = AvatarExperienceCommon.Backgrounds.NO_BACKGROUND_ASSET_ID

local function normalizeBackgroundId(n1: number?) -- line: 23
	-- upvalues: NO_BACKGROUND_ASSET_ID (copy)
	if n1 == nil or n1 == NO_BACKGROUND_ASSET_ID then
		return nil
	end

	return n1
end

local v11 = memoize(function(t1: {[any]: any}, p1, p2, p3) -- line: 31
	-- upvalues: Utils (copy)
	return Utils.getIdOfOutfitBeingWorn(p1, p3, p2) or Utils.getIdOfOutfitBeingWorn(t1, p3, p2)
end)

local function GetDuplicateOutfit(p4) -- line: 42
	-- upvalues: Constants (copy), v11 (copy), FFlagAXBackgroundsOutfitPersistence (copy), selectActiveBackground (copy), NO_BACKGROUND_ASSET_ID (copy)
	local OwnedItemIdsBySubtype = p4.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
	local v20 = OwnedItemIdsBySubtype[Constants.PurchasedCharacterKey] or {}
	local v21 = OwnedItemIdsBySubtype[Constants.EditableCharacterKey] or {}
	local Character = p4.AvatarExperience.AvatarEditor.Character
	local OutfitInfos = p4.AvatarExperience.AvatarEditor.OutfitInfos
	local v24 = v11(v20, v21, Character, OutfitInfos)

	if FFlagAXBackgroundsOutfitPersistence and v24 ~= nil then
		local v25 = OutfitInfos[tostring(v24)]
		local v26 = v25 and (v25.profileConfiguration and v25.profileConfiguration.BackgroundAssetId)
		local v27 = selectActiveBackground(p4)

		if ((if v27 ~= nil and v27 ~= NO_BACKGROUND_ASSET_ID then v27 else nil)) ~= if v26 ~= nil and v26 ~= NO_BACKGROUND_ASSET_ID then v26 else nil then
			return nil
		end
	end

	return v24
end

return GetDuplicateOutfit
