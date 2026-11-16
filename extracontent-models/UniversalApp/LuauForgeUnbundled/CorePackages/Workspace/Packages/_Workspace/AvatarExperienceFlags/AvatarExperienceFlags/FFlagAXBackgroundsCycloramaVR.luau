local FFlagAXBackgroundsRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXBackgroundsRoot")
local FFlagAXBackgroundCycloramaRendering = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXBackgroundCycloramaRendering")

return game:DefineFastFlag("AXBackgroundsCycloramaVR", false) and FFlagAXBackgroundsRoot and FFlagAXBackgroundCycloramaRendering
