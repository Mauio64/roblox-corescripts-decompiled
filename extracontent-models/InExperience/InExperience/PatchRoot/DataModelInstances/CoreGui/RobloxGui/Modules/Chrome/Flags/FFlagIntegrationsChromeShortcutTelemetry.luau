local Chrome = script.Parent.Parent.Parent.Chrome
local EnrolledConsoleExperienceControls = require(Chrome.Flags.EnrolledConsoleExperienceControls)

local defineFastFlag = game:DefineFastFlag("IntegrationsChromeShortcutTelemetry", false)

return EnrolledConsoleExperienceControls or defineFastFlag
