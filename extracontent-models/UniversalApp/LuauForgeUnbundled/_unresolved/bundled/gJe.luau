local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dzP")

return ActionCreator("SetModerationStatus", function(p2)
	module2.isType(p2, "boolean", "SetModerationStatus action expects `modStatus` to be a boolean")
	return { userModerated = p2 }
end)
