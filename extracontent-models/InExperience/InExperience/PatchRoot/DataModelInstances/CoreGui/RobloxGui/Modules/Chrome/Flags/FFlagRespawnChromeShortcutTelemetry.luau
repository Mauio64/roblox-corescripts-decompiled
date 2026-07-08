local Chrome = script.Parent.Parent.Parent.Chrome
local EnrolledConsoleExperienceControls = require(Chrome.Flags.EnrolledConsoleExperienceControls)
local v3 = game:DefineFastFlag("RespawnChromeShortcutTelemetry", false)

return EnrolledConsoleExperienceControls and v3
