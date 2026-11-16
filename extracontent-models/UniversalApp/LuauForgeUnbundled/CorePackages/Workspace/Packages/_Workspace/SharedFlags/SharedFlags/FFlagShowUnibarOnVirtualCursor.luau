local FFlagEnableConsoleExpControls = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableConsoleExpControls")
local defineFastFlag = game:DefineFastFlag("ShowUnibarOnVirtualCursor", false)

return FFlagEnableConsoleExpControls and defineFastFlag
