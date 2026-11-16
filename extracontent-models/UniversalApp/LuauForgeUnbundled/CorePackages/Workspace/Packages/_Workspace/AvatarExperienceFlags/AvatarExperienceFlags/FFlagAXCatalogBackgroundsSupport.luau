local FFlagAXBackgroundsRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXBackgroundsRoot")

local v5 = pcall(function()
	return Enum.AvatarAssetType.AvatarBackground
end)

return game:DefineFastFlag("AXCatalogBackgroundsSupport", false) and FFlagAXBackgroundsRoot and v5
