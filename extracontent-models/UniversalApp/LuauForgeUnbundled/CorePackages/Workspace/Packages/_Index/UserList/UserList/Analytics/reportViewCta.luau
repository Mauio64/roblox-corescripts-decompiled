local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")
local telemetryEmitter = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Analytics/telemetryEmitter")
local userListInteractionEvent = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Analytics/userListInteractionEvent")

local buttonTypes = Enums.ButtonTypes

local function reportViewCta(p2)
	if p2 == nil then
		return
	end

	local v5 = {
		eventContext = p2.surface,
		eventName = "ViewCta",
		subpage = p2.subpage,
		buttonType = buttonTypes.View
	}

	pcall(telemetryEmitter.emit, userListInteractionEvent, v5)
end

return reportViewCta
