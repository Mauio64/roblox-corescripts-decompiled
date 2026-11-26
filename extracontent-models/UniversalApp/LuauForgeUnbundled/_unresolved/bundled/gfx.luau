local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dzO")

return ActionCreator("SetNotificationCount", function(p2)
	module2.isNonNegativeNumber(p2, "SetNotificationCount: notificationCount")

	return { notificationCount = p2 }
end)
