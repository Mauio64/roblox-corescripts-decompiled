local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dwL")

return ActionCreator("SetGameDeveloperProducts", function(p2, p3)
	module2.isType(p2, "string", "universeId")
	module2.isType(p3, "table", "developerProducts")

	return { universeId = p2, developerProducts = p3 }
end)
