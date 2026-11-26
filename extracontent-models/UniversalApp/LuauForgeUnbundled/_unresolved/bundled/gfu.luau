local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dzO")

return ActionCreator("SetUnreadMessageCount", function(p2)
	module2.isNonNegativeNumber(p2, "SetUnreadMessageCount: count")

	return { count = p2 }
end)
