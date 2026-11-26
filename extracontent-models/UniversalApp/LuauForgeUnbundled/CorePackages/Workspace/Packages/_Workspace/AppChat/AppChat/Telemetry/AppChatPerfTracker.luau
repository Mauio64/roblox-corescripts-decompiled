require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/TimeToInteractiveTracker")
local AppChatPerfEventInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfEventInfo")
local AppChatTTITracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatTTITracker")
local AppChatIntervalTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatIntervalTracker")

return {
	["Events"] = AppChatPerfEventInfo.Events,
	Milestone = AppChatTTITracker.Milestone,
	Hooks = AppChatTTITracker.Hooks,
	setSharedContext = function(p2)
		AppChatTTITracker.setSharedContext(p2)
	end,
	isActive = function(p2, options)
		local v5 = options or {}

		if AppChatPerfEventInfo.isTTIEvent(p2) then
			return AppChatTTITracker.isActive(p2, v5)
		end

		return AppChatIntervalTracker.isActive(p2)
	end,
	start = function(p2, options, p3)
		local v5 = options or {}

		if AppChatPerfEventInfo.isTTIEvent(p2) then
			return AppChatTTITracker.start(p2, v5)
		end

		return AppChatIntervalTracker.start(p2, v5, p3)
	end,
	finish = function(p2, options)
		local v5 = options or {}

		if AppChatPerfEventInfo.isTTIEvent(p2) then
			return AppChatTTITracker.finish(p2, v5)
		end

		return AppChatIntervalTracker.finish(p2)
	end,
	getEventName = function(p2)
		if AppChatPerfEventInfo.isTTIEvent(p2) then
			return AppChatTTITracker.getEventName(p2)
		end

		return nil
	end,
	trackMilestone = function(p2, p3, options)
		local v5 = options or {}

		if AppChatPerfEventInfo.isTTIEvent(p2) then
			return AppChatTTITracker.trackMilestone(p2, p3, v5)
		end

		return false
	end,
	trackSubphase = function(p2, p3, p4, options)
		local v5 = options or {}

		if AppChatPerfEventInfo.isTTIEvent(p2) then
			return AppChatTTITracker.trackSubphase(p2, p3, p4, v5)
		end

		return false
	end,
	trackRequest = function(p2, p3, p4, options)
		local v5 = options or {}

		if AppChatPerfEventInfo.isTTIEvent(p2) then
			return AppChatTTITracker.trackRequest(p2, p3, p4, v5)
		end

		return false
	end,
	cancel = function(p2, options)
		local v5 = options or {}

		if AppChatPerfEventInfo.isTTIEvent(p2) then
			return AppChatTTITracker.cancel(p2, v5)
		end

		return AppChatIntervalTracker.cancel(p2)
	end
}
