local scriptParent = script.Parent
local FFlagEnableConsoleExpControls = require(scriptParent:WaitForChild("FFlagEnableConsoleExpControls"))
local v3 = game:DefineFastFlag("ConsoleChatUseChromeFocusUtils", false)

return FFlagEnableConsoleExpControls and v3
