local HttpService = game:GetService("HttpService")
local parent = script:FindFirstAncestor("Moments").Parent
local MomentsCommon = require(parent.MomentsCommon)
local EventNames = MomentsCommon.Analytics.EventNames
local reportMomentsComments = MomentsCommon.Analytics.reportMomentsComments
local reportMomentsCommentAction = MomentsCommon.Analytics.reportMomentsCommentAction

local function createCommentsAnalyticsSession(feedItemId: string, surface: string, callback, p, p2: string?, callback2, callback3)
	local v = p or MomentsCommon.Analytics.fireAnalyticsEvent
	local commentPanelSessionId = p2 or HttpService:GenerateGUID(false)
	local flag = false
	local v2 = false
	local v3 = false

	local function logEvent(p3, options)
		if v3 or not callback() then
			return
		end

		local clone = table.clone(options or {})
		clone.feedItemId = feedItemId
		clone.surface = surface
		clone.commentPanelSessionId = commentPanelSessionId
		v(p3, clone)
		reportMomentsComments(p3, clone, callback2)
	end

	return {
		open = function()
			if not v2 then
				v2 = true
				local momentCommentsPanelOpened = EventNames.MomentCommentsPanelOpened
				local v4

				if callback3 then
					v4 = callback3()
				end

				logEvent(momentCommentsPanelOpened, v4)
			end
		end,
		startView = function()
			if not v3 then
				flag = true
			end
		end,
		finishView = function(closeReason: string)
			if flag then
				flag = false
				logEvent(EventNames.MomentCommentsPanelClosed, { closeReason = closeReason })
			end
		end,
		cancel = function()
			v3 = true
			flag = false
		end,
		logEvent = logEvent,
		logRealtimeEvent = function(p3, p4)
			if v3 or not callback() then
				return
			end

			local clone = table.clone(p4)
			clone.surface = surface
			reportMomentsCommentAction(p3, clone, callback2)
		end
	}
end

return createCommentsAnalyticsSession
