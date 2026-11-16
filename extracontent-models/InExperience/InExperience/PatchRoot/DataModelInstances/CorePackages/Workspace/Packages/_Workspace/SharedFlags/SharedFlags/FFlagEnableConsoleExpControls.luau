local parent = script.Parent
local FFlagEnableConsoleExpControlsIXP = require(parent:WaitForChild("FFlagEnableConsoleExpControlsIXP"))

local FFlagEnableInExperienceHandheldControls = require(parent:WaitForChild("FFlagEnableInExperienceHandheldControls"))
local defineFastFlag = game:DefineFastFlag("EnableConsoleExpControls684", false)

return FFlagEnableConsoleExpControlsIXP or FFlagEnableInExperienceHandheldControls or defineFastFlag
