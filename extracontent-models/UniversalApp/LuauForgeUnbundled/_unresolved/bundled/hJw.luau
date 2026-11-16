local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dwL")

return ActionCreator("SetGlobalContextMenuInset", function(p2, p3, p4, p5)
	module2.isNonNegativeNumber(p2, "SetGlobalContextMenuInset: left")
	module2.isNonNegativeNumber(p3, "SetGlobalContextMenuInset: top")
	module2.isNonNegativeNumber(p4, "SetGlobalContextMenuInset: right")
	module2.isNonNegativeNumber(p5, "SetGlobalContextMenuInset: bottom")

	return { left = p2, top = p3, right = p4, bottom = p5 }
end)
