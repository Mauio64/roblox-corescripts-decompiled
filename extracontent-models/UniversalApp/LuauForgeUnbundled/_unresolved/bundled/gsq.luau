local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dzO")

return ActionCreator("SetTokenAuthErrMessageKey", function(p2)
	module2.isType(p2, "string", "errMessageKey")
	return { errMessageKey = p2 }
end)
