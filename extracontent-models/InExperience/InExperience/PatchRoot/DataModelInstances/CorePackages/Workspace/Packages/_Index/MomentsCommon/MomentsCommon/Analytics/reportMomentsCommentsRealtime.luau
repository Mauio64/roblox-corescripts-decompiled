local EventNames = require(script.Parent.EventNames)
local RealtimeEventNames = require(script.Parent.RealtimeEventNames)
local RealtimeTelemetryActionList = require(script.Parent.RealtimeTelemetryActionList)
local realtimeTelemetryEmitter = require(script.Parent.realtimeTelemetryEmitter)

local v = {
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
	},
	[EventNames.MomentCommentTranslationToggled] = {
		counter = RealtimeEventNames.MomentsCommentTranslationToggle,
		statusField = "isTranslationShown",
		statusLabels = { ["true"] = "translated", ["false"] = "original" }
	}
}

local set = {
	[RealtimeEventNames.MomentsCommentReaction] = true,
	[RealtimeEventNames.MomentsCommentDelete] = true,
	[RealtimeEventNames.MomentsCommentReport] = true,
	[RealtimeEventNames.MomentsCommentAuthorBlock] = true
}

local function emit(p, p2, callback) -- 2 equivalent calls inferred from this helper
	(callback or realtimeTelemetryEmitter.emit)(RealtimeTelemetryActionList[p], p2)
end

local ReportMomentsCommentsRealtime = {}

function ReportMomentsCommentsRealtime.reportMomentsComments(p: string, data, callback)
	local v2 = v[p]

	if v2 == nil then
		return
	end

	local v3 = v2.status

	if v3 == nil and v2.statusField ~= nil then
		v3 = data[v2.statusField]
		local statusLabels = v2.statusLabels

		if statusLabels ~= nil and v3 ~= nil then
			v3 = statusLabels[v3]
		end
	end

	emit(v2.counter, { -- inferred equivalent call
		status = v3 or "",
		loadType = data.loadType,
		surface = data.surface or "",
		failureReason = data.failureReason
	}, callback)
end

function ReportMomentsCommentsRealtime.reportMomentsCommentAction(p: string, data, callback)
	if not set[p] then
		return
	end

	emit(p, { -- inferred equivalent call
		status = data.status or "",
		action = data.action,
		surface = data.surface or "",
		failureReason = data.failureReason
	}, callback)
end

return ReportMomentsCommentsRealtime
