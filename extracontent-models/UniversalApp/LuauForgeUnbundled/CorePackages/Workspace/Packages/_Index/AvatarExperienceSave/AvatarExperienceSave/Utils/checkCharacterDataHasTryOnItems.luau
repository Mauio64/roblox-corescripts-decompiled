local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/tutils")

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/AvatarSaveContext")

local function checkCharacterDataHasTryOnItems(p2): boolean
	local tryOnItems = p2.tryOn.OutfitTryOn and p2.tryOn.OutfitTryOn.TryOnItems or {}
	return tutils.fieldCount(tryOnItems) > 0
end

return checkCharacterDataHasTryOnItems
