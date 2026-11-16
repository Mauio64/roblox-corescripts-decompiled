local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")

local parent = AvatarExperienceSave.Parent
local tutils = require(parent.tutils)

require(AvatarExperienceSave.Context.AvatarSaveContext)

local function checkCharacterDataHasTryOnItems(p): boolean
	local tryOnItems = p.tryOn.OutfitTryOn and p.tryOn.OutfitTryOn.TryOnItems or {}
	return tutils.fieldCount(tryOnItems) > 0
end

return checkCharacterDataHasTryOnItems
