local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dzO")

return ActionCreator("SetMSDKLoginOpenId", function(p2)
	module2.isType(p2, "string", "openId")
	return { openId = p2 }
end)
