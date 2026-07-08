local FFlagEnableDesktopGameJoinCard = require(script.Parent.FFlagEnableDesktopGameJoinCard)
local FFlagPPVEnabledOnConsole = require(script.Parent.FFlagPPVEnabledOnConsole)
local v3 = game:DefineFastFlag("EnableConsoleGameJoinCard_v4", false)

return FFlagEnableDesktopGameJoinCard and (FFlagPPVEnabledOnConsole and v3)
