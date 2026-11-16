local UserList = script:FindFirstAncestor("UserList")

require(UserList.Common.Types)
local telemetryEmitter = require(UserList.Analytics.telemetryEmitter)
local userListInteractionEvent = require(UserList.Analytics.userListInteractionEvent)

local function reportCtaActivated(p, buttonType, targetUserId: string, absolutePosition: number?)
	if p == nil then
		return
	end

	local v = {
		eventContext = p.surface,
		eventName = "CtaActivated",
		subpage = p.subpage,
		buttonType = buttonType,
		targetUserId = targetUserId,
		absolutePosition = absolutePosition
	}

	pcall(telemetryEmitter.emit, userListInteractionEvent, v)
end

return reportCtaActivated
