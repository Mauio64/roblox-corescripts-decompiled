local FFlagEnableMobileGameJoinCard = require(script.Parent.FFlagEnableMobileGameJoinCard)
local FFlagEnableDesktopGameJoinCard = require(script.Parent.FFlagEnableDesktopGameJoinCard)

return game:DefineFastFlag("DeprecatePeopleListContextualMenu", false) and (FFlagEnableMobileGameJoinCard and FFlagEnableDesktopGameJoinCard)
