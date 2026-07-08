local Chrome = script.Parent.Parent.Parent.Chrome
local EnrolledConsoleExperienceControls = require(Chrome.Flags.EnrolledConsoleExperienceControls)
local v3 = game:DefineFastFlag("IntegrationsChromeShortcutTelemetry", false)

return EnrolledConsoleExperienceControls or v3
