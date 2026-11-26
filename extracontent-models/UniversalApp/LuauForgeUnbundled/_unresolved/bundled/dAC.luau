local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dAB")

return ActionCreator("FetchingUser", function(p2)
	return { userId = p2, status = module2.Fetching }
end)
