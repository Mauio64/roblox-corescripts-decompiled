local FFlagEnableMobileGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagEnableMobileGameJoinCard")
local FFlagMobileGameJoinCardGamepadSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagMobileGameJoinCardGamepadSupport")

return game:DefineFastFlag("ConsoleOpenMobileGameJoinCard", false) and FFlagEnableMobileGameJoinCard and FFlagMobileGameJoinCardGamepadSupport
