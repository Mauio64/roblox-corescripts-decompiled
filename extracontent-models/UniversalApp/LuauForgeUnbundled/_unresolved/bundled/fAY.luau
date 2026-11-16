local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dwL")

return ActionCreator("SetFriendRequestsCount", function(p2)
	module2.isNonNegativeNumber(p2, "SetFriendRequestsCount: count")

	return { count = p2 }
end)
