local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dwL")

return ActionCreator("SetEmailNotificationCount", function(p2)
	module2.isNonNegativeNumber(p2, "SetEmailNotificationCount: count")

	return { count = p2 }
end)
