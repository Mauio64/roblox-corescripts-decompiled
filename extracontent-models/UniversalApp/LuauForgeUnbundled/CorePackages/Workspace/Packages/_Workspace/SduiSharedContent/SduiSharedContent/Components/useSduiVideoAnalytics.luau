local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")

local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/DiscoveryAnalytics")
local discoveryVideoEndEvent = DiscoveryAnalytics.Events.discoveryVideoEndEvent
local discoveryVideoLoadEvent = DiscoveryAnalytics.Events.discoveryVideoLoadEvent
local discoveryVideoLoopEvent = DiscoveryAnalytics.Events.discoveryVideoLoopEvent
local discoveryVideoPlayEvent = DiscoveryAnalytics.Events.discoveryVideoPlayEvent

local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/DiscoveryUtils")
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local parseBooleanString = DiscoveryUtils.parseBooleanString

local findAnalyticsFieldInAncestors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem").findAnalyticsFieldInAncestors

local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/VideoUtils")
local videoActions = VideoUtils.AnalyticsEnums.VideoActions
local videoLogger = VideoUtils.VideoLogger

local fFlagLuaAppDiscoveryMomentVideoTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagLuaAppDiscoveryMomentVideoTelemetry

local function asOptionalString(p2)
	if p2 == nil then
		return nil
	end

	return (tostring(p2))
end

local function asOptionalBoolean(value)
	if type(value) == "boolean" then
		return value
	end

	if type(value) == "string" then
		return (parseBooleanString(value))
	end

	return nil
end

local function reportMissingVideoAssetId(p2, p3, p4, p5)
	discoveryEventErrorLogger.reportError(
		"UnifiedVideoEngagementEvent_MissingVideoAssetId",
		`SDUI video analytics "{p2}" is missing videoAssetId on page "{p3}"`,
		{ actionType = p2, pageContext = p3, universeId = p4, placeId = p5 }
	)
end

local function useSduiVideoAnalytics(p2, p3, data)
	local v5 = React.useCallback(function(value)
		local v6 = if p2.getCollectionData then p2.getCollectionData() else nil
		local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("videoAssetId", p2)
		local v7 = if analyticsFieldInAncestors ~= nil then tostring(analyticsFieldInAncestors) else nil

		local v8 = findAnalyticsFieldInAncestors("nativeAdData", p2)
			or findAnalyticsFieldInAncestors("adId", p2)

		local v9 = {
			videoAssetId = v7,
			videoPlaybackSessionId = value or "INVALID_SESSION_ID",
			universeId = data.universeId,
			rootPlaceId = data.placeId,
			gameSetTypeId = 0,
			sortPos = 0,
			nativeAdData = 0,
			tileType = 0,
			contentType = 0,
			isMoment = 0
		}
		local v10

		if v6 then
			local collectionId = v6.collectionId

			if collectionId ~= nil then
				v10 = tostring(collectionId)
			end
		end

		v9.gameSetTypeId = v10
		local v11 = if v6 then v6.collectionPosition else nil
		v9.sortPos = v11
		local v12 = if v8 ~= nil then tostring(v8) else nil

		v9.nativeAdData = v12
		local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors("tileType", p2)
		local v13 = if analyticsFieldInAncestors2 ~= nil then tostring(analyticsFieldInAncestors2) else nil

		v9.tileType = v13
		local analyticsFieldInAncestors3 = findAnalyticsFieldInAncestors("contentType", p2)
		local v14 = if analyticsFieldInAncestors3 ~= nil then tostring(analyticsFieldInAncestors3) else nil

		v9.contentType = v14
		local v15

		if fFlagLuaAppDiscoveryMomentVideoTelemetry then
			v15 = findAnalyticsFieldInAncestors("isMoment", p2)

			if type(v15) ~= "boolean" then
				v15 = if type(v15) == "string" then parseBooleanString(v15) else nil
			end
		end

		v9.isMoment = v15
		return v9
	end, { p2, data.universeId, data.placeId })

	local v6 = React.useCallback(function(p4, p5)
		local v7 = v5(p5)

		if not v7.videoAssetId then
			local v8 = p3
			local universeId = data.universeId
			local placeId = data.placeId
			discoveryEventErrorLogger.reportError(
				"UnifiedVideoEngagementEvent_MissingVideoAssetId",
				`SDUI video analytics "play" is missing videoAssetId on page "{v8}"`,
				{
					actionType = "play",
					pageContext = v8,
					universeId = universeId,
					placeId = placeId
				}
			)
		end

		discoveryVideoPlayEvent(p3, v7)
	end, { v5, p3, data.universeId, data.placeId })

	local v7 = React.useCallback(function(p4, p5, p6, p7)
		local v8 = v5(p5)

		if not v8.videoAssetId then
			local v9 = p3
			local universeId = data.universeId
			local placeId = data.placeId
			discoveryEventErrorLogger.reportError(
				"UnifiedVideoEngagementEvent_MissingVideoAssetId",
				`SDUI video analytics "load" is missing videoAssetId on page "{v9}"`,
				{
					actionType = "load",
					pageContext = v9,
					universeId = universeId,
					placeId = placeId
				}
			)
		end

		local v11 = {
			videoAssetId = v8.videoAssetId,
			videoPlaybackSessionId = v8.videoPlaybackSessionId,
			totalDuration = p6,
			loadTime = p7,
			universeId = v8.universeId,
			rootPlaceId = v8.rootPlaceId,
			gameSetTypeId = v8.gameSetTypeId,
			sortPos = v8.sortPos,
			nativeAdData = v8.nativeAdData,
			tileType = v8.tileType,
			contentType = v8.contentType,
			isMoment = 0
		}
		local v12 = if fFlagLuaAppDiscoveryMomentVideoTelemetry then v8.isMoment else nil
		v11.isMoment = v12
		discoveryVideoLoadEvent(p3, v11)

		if v8.videoAssetId and data.sourceId then
			videoLogger.reportVideoAction(
				videoActions.load,
				p3,
				{
					videoAssetId = v8.videoAssetId,
					source = data.source,
					sourceId = data.sourceId,
					playbackSessionId = v8.videoPlaybackSessionId
				},
				{ loadTime = p7 }
			)
		end
	end, { v5, p3, data.source, data.sourceId, data.universeId, data.placeId })

	local v8 = React.useCallback(function(p4, p5)
		local v9 = v5(p5)

		if not v9.videoAssetId then
			local v10 = p3
			local universeId = data.universeId
			local placeId = data.placeId
			discoveryEventErrorLogger.reportError(
				"UnifiedVideoEngagementEvent_MissingVideoAssetId",
				`SDUI video analytics "loop" is missing videoAssetId on page "{v10}"`,
				{
					actionType = "loop",
					pageContext = v10,
					universeId = universeId,
					placeId = placeId
				}
			)
		end

		discoveryVideoLoopEvent(p3, v9)
	end, { v5, p3, data.universeId, data.placeId })

	local v9 = React.useCallback(function(p4, p5, p6, p7, p8)
		local v10 = v5(p6)

		if not v10.videoAssetId then
			local v11 = p3
			local universeId = data.universeId
			local placeId = data.placeId
			discoveryEventErrorLogger.reportError(
				"UnifiedVideoEngagementEvent_MissingVideoAssetId",
				`SDUI video analytics "end" is missing videoAssetId on page "{v11}"`,
				{
					actionType = "end",
					pageContext = v11,
					universeId = universeId,
					placeId = placeId
				}
			)
		end

		local v13 = {
			videoAssetId = v10.videoAssetId,
			videoPlaybackSessionId = v10.videoPlaybackSessionId,
			endReason = p5,
			playbackTime = p7,
			universeId = v10.universeId,
			rootPlaceId = v10.rootPlaceId,
			gameSetTypeId = v10.gameSetTypeId,
			sortPos = v10.sortPos,
			targetUniverseId = p8,
			nativeAdData = v10.nativeAdData,
			tileType = v10.tileType,
			contentType = v10.contentType,
			isMoment = 0
		}
		local v14 = if fFlagLuaAppDiscoveryMomentVideoTelemetry then v10.isMoment else nil
		v13.isMoment = v14
		discoveryVideoEndEvent(p3, v13)
	end, { v5, p3, data.universeId, data.placeId })

	return React.useMemo(function()
		return {
			reportVideoPlay = v6,
			reportVideoLoad = v7,
			reportVideoLoop = v8,
			reportVideoMute = nil,
			reportVideoEnd = v9
		}
	end, { v6, v7, v8, v9 })
end

return useSduiVideoAnalytics
