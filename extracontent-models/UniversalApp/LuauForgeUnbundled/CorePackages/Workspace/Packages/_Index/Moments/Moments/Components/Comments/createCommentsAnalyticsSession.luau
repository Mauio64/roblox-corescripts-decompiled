local HttpService = game:GetService("HttpService")

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")
local eventNames = MomentsCommon.Analytics.EventNames
local reportMomentsComments = MomentsCommon.Analytics.reportMomentsComments
local reportMomentsCommentAction = MomentsCommon.Analytics.reportMomentsCommentAction

local function createCommentsAnalyticsSession(feedItemId, surface, callback, p2, p3, p4, callback2)
	local v5 = p2 or MomentsCommon.Analytics.fireAnalyticsEvent
	local v6 = p3 or HttpService:GenerateGUID(false)
	local flag = false
	local v7 = false
	local v8 = false

	local function logEvent(momentCommentsPanelClosed, options)
		if v8 or not callback() then
			return
		end

		local clone = table.clone(options or {})
		clone.feedItemId = feedItemId
		clone.surface = surface
		clone.commentPanelSessionId = v6
		v5(momentCommentsPanelClosed, clone)
		reportMomentsComments(momentCommentsPanelClosed, clone, p4)
	end

	return {
		open = function()
			if not v7 then
				v7 = true
				local momentCommentsPanelOpened = eventNames.MomentCommentsPanelOpened
				local v10 = if callback2 then callback2() else nil
				logEvent(momentCommentsPanelOpened, v10)
			end
		end,
		startView = function()
			if not v8 then
				flag = true
			end
		end,
		finishView = function(p5)
			if flag then
				flag = false
				logEvent(eventNames.MomentCommentsPanelClosed, { closeReason = p5 })
			end
		end,
		cancel = function()
			v8 = true
			flag = false
		end,
		logEvent = logEvent,
		logRealtimeEvent = function(p5, p6)
			if v8 or not callback() then
				return
			end

			local clone = table.clone(p6)
			clone.surface = surface
			reportMomentsCommentAction(p5, clone, p4)
		end
	}
end

return createCommentsAnalyticsSession
