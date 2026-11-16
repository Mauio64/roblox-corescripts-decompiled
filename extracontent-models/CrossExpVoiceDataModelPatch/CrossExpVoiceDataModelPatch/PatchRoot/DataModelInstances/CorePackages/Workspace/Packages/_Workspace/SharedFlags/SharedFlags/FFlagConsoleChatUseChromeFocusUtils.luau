local parent = script.Parent
local FFlagEnableConsoleExpControls = require(parent:WaitForChild("FFlagEnableConsoleExpControls"))
local defineFastFlag = game:DefineFastFlag("ConsoleChatUseChromeFocusUtils", false)

return FFlagEnableConsoleExpControls and defineFastFlag
