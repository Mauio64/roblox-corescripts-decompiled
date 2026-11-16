local UserList = script:FindFirstAncestor("UserList")

local Enums = require(UserList.Common.Enums)
require(UserList.Common.Types)
local telemetryEmitter = require(UserList.Analytics.telemetryEmitter)
local userListInteractionEvent = require(UserList.Analytics.userListInteractionEvent)

local ButtonTypes = Enums.ButtonTypes

local function reportViewCta(p)
	if p == nil then
		return
	end

	local v = {
		eventContext = p.surface,
		eventName = "ViewCta",
		subpage = p.subpage,
		buttonType = ButtonTypes.View
	}

	pcall(telemetryEmitter.emit, userListInteractionEvent, v)
end

return reportViewCta
