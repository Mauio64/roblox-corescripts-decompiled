local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local discoveryVideoEndEvent = DiscoveryAnalytics.Events.discoveryVideoEndEvent
local discoveryVideoLoadEvent = DiscoveryAnalytics.Events.discoveryVideoLoadEvent
local discoveryVideoLoopEvent = DiscoveryAnalytics.Events.discoveryVideoLoopEvent
local discoveryVideoPlayEvent = DiscoveryAnalytics.Events.discoveryVideoPlayEvent

local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local parseBooleanString = DiscoveryUtils.parseBooleanString

local SduiCoreSystem = require(parent.SduiCoreSystem)
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors

local VideoUtils = require(parent.VideoUtils)
local VideoActions = VideoUtils.AnalyticsEnums.VideoActions
local VideoLogger = VideoUtils.VideoLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDiscoveryMomentVideoTelemetry = SharedFlags.FFlagLuaAppDiscoveryMomentVideoTelemetry

local function asOptionalString(p) -- 5 equivalent calls inferred from this helper
	if p == nil then
		return nil
	end

	return (tostring(p))
end

local function asOptionalBoolean(value) -- 1 equivalent call inferred from this helper
	if type(value) == "boolean" then
		return value
	end

	if type(value) == "string" then
		return (parseBooleanString(value))
	end

	return nil
end

local function reportMissingVideoAssetId(actionType: string, pageContext: string, universeId: string?, placeId: string?)
	DiscoveryEventErrorLogger.reportError(
		"UnifiedVideoEngagementEvent_MissingVideoAssetId",
		`SDUI video analytics "{actionType}" is missing videoAssetId on page "{pageContext}"`,
		{
			actionType = actionType,
			pageContext = pageContext,
			universeId = universeId,
			placeId = placeId
		}
	)
end

local function useSduiVideoAnalytics(p, pageContext: string, data)
	local v = React.useCallback(function(value: string?)
		local v

		if p.getCollectionData then
			v = p.getCollectionData()
		end

		local videoAssetId = asOptionalString(findAnalyticsFieldInAncestors("videoAssetId", p)) -- inferred equivalent call
		local v2 = findAnalyticsFieldInAncestors("nativeAdData", p) or findAnalyticsFieldInAncestors("adId", p)

		local v3 = {
			videoAssetId = videoAssetId,
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
		local gameSetTypeId

		if v then
			gameSetTypeId = asOptionalString(v.collectionId) -- inferred equivalent call
		end

		v3.gameSetTypeId = gameSetTypeId
		local sortPos

		if v then
			sortPos = v.collectionPosition
		end

		v3.sortPos = sortPos
		v3.nativeAdData = asOptionalString(v2) -- inferred equivalent call
		v3.tileType = asOptionalString(findAnalyticsFieldInAncestors("tileType", p)) -- inferred equivalent call
		v3.contentType = asOptionalString(findAnalyticsFieldInAncestors("contentType", p)) -- inferred equivalent call
		local isMoment

		if FFlagLuaAppDiscoveryMomentVideoTelemetry then
			isMoment = findAnalyticsFieldInAncestors("isMoment", p)
			isMoment = asOptionalBoolean(isMoment) -- inferred equivalent call
		end

		v3.isMoment = isMoment
		return v3
	end, { p, data.universeId, data.placeId })

	local reportVideoPlay = React.useCallback(function(_: number?, p2: string?)
		local v2 = v(p2)

		if not v2.videoAssetId then
			local pageContext2 = pageContext
			local universeId = data.universeId
			local placeId = data.placeId
			DiscoveryEventErrorLogger.reportError(
				"UnifiedVideoEngagementEvent_MissingVideoAssetId",
				`SDUI video analytics "play" is missing videoAssetId on page "{pageContext2}"`,
				{
					actionType = "play",
					pageContext = pageContext2,
					universeId = universeId,
					placeId = placeId
				}
			)
		end

		discoveryVideoPlayEvent(pageContext, v2)
	end, { v, pageContext, data.universeId, data.placeId })

	local reportVideoLoad = React.useCallback(function(_: number?, p2: string?, totalDuration: number, loadTime: number)
		local v2 = v(p2)

		if not v2.videoAssetId then
			local pageContext2 = pageContext
			local universeId = data.universeId
			local placeId = data.placeId
			DiscoveryEventErrorLogger.reportError(
				"UnifiedVideoEngagementEvent_MissingVideoAssetId",
				`SDUI video analytics "load" is missing videoAssetId on page "{pageContext2}"`,
				{
					actionType = "load",
					pageContext = pageContext2,
					universeId = universeId,
					placeId = placeId
				}
			)
		end

		local v3 = {
			videoAssetId = v2.videoAssetId,
			videoPlaybackSessionId = v2.videoPlaybackSessionId,
			totalDuration = totalDuration,
			loadTime = loadTime,
			universeId = v2.universeId,
			rootPlaceId = v2.rootPlaceId,
			gameSetTypeId = v2.gameSetTypeId,
			sortPos = v2.sortPos,
			nativeAdData = v2.nativeAdData,
			tileType = v2.tileType,
			contentType = v2.contentType,
			isMoment = 0
		}
		local isMoment

		if FFlagLuaAppDiscoveryMomentVideoTelemetry then
			isMoment = v2.isMoment
		end

		v3.isMoment = isMoment
		discoveryVideoLoadEvent(pageContext, v3)

		if v2.videoAssetId and data.sourceId then
			VideoLogger.reportVideoAction(
				VideoActions.load,
				pageContext,
				{
					videoAssetId = v2.videoAssetId,
					source = data.source,
					sourceId = data.sourceId,
					playbackSessionId = v2.videoPlaybackSessionId
				},
				{ loadTime = loadTime }
			)
		end
	end, { v, pageContext, data.source, data.sourceId, data.universeId, data.placeId })

	local reportVideoLoop = React.useCallback(function(_: number?, p2: string?)
		local v2 = v(p2)

		if not v2.videoAssetId then
			local pageContext2 = pageContext
			local universeId = data.universeId
			local placeId = data.placeId
			DiscoveryEventErrorLogger.reportError(
				"UnifiedVideoEngagementEvent_MissingVideoAssetId",
				`SDUI video analytics "loop" is missing videoAssetId on page "{pageContext2}"`,
				{
					actionType = "loop",
					pageContext = pageContext2,
					universeId = universeId,
					placeId = placeId
				}
			)
		end

		discoveryVideoLoopEvent(pageContext, v2)
	end, { v, pageContext, data.universeId, data.placeId })

	local reportVideoEnd = React.useCallback(
		function(_: number?, endReason: string, p2: string?, playbackTime: number, targetUniverseId: string?)
			local v2 = v(p2)

			if not v2.videoAssetId then
				local pageContext2 = pageContext
				local universeId = data.universeId
				local placeId = data.placeId
				DiscoveryEventErrorLogger.reportError(
					"UnifiedVideoEngagementEvent_MissingVideoAssetId",
					`SDUI video analytics "end" is missing videoAssetId on page "{pageContext2}"`,
					{
						actionType = "end",
						pageContext = pageContext2,
						universeId = universeId,
						placeId = placeId
					}
				)
			end

			local v3 = {
				videoAssetId = v2.videoAssetId,
				videoPlaybackSessionId = v2.videoPlaybackSessionId,
				endReason = endReason,
				playbackTime = playbackTime,
				universeId = v2.universeId,
				rootPlaceId = v2.rootPlaceId,
				gameSetTypeId = v2.gameSetTypeId,
				sortPos = v2.sortPos,
				targetUniverseId = targetUniverseId,
				nativeAdData = v2.nativeAdData,
				tileType = v2.tileType,
				contentType = v2.contentType,
				isMoment = 0
			}
			local isMoment

			if FFlagLuaAppDiscoveryMomentVideoTelemetry then
				isMoment = v2.isMoment
			end

			v3.isMoment = isMoment
			discoveryVideoEndEvent(pageContext, v3)
		end,
		{ v, pageContext, data.universeId, data.placeId }
	)

	return React.useMemo(function()
		return {
			reportVideoPlay = reportVideoPlay,
			reportVideoLoad = reportVideoLoad,
			reportVideoLoop = reportVideoLoop,
			reportVideoMute = nil,
			reportVideoEnd = reportVideoEnd
		}
	end, { reportVideoPlay, reportVideoLoad, reportVideoLoop, reportVideoEnd })
end

return useSduiVideoAnalytics
