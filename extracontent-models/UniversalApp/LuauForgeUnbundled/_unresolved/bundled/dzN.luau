local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dzO")

return ActionCreator("ApplyRoactNavigationHistory", function(p2)
	return {
		navigationState = module2.isTypeOrNil(p2, "table", "navigationState")
	}
end)
