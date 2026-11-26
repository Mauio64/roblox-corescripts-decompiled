require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")
local telemetryEmitter = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Analytics/telemetryEmitter")
local userListInteractionEvent = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Analytics/userListInteractionEvent")

local function reportCtaActivated(p2, p3, p4, p5)
	if p2 == nil then
		return
	end

	local v5 = {
		eventContext = p2.surface,
		eventName = "CtaActivated",
		subpage = p2.subpage,
		buttonType = p3,
		targetUserId = p4,
		absolutePosition = p5
	}

	pcall(telemetryEmitter.emit, userListInteractionEvent, v5)
end

return reportCtaActivated
