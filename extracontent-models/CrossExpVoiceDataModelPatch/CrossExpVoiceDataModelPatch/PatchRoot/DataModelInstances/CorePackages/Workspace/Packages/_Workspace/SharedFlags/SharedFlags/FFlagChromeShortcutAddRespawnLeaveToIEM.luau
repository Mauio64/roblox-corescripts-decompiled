local parent = script.Parent
local FFlagEnableConsoleExpControls = require(parent:WaitForChild("FFlagEnableConsoleExpControls"))
local defineFastFlag = game:DefineFastFlag("ChromeShortcutAddRespawnLeaveToIEM", false)

return FFlagEnableConsoleExpControls and defineFastFlag
