local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/EventNames")
local RealtimeEventNames = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/RealtimeEventNames")
local RealtimeTelemetryActionList = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/RealtimeTelemetryActionList")
local telemetryEmitter = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/telemetryEmitter")

local v5 = {
	[EventNames.MomentCommentsListLoadAttempted] = {
		counter = RealtimeEventNames.MomentsCommentsListLoad,
		status = "attempted"
	},
	[EventNames.MomentCommentsListLoadSucceeded] = {
		counter = RealtimeEventNames.MomentsCommentsListLoad,
		status = "succeeded"
	},
	[EventNames.MomentCommentsListLoadFailed] = {
		counter = RealtimeEventNames.MomentsCommentsListLoad,
		status = "failed"
	},
	[EventNames.MomentCommentPostAttempted] = {
		counter = RealtimeEventNames.MomentsCommentPost,
		status = "attempted"
	},
	[EventNames.MomentCommentPostResult] = {
		counter = RealtimeEventNames.MomentsCommentPost,
		statusField = "outcome"
	}
}

local set = {
	[RealtimeEventNames.MomentsCommentReaction] = true,
	[RealtimeEventNames.MomentsCommentDelete] = true,
	[RealtimeEventNames.MomentsCommentReport] = true,
	[RealtimeEventNames.MomentsCommentAuthorBlock] = true
}

local function emit(p2, p3, p4)
	(p4 or telemetryEmitter.emit)(RealtimeTelemetryActionList[p2], p3)
end

return {
	reportMomentsComments = function(p2, data, p3)
		local v6 = v5[p2]

		if v6 == nil then
			return
		end

		local v7 = v6.status

		if v7 == nil and v6.statusField ~= nil then
			v7 = data[v6.statusField]
		end

		local counter = v6.counter
		local v8 = {
			status = v7 or "",
			loadType = data.loadType,
			surface = data.surface or "",
			failureReason = data.failureReason
		}
		(p3 or telemetryEmitter.emit)(RealtimeTelemetryActionList[counter], v8)
	end,
	reportMomentsCommentAction = function(p2, data, p3)
		if not set[p2] then
			return
		end

		local v6 = {
			status = data.status or "",
			action = data.action,
			surface = data.surface or "",
			failureReason = data.failureReason
		}
		(p3 or telemetryEmitter.emit)(RealtimeTelemetryActionList[p2], v6)
	end
}
