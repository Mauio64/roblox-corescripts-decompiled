local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dwL")

return ActionCreator("SetSignUpInProgress", function(p2)
	module2.isType(p2, "boolean", "signUpInProgress")
	return { signUpInProgress = p2 }
end)
