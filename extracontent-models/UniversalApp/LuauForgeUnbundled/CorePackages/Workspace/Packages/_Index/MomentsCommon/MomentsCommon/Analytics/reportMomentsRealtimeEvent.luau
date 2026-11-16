local RealtimeEventNames = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/RealtimeEventNames")
local RealtimeTelemetryActionList = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/RealtimeTelemetryActionList")
local telemetryEmitter = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/telemetryEmitter")

local function emit(p2, p3, p4)
	(p4 or telemetryEmitter.emit)(p2, p3)
end

return {
	reportMomentsFeedLoadAttempt = function(p2, p3)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsFeedLoadAttempt];
		(p3 or telemetryEmitter.emit)(v5, { feedType = p2 })
	end,
	reportMomentsFeedLoadMore = function(p2, p3, p4, p5)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsFeedLoadMore];
		(p5 or telemetryEmitter.emit)(v5, { status = p2, feedType = p3, failureReason = p4 })
	end,
	reportMomentsFeedMediaLoad = function(p2, p3, p4, p5)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsFeedMediaLoad];
		(p5 or telemetryEmitter.emit)(v5, { status = p2, feedType = p3, failureReason = p4 })
	end,
	reportMomentsFeedState = function(p2, p3, p4, p5)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsFeedState];
		(p5 or telemetryEmitter.emit)(v5, { status = p2, feedType = p3, failureReason = p4 })
	end,
	reportMomentsSurfaceLoadAbort = function(p2, p3)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsSurfaceLoadAbort];
		(p3 or telemetryEmitter.emit)(v5, { reason = p2 })
	end,
	reportMomentsViewBegan = function(p2, p3)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsViewBegan];
		(p3 or telemetryEmitter.emit)(v5, { source = p2 })
	end,
	reportMomentsSessionStarted = function(p2, p3)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsSessionStarted];
		(p3 or telemetryEmitter.emit)(v5, { source = p2 })
	end,
	reportMomentsSessionEnded = function(p2, p3)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsSessionEnded];
		(p3 or telemetryEmitter.emit)(v5, { source = p2 })
	end,
	reportMomentsSessionHeartbeat = function(p2, p3)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsSessionHeartbeat];
		(p3 or telemetryEmitter.emit)(v5, { source = p2 })
	end,
	reportMomentsEngagement = function(p2, p3)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsEngagement];
		(p3 or telemetryEmitter.emit)(v5, { action = p2 })
	end,
	reportMomentsCreationStep = function(p2, p3, p4, p5)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsCreationStep];
		(p5 or telemetryEmitter.emit)(v5, { step = p2, status = p3, reason = p4 })
	end,
	reportMomentsFeedItemsReceived = function(p2, p3)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsFeedItemsReceived];
		(p3 or telemetryEmitter.emit)(v5, { feedType = p2 })
	end,
	reportMomentsFeedItemFiltered = function(p2, p3, p4)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsFeedItemFiltered];
		(p4 or telemetryEmitter.emit)(v5, { reason = p2, feedType = p3 })
	end,
	reportMomentsPublishedWithEdit = function(p2, p3)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsPublishedWithEdit];
		(p3 or telemetryEmitter.emit)(v5, { editType = p2 })
	end,
	reportMomentsPublishedEditCount = function(p2, p3)
		local v5 = if p2 >= 3 then "3plus" elseif p2 == 2 then "2" elseif p2 == 1 then "1" else "0"
		local v6 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsPublishedEditCount];
		(p3 or telemetryEmitter.emit)(v6, { bucket = v5 })
	end,
	reportMomentsPublishedByCaptureType = function(p2, p3)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsPublishedByCaptureType];
		(p3 or telemetryEmitter.emit)(v5, { captureType = p2 })
	end,
	reportMomentsEditToolOpened = function(p2, p3)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsEditToolOpened];
		(p3 or telemetryEmitter.emit)(v5, { tool = p2 })
	end,
	reportMomentsEditToolAbandoned = function(p2, p3)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsEditToolAbandoned];
		(p3 or telemetryEmitter.emit)(v5, { tool = p2 })
	end,
	reportMomentsGenerateText = function(p2, p3)
		local v5 = RealtimeTelemetryActionList[RealtimeEventNames.MomentsGenerateText];
		(p3 or telemetryEmitter.emit)(v5, { status = p2 })
	end
}
