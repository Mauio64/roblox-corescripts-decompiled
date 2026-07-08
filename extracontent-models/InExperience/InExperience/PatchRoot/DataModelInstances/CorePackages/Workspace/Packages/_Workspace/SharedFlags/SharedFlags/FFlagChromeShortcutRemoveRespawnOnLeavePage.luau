local scriptParent = script.Parent
local FFlagEnableConsoleExpControls = require(scriptParent:WaitForChild("FFlagEnableConsoleExpControls"))
local v3 = game:DefineFastFlag("ChromeShortcutRemoveRespawnOnLeavePage", false)

return FFlagEnableConsoleExpControls and v3
