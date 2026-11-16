local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dwL")

return ActionCreator("SetDevSubs", function(p2)
	module2.isType(p2, "table", "SetDevSubs: devSubs")

	return { devSubs = p2 }
end)
