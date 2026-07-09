local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)

require(Modules.AvatarExperience.AvatarEditor.Reducers.Character)
require(Modules.AvatarExperience.Common.Types)

local FFlagAXOutfitPageRevamp = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXOutfitPageRevamp

local function v5(t1: {[any]: any}, p1, p2) -- line: 21
	-- upvalues: Utils (copy)
	return Utils.getIdOfOutfitBeingWorn(t1, p2, p1)
end
local function GetDuplicateOutfitOfType(p3, p4) -- line: 29
	-- upvalues: FFlagAXOutfitPageRevamp (copy), Utils (copy), v5 (copy)
	if not FFlagAXOutfitPageRevamp then
		return nil
	end

	local OwnedItemIdsBySubtype = p3.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype
	local Character = p3.AvatarExperience.AvatarEditor.Character
	local OutfitInfos = p3.AvatarExperience.AvatarEditor.OutfitInfos
	local v15 = OwnedItemIdsBySubtype[Utils.getOutfitSubtypeKey(p4, true)] or {}

	return v5(v15, Character, OutfitInfos)
end

return GetDuplicateOutfitOfType
