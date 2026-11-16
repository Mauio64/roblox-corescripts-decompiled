local FFlagEnableConsoleExpControls = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableConsoleExpControls")
local defineFastFlag = game:DefineFastFlag("ChromeShortcutAddRespawnLeaveToIEM", false)

return FFlagEnableConsoleExpControls and defineFastFlag
