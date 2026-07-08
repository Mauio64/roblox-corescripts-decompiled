local scriptParent = script.Parent
local FFlagIEMFocusNavToButtons = require(scriptParent:WaitForChild("FFlagIEMFocusNavToButtons"))
local v3 = game:DefineFastFlag("IEMResumeButtonPressBugfix", false)

return FFlagIEMFocusNavToButtons and v3
