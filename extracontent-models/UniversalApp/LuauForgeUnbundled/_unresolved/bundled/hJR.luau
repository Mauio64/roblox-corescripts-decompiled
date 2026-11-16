local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dwL")

return ActionCreator("SetDevSub", function(p2)
	module2.isType(p2, "table", "SetDevSub: devSub")

	return { devSub = p2 }
end)
