local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dzO")

return ActionCreator("SetAgreedUserAgreements", function(p2)
	module2.isType(p2, "table", "agreements")

	return { agreedUserAgreements = p2 }
end)
