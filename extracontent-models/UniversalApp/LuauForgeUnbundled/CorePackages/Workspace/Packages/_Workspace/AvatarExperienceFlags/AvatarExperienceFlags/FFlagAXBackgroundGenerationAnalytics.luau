local FFlagAXBackgroundGeneration = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXBackgroundGeneration")
local FFlagAXItemDetailsIxpExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXItemDetailsIxpExposure")
local FFlagAXSkipTapDetection = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXSkipTapDetection")

return game:DefineFastFlag("AXBackgroundGenerationAnalytics", false) and FFlagAXBackgroundGeneration and FFlagAXItemDetailsIxpExposure and FFlagAXSkipTapDetection
