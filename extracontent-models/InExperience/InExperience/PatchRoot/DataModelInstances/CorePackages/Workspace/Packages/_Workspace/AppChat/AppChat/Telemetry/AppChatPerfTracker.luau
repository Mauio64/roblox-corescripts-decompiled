local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(parent.TimeToInteractiveTracker)
local AppChatPerfEventInfo = require(AppChat.Telemetry.AppChatPerfEventInfo)
local AppChatTTITracker = require(AppChat.Telemetry.AppChatTTITracker)
local AppChatIntervalTracker = require(AppChat.Telemetry.AppChatIntervalTracker)
local AppChatPerfTracker = {}
AppChatPerfTracker.Events = AppChatPerfEventInfo.Events

AppChatPerfTracker.Milestone = AppChatTTITracker.Milestone
AppChatPerfTracker.Hooks = AppChatTTITracker.Hooks

function AppChatPerfTracker.setSharedContext(p)
	AppChatTTITracker.setSharedContext(p)
end

function AppChatPerfTracker.isActive(p, options)
	local v = options or {}

	if AppChatPerfEventInfo.isTTIEvent(p) then
		return AppChatTTITracker.isActive(p, v)
	end

	return AppChatIntervalTracker.isActive(p)
end

function AppChatPerfTracker.start(p, options, p2)
	local v = options or {}

	if AppChatPerfEventInfo.isTTIEvent(p) then
		return AppChatTTITracker.start(p, v)
	end

	return AppChatIntervalTracker.start(p, v, p2)
end

function AppChatPerfTracker.finish(p, options)
	local v = options or {}

	if AppChatPerfEventInfo.isTTIEvent(p) then
		return AppChatTTITracker.finish(p, v)
	end

	return AppChatIntervalTracker.finish(p)
end

function AppChatPerfTracker.getEventName(p)
	if AppChatPerfEventInfo.isTTIEvent(p) then
		return AppChatTTITracker.getEventName(p)
	end

	return nil
end

function AppChatPerfTracker.trackMilestone(p, p2, options)
	local v = options or {}

	if AppChatPerfEventInfo.isTTIEvent(p) then
		return AppChatTTITracker.trackMilestone(p, p2, v)
	end

	return false
end

function AppChatPerfTracker.trackSubphase(p, p2, p3, options)
	local v = options or {}

	if AppChatPerfEventInfo.isTTIEvent(p) then
		return AppChatTTITracker.trackSubphase(p, p2, p3, v)
	end

	return false
end

function AppChatPerfTracker.trackRequest(p, p2, p3: string, options)
	local v = options or {}

	if AppChatPerfEventInfo.isTTIEvent(p) then
		return AppChatTTITracker.trackRequest(p, p2, p3, v)
	end

	return false
end

function AppChatPerfTracker.cancel(p, options)
	local v = options or {}

	if AppChatPerfEventInfo.isTTIEvent(p) then
		return AppChatTTITracker.cancel(p, v)
	end

	return AppChatIntervalTracker.cancel(p)
end

return AppChatPerfTracker
