local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local AvatarExperienceSaveParent = AvatarExperienceSave.Parent
local tutils = require(AvatarExperienceSaveParent.tutils)

require(AvatarExperienceSave.Context.AvatarSaveContext)

local function checkCharacterDataHasTryOnItems(p1) -- line: 14
	-- upvalues: tutils (copy)
	local v6 = p1.tryOn.OutfitTryOn and p1.tryOn.OutfitTryOn.TryOnItems or {}

	return tutils.fieldCount(v6) > 0
end

return checkCharacterDataHasTryOnItems
