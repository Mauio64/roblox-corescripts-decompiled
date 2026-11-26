local ActionCreator = require("@game/CoreGui/RobloxGui/Modules/PlayerList/ActionCreator")
local module2 = require("@luauforge/bundled/dzO")

return ActionCreator("ReadTencentNoticeId", function(p2)
	module2.isType(p2, "number", "noticeId")
	return { noticeId = p2 }
end)
