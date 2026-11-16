local parent = script.Parent
local FFlagEnableConsoleExpControls = require(parent:WaitForChild("FFlagEnableConsoleExpControls"))
local defineFastFlag = game:DefineFastFlag("UnibarMenuOpenSelectionIXP2", false)

return FFlagEnableConsoleExpControls and defineFastFlag
