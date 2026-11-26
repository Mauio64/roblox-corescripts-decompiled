local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dzO")

return ActionCreator("SetTencentNoticeInfo", function(p2)
	module2.isType(p2, "table", "noticeList")
	return { noticeList = p2 }
end)
