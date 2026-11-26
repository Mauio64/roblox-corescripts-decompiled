local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dzO")

return ActionCreator("SetPasswordNotificationCount", function(p2)
	module2.isNonNegativeNumber(p2, "SetPasswordNotificationCount: count")

	return { count = p2 }
end)
