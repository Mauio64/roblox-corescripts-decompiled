local scriptParent = script.Parent
local FFlagEnableConsoleExpControlsIXP = require(scriptParent:WaitForChild("FFlagEnableConsoleExpControlsIXP"))
local FFlagEnableInExperienceHandheldControls = require(scriptParent:WaitForChild("FFlagEnableInExperienceHandheldControls"))
local v4 = game:DefineFastFlag("EnableConsoleExpControls684", false)

return FFlagEnableConsoleExpControlsIXP or (FFlagEnableInExperienceHandheldControls or v4)
