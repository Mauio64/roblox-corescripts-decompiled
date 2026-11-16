local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dwL")

return ActionCreator("SetMSDKLoginInProgress", function(p2)
	module2.isType(p2, "boolean", "loginInProgress")
	return { loginInProgress = p2 }
end)
