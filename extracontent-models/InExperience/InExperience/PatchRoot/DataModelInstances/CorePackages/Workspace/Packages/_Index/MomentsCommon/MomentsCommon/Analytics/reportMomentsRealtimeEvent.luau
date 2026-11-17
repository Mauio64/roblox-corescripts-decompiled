local RealtimeEventNames = require(script.Parent.RealtimeEventNames)
local RealtimeTelemetryActionList = require(script.Parent.RealtimeTelemetryActionList)
local realtimeTelemetryEmitter = require(script.Parent.realtimeTelemetryEmitter)

local function emit(p, p2, callback) -- 21 equivalent calls inferred from this helper
	(callback or realtimeTelemetryEmitter.emit)(p, p2)
end

local ReportMomentsRealtimeEvent = {}

function ReportMomentsRealtimeEvent.reportMomentsFeedLoadAttempt(feedType: string, callback)
	emit(RealtimeTelemetryActionList[RealtimeEventNames.MomentsFeedLoadAttempt], { -- inferred equivalent call
		feedType = feedType
	}, callback)
end

function ReportMomentsRealtimeEvent.reportMomentsFeedLoadMore(status, feedType: string, failureReason: string?, callback)
	emit( -- inferred equivalent call
		RealtimeTelemetryActionList[RealtimeEventNames.MomentsFeedLoadMore],
		{ status = status, feedType = feedType, failureReason = failureReason },
		callback
	)
end

function ReportMomentsRealtimeEvent.reportMomentsFeedMediaLoad(status, feedType: string, failureReason: string?, callback)
	emit( -- inferred equivalent call
		RealtimeTelemetryActionList[RealtimeEventNames.MomentsFeedMediaLoad],
		{ status = status, feedType = feedType, failureReason = failureReason },
		callback
	)
end

function ReportMomentsRealtimeEvent.reportMomentsFeedState(status, feedType: string, failureReason: string?, callback)
	emit( -- inferred equivalent call
		RealtimeTelemetryActionList[RealtimeEventNames.MomentsFeedState],
		{ status = status, feedType = feedType, failureReason = failureReason },
		callback
	)
end

function ReportMomentsRealtimeEvent.reportMomentsSurfaceLoadAbort(reason, callback)
	emit(RealtimeTelemetryActionList[RealtimeEventNames.MomentsSurfaceLoadAbort], { -- inferred equivalent call
		reason = reason
	}, callback)
end

function ReportMomentsRealtimeEvent.reportMomentsViewBegan(source: string, callback)
	emit(RealtimeTelemetryActionList[RealtimeEventNames.MomentsViewBegan], { source = source }, callback) -- inferred equivalent call
end

function ReportMomentsRealtimeEvent.reportMomentsSessionStarted(source: string, callback)
	emit(RealtimeTelemetryActionList[RealtimeEventNames.MomentsSessionStarted], { source = source }, callback) -- inferred equivalent call
end

function ReportMomentsRealtimeEvent.reportMomentsSessionEnded(source: string, callback)
	emit(RealtimeTelemetryActionList[RealtimeEventNames.MomentsSessionEnded], { source = source }, callback) -- inferred equivalent call
end

function ReportMomentsRealtimeEvent.reportMomentsSessionHeartbeat(source: string, callback)
	emit(RealtimeTelemetryActionList[RealtimeEventNames.MomentsSessionHeartbeat], { -- inferred equivalent call
		source = source
	}, callback)
end

function ReportMomentsRealtimeEvent.reportMomentsEngagement(action: string, callback)
	emit(RealtimeTelemetryActionList[RealtimeEventNames.MomentsEngagement], { action = action }, callback) -- inferred equivalent call
end

function ReportMomentsRealtimeEvent.reportMomentsCreationStep(step: string, status: string?, reason: string?, callback)
	emit( -- inferred equivalent call
		RealtimeTelemetryActionList[RealtimeEventNames.MomentsCreationStep],
		{ step = step, status = status, reason = reason },
		callback
	)
end

function ReportMomentsRealtimeEvent.reportMomentsFeedItemsReceived(feedType: string, callback)
	emit(RealtimeTelemetryActionList[RealtimeEventNames.MomentsFeedItemsReceived], { -- inferred equivalent call
		feedType = feedType
	}, callback)
end

function ReportMomentsRealtimeEvent.reportMomentsFeedItemFiltered(reason: string, feedType: string, callback)
	emit( -- inferred equivalent call
		RealtimeTelemetryActionList[RealtimeEventNames.MomentsFeedItemFiltered],
		{ reason = reason, feedType = feedType },
		callback
	)
end

function ReportMomentsRealtimeEvent.reportMomentsPublishedWithEdit(editType: string, callback)
	emit(RealtimeTelemetryActionList[RealtimeEventNames.MomentsPublishedWithEdit], { -- inferred equivalent call
		editType = editType
	}, callback)
end

function ReportMomentsRealtimeEvent.reportMomentsPublishedEditCount(p: number, callback)
	local bucket

	if p >= 3 then
		bucket = "3plus"
	elseif p == 2 then
		bucket = "2"
	else
		bucket = if p == 1 then "1" else "0"
	end

	emit(RealtimeTelemetryActionList[RealtimeEventNames.MomentsPublishedEditCount], { -- inferred equivalent call
		bucket = bucket
	}, callback)
end

function ReportMomentsRealtimeEvent.reportMomentsPublishedByCaptureType(captureType: string, callback)
	emit( -- inferred equivalent call
		RealtimeTelemetryActionList[RealtimeEventNames.MomentsPublishedByCaptureType],
		{ captureType = captureType },
		callback
	)
end

function ReportMomentsRealtimeEvent.reportMomentsEditToolOpened(tool: string, callback)
	emit(RealtimeTelemetryActionList[RealtimeEventNames.MomentsEditToolOpened], { tool = tool }, callback) -- inferred equivalent call
end

function ReportMomentsRealtimeEvent.reportMomentsEditToolAbandoned(tool: string, callback)
	emit(RealtimeTelemetryActionList[RealtimeEventNames.MomentsEditToolAbandoned], { tool = tool }, callback) -- inferred equivalent call
end

function ReportMomentsRealtimeEvent.reportMomentsGenerateText(status: string, callback)
	emit(RealtimeTelemetryActionList[RealtimeEventNames.MomentsGenerateText], { status = status }, callback) -- inferred equivalent call
end

function ReportMomentsRealtimeEvent.reportMomentsPostInsightsRequest(query: string, status: string, callback)
	emit( -- inferred equivalent call
		RealtimeTelemetryActionList[RealtimeEventNames.MomentsPostInsightsRequest],
		{ query = query, status = status },
		callback
	)
end

function ReportMomentsRealtimeEvent.reportMomentsPostInsightsRequestLatency(query: string, status: string, statValue: number, callback)
	emit( -- inferred equivalent call
		RealtimeTelemetryActionList[RealtimeEventNames.MomentsPostInsightsRequestLatency],
		{ query = query, status = status, statValue = statValue },
		callback
	)
end

return ReportMomentsRealtimeEvent
