local FFlagAXBackgroundsRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXBackgroundsRoot")
local FFlagAXBackgroundsOutfitPersistence = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXBackgroundsOutfitPersistence")

local defineFastFlag = game:DefineFastFlag("AXBackgroundsOutfitHighlight", false)

return FFlagAXBackgroundsRoot and FFlagAXBackgroundsOutfitPersistence and defineFastFlag
