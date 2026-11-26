local isIosAuthServiceEnabled = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/isIosAuthServiceEnabled")

local function shouldSkipLegacyPasswordSaveEvent(p2)
	return p2 and isIosAuthServiceEnabled()
end

return shouldSkipLegacyPasswordSaveEvent
