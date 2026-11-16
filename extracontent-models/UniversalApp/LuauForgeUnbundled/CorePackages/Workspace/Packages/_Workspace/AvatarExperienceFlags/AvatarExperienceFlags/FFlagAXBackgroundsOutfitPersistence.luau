local FFlagAXBackgroundsRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXBackgroundsRoot")
local FFlagAXOutfitDetailsV4 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXOutfitDetailsV4")

local defineFastFlag = game:DefineFastFlag("AXBackgroundsOutfitPersistence", false)

local v5 = pcall(function()
	return Enum.AvatarAssetType.AvatarBackground
end)

return FFlagAXBackgroundsRoot and FFlagAXOutfitDetailsV4 and defineFastFlag and v5
