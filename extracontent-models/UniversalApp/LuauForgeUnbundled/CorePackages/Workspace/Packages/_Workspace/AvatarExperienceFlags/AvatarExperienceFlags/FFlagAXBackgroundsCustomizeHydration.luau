local FFlagAXBackgroundsRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXBackgroundsRoot")
local FFlagAXBackgroundCycloramaRendering = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXBackgroundCycloramaRendering")

local defineFastFlag = game:DefineFastFlag("AXBackgroundsCustomizeHydration4", false)

local v5 = pcall(function()
	return Enum.AvatarAssetType.AvatarBackground
end)

return FFlagAXBackgroundsRoot and FFlagAXBackgroundCycloramaRendering and defineFastFlag and v5
