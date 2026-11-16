local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dwL")

return ActionCreator("SetGamePasses", function(p2, p3)
	module2.isType(p2, "string", "universeId")
	module2.isType(p3, "table", "passes")

	return { universeId = p2, passes = p3 }
end)
