local Chrome = script.Parent.Parent.Parent.Chrome
local EnrolledConsoleExperienceControls = require(Chrome.Flags.EnrolledConsoleExperienceControls)

local defineFastFlag = game:DefineFastFlag("LeaveActionChromeShortcutTelemetry", false)

return EnrolledConsoleExperienceControls and defineFastFlag
