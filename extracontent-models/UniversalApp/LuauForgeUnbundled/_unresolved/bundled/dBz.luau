local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dzO")

return ActionCreator("SetGameSubscriptionProducts", function(p2, p3)
	module2.isType(p2, "string", "universeId")
	module2.isType(p3, "table", "subscriptionProducts")

	return { universeId = p2, subscriptionProducts = p3 }
end)
