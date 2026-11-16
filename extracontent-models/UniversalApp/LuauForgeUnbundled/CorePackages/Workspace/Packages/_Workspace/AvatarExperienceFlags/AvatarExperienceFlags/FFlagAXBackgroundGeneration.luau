local FFlagAXBackgroundsRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXBackgroundsRoot")
local FFlagAXBackgroundsCustomizeHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXBackgroundsCustomizeHydration")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/AvatarExperienceFlags/FFlagAXBackgroundGenerationResultActionButtons")

local defineFastFlag = game:DefineFastFlag("AXBackgroundGenerationV2", false)

local defineFastFlag2 = game:DefineFastFlag("AXBackgroundGenerationBuildGate", false)

if defineFastFlag or defineFastFlag2 or v5 then
	v5 = FFlagAXBackgroundsRoot and FFlagAXBackgroundsCustomizeHydration
end

return v5
