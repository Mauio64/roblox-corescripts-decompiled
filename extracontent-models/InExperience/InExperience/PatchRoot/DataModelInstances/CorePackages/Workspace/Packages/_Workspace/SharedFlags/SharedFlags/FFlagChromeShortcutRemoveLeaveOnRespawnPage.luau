local parent = script.Parent
local FFlagEnableConsoleExpControls = require(parent:WaitForChild("FFlagEnableConsoleExpControls"))
local defineFastFlag = game:DefineFastFlag("ChromeShortcutRemoveLeaveOnRespawnPage", false)

return FFlagEnableConsoleExpControls and defineFastFlag
