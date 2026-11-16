local FFlagEnableConsoleExpControlsIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableConsoleExpControlsIXP")

local FFlagEnableInExperienceHandheldControls = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableInExperienceHandheldControls")
local defineFastFlag = game:DefineFastFlag("EnableConsoleExpControls684", false)

return FFlagEnableConsoleExpControlsIXP or FFlagEnableInExperienceHandheldControls or defineFastFlag
