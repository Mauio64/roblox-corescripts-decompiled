local scriptParent = script.Parent
local FFlagEnableConsoleExpControls = require(scriptParent:WaitForChild("FFlagEnableConsoleExpControls"))
local v3 = game:DefineFastFlag("ChromeShortcutAddRespawnLeaveToIEM", false)

return FFlagEnableConsoleExpControls and v3
