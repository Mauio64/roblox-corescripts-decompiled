local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dwL")

return ActionCreator("SetTencentNoticeBadgeCount", function(p2)
	module2.isType(p2, "number", "SetTencentNoticeBadgeCount: count")
	return { count = p2 }
end)
