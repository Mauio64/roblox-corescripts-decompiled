local parent = script.Parent
local FFlagEnableConsoleExpControls = require(parent:WaitForChild("FFlagEnableConsoleExpControls"))
local defineFastFlag = game:DefineFastFlag("ShowUnibarOnVirtualCursor", false)

return FFlagEnableConsoleExpControls and defineFastFlag
