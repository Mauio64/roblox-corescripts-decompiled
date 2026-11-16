local module = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/EventNames")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/FunnelEventNames")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/RecommendationSource")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/SessionManager")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/Types")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/fireAnalyticsEvent")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/fireFunnelAnalyticsEvent")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/reportMomentSkip")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/reportMusicSearchCounts")
local reportMomentsRealtimeEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/reportMomentsRealtimeEvent")
local reportMomentsCommentsRealtime = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/reportMomentsCommentsRealtime")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Analytics/createMomentsSessionHeartbeat")

return {
	EventNames = module,
	FunnelEventNames = module2,
	RecommendationSource = module3,
	SessionManager = module4,
	fireAnalyticsEvent = module5,
	fireFunnelAnalyticsEvent = module6,
	reportMomentSkip = module7,
	reportMusicSearchCounts = module8,
	reportMomentsFeedLoadAttempt = reportMomentsRealtimeEvent.reportMomentsFeedLoadAttempt,
	reportMomentsFeedLoadMore = reportMomentsRealtimeEvent.reportMomentsFeedLoadMore,
	reportMomentsFeedMediaLoad = reportMomentsRealtimeEvent.reportMomentsFeedMediaLoad,
	reportMomentsFeedState = reportMomentsRealtimeEvent.reportMomentsFeedState,
	reportMomentsSurfaceLoadAbort = reportMomentsRealtimeEvent.reportMomentsSurfaceLoadAbort,
	reportMomentsViewBegan = reportMomentsRealtimeEvent.reportMomentsViewBegan,
	reportMomentsSessionStarted = reportMomentsRealtimeEvent.reportMomentsSessionStarted,
	reportMomentsSessionEnded = reportMomentsRealtimeEvent.reportMomentsSessionEnded,
	reportMomentsSessionHeartbeat = reportMomentsRealtimeEvent.reportMomentsSessionHeartbeat,
	reportMomentsEngagement = reportMomentsRealtimeEvent.reportMomentsEngagement,
	reportMomentsCreationStep = reportMomentsRealtimeEvent.reportMomentsCreationStep,
	createMomentsSessionHeartbeat = module11,
	reportMomentsFeedItemsReceived = reportMomentsRealtimeEvent.reportMomentsFeedItemsReceived,
	reportMomentsFeedItemFiltered = reportMomentsRealtimeEvent.reportMomentsFeedItemFiltered,
	reportMomentsPublishedWithEdit = reportMomentsRealtimeEvent.reportMomentsPublishedWithEdit,
	reportMomentsPublishedEditCount = reportMomentsRealtimeEvent.reportMomentsPublishedEditCount,
	reportMomentsPublishedByCaptureType = reportMomentsRealtimeEvent.reportMomentsPublishedByCaptureType,
	reportMomentsEditToolOpened = reportMomentsRealtimeEvent.reportMomentsEditToolOpened,
	reportMomentsEditToolAbandoned = reportMomentsRealtimeEvent.reportMomentsEditToolAbandoned,
	reportMomentsGenerateText = reportMomentsRealtimeEvent.reportMomentsGenerateText,
	reportMomentsComments = reportMomentsCommentsRealtime.reportMomentsComments,
	reportMomentsCommentAction = reportMomentsCommentsRealtime.reportMomentsCommentAction
}
