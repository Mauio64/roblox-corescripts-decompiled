local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChatParent.TimeToInteractiveTracker)

local AppChatPerfEventInfo = require(AppChat.Telemetry.AppChatPerfEventInfo)
local AppChatTTITracker = require(AppChat.Telemetry.AppChatTTITracker)
local AppChatIntervalTracker = require(AppChat.Telemetry.AppChatIntervalTracker)

return {
	Events = AppChatPerfEventInfo.Events,
	Milestone = AppChatTTITracker.Milestone,
	Hooks = AppChatTTITracker.Hooks,
	setSharedContext = function(t1: {[any]: any}) -- line: 33
		-- upvalues: AppChatTTITracker (copy)
		AppChatTTITracker.setSharedContext(t1)
	end,
	isActive = function(p1, p2) -- line: 37
		-- upvalues: AppChatPerfEventInfo (copy), AppChatTTITracker (copy), AppChatIntervalTracker (copy)
		local v9 = p2 or {}

		if AppChatPerfEventInfo.isTTIEvent(p1) then
			return AppChatTTITracker.isActive(p1, v9)
		end

		return AppChatIntervalTracker.isActive(p1)
	end,
	start = function(p3, p4) -- line: 47
		-- upvalues: AppChatPerfEventInfo (copy), AppChatTTITracker (copy), AppChatIntervalTracker (copy)
		local v12 = p4 or {}

		if AppChatPerfEventInfo.isTTIEvent(p3) then
			return AppChatTTITracker.start(p3, v12)
		end

		return AppChatIntervalTracker.start(p3, v12)
	end,
	finish = function(p5, p6) -- line: 55
		-- upvalues: AppChatPerfEventInfo (copy), AppChatTTITracker (copy), AppChatIntervalTracker (copy)
		local v15 = p6 or {}

		if AppChatPerfEventInfo.isTTIEvent(p5) then
			return AppChatTTITracker.finish(p5, v15)
		end

		return AppChatIntervalTracker.finish(p5)
	end,
	getEventName = function(p7) -- line: 63
		-- upvalues: AppChatPerfEventInfo (copy), AppChatTTITracker (copy)
		if AppChatPerfEventInfo.isTTIEvent(p7) then
			return AppChatTTITracker.getEventName(p7)
		end

		return nil
	end,
	trackMilestone = function(p8, p9, p10) -- line: 70
		-- upvalues: AppChatPerfEventInfo (copy), AppChatTTITracker (copy)
		local v20 = p10 or {}

		if AppChatPerfEventInfo.isTTIEvent(p8) then
			return AppChatTTITracker.trackMilestone(p8, p9, v20)
		end

		return false
	end,
	trackSubphase = function(p11, p12, p13, p14) -- line: 78
		-- upvalues: AppChatPerfEventInfo (copy), AppChatTTITracker (copy)
		local v25 = p14 or {}

		if AppChatPerfEventInfo.isTTIEvent(p11) then
			return AppChatTTITracker.trackSubphase(p11, p12, p13, v25)
		end

		return false
	end,
	trackRequest = function(p15, p16, s1: string, p17) -- line: 91
		-- upvalues: AppChatPerfEventInfo (copy), AppChatTTITracker (copy)
		local v30 = p17 or {}

		if AppChatPerfEventInfo.isTTIEvent(p15) then
			return AppChatTTITracker.trackRequest(p15, p16, s1, v30)
		end

		return false
	end,
	cancel = function(p18, p19) -- line: 104
		-- upvalues: AppChatPerfEventInfo (copy), AppChatTTITracker (copy), AppChatIntervalTracker (copy)
		local v33 = p19 or {}

		if AppChatPerfEventInfo.isTTIEvent(p18) then
			return AppChatTTITracker.cancel(p18, v33)
		end

		return AppChatIntervalTracker.cancel(p18)
	end
}
