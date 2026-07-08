local Chrome = script.Parent.Parent.Parent.Chrome
local EnrolledConsoleExperienceControls = require(Chrome.Flags.EnrolledConsoleExperienceControls)
local v3 = game:DefineFastFlag("LoggingGamepadOpenExpControlsMenu", false)

return EnrolledConsoleExperienceControls and v3
