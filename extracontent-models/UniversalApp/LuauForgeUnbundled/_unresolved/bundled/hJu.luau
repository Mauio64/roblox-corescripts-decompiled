local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dwL")

return ActionCreator("SetGlobalGuiInset", function(p2, p3, p4, p5)
	module2.isNonNegativeNumber(p2, "SetGlobalGuiInset: left")
	module2.isNonNegativeNumber(p3, "SetGlobalGuiInset: top")
	module2.isNonNegativeNumber(p4, "SetGlobalGuiInset: right")
	module2.isNonNegativeNumber(p5, "SetGlobalGuiInset: bottom")

	return { left = p2, top = p3, right = p4, bottom = p5 }
end)
