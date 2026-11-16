local DiscoveryTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/DiscoveryTypes")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")

local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Loggers").mutedError
local videoActions = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/VideoUtils").AnalyticsEnums.VideoActions
local videoLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/VideoUtils").VideoLogger
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/DiscoveryUtils").DiscoveryEventErrorLogger

require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")
local getGameTileLayoutData = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/getGameTileLayoutData")
local getLayoutDataVideo = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/getLayoutDataVideo")

local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/DiscoveryAnalytics")
local discoveryVideoEndEvent = DiscoveryAnalytics.Events.discoveryVideoEndEvent
local discoveryVideoLoadEvent = DiscoveryAnalytics.Events.discoveryVideoLoadEvent
local discoveryVideoLoopEvent = DiscoveryAnalytics.Events.discoveryVideoLoopEvent
local discoveryVideoPlayEvent = DiscoveryAnalytics.Events.discoveryVideoPlayEvent
local fFlagLuaAppEnableHomepageOneByTwoTile = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppEnableHomepageOneByTwoTile
local fFlagLuaAppHomeMomentVideoFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppHomeMomentVideoFallback
local fFlagLuaAppDiscoveryMomentVideoTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppDiscoveryMomentVideoTelemetry

local omniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType

local function getGameSortId(p2, p3)
	if p2 == nil then
		return nil
	end

	if p3 then
		return p2.topicId
	end

	return p2.gameSetTypeId
end

local function getVideoAssetId(p2, p3)
	if p2 and p2.primaryWideVideoAssetId then
		return p2.primaryWideVideoAssetId
	end

	if fFlagLuaAppEnableHomepageOneByTwoTile and p2 and p2.primaryVideoAssetId then
		return p2.primaryVideoAssetId
	end

	local v5 = getGameTileLayoutData(p2, p3)

	if not fFlagLuaAppHomeMomentVideoFallback then
		return v5 and v5.primaryMediaAsset and v5.primaryMediaAsset.wideVideoAssetId
	end

	local v6 = getLayoutDataVideo(v5)
	return v6 and v6.assetId
end

local function getVideoAssetIdAndIsMoment(p2, p3)
	if fFlagLuaAppEnableHomepageOneByTwoTile and p2 and p2.primaryVideoAssetId then
		return p2.primaryVideoAssetId, false
	end

	local v6 = getLayoutDataVideo(getGameTileLayoutData(p2, p3), p2 and p2.primaryWideVideoAssetId)

	local assetId = v6 and v6.assetId
	return assetId, v6 ~= nil and v6.isMoment == true
end

local function useVideoAnalytics(p2, p3, p4, p5, p6)
	local v5 = if p2 ~= nil then (if p3 then p2.topicId else p2.gameSetTypeId) else nil

	local v6 = React.useCallback(function(p7, value)
		if p7 ~= nil and p6 ~= nil then
			local v7 = p6[p7]

			if not v7 then
				mutedError("reportVideoPlay requires a valid entry")
			end

			local v8 = nil
			local v9

			if fFlagLuaAppDiscoveryMomentVideoTelemetry then
				local v10 = v5

				if fFlagLuaAppEnableHomepageOneByTwoTile and v7 and v7.primaryVideoAssetId then
					v9 = v7.primaryVideoAssetId
					v8 = false
				else
					local v12 = getLayoutDataVideo(getGameTileLayoutData(v7, v10), v7 and v7.primaryWideVideoAssetId)

					v9 = v12 and v12.assetId
					v8 = not (v12 == nil) and v12.isMoment == true
				end
			else
				local v10 = v5

				if v7 and v7.primaryWideVideoAssetId then
					v9 = v7.primaryWideVideoAssetId
				elseif fFlagLuaAppEnableHomepageOneByTwoTile and v7 and v7.primaryVideoAssetId then
					v9 = v7.primaryVideoAssetId
				else
					local v11 = getGameTileLayoutData(v7, v10)

					if fFlagLuaAppHomeMomentVideoFallback then
						v9 = getLayoutDataVideo(v11)

						if v9 then
							v9 = v9.assetId
						end
					else
						v9 = if v11 then v11.primaryMediaAsset and v11.primaryMediaAsset.wideVideoAssetId else v11
					end
				end
			end

			if not v9 then
				mutedError("reportVideoPlay requires a valid videoAssetId")
			end

			local v12 = {
				videoAssetId = v9,
				videoPlaybackSessionId = value or "INVALID_SESSION_ID",
				universeId = v7.universeId,
				rootPlaceId = v7.placeId,
				gameSetTypeId = v5,
				sortPos = p5,
				nativeAdData = v7.adId,
				tileType = v7.componentType,
				contentType = v7.contentType,
				isMoment = 0
			}

			if not fFlagLuaAppDiscoveryMomentVideoTelemetry then
				v8 = nil
			end

			v12.isMoment = v8
			discoveryVideoPlayEvent(p4, v12)
		end
	end, { p4, p6, v5, p5 })

	local v7 = React.useCallback(function(p7, value, p8, p9)
		if p7 ~= nil and p6 ~= nil then
			local v8 = p6[p7]

			if not v8 then
				mutedError("reportVideoLoad requires a valid entry")
			end

			local v9 = nil
			local v10

			if fFlagLuaAppDiscoveryMomentVideoTelemetry then
				local v11 = v5

				if fFlagLuaAppEnableHomepageOneByTwoTile and v8 and v8.primaryVideoAssetId then
					v10 = v8.primaryVideoAssetId
					v9 = false
				else
					local v13 = getLayoutDataVideo(getGameTileLayoutData(v8, v11), v8 and v8.primaryWideVideoAssetId)

					v10 = v13 and v13.assetId
					v9 = not (v13 == nil) and v13.isMoment == true
				end
			else
				local v11 = v5

				if v8 and v8.primaryWideVideoAssetId then
					v10 = v8.primaryWideVideoAssetId
				elseif fFlagLuaAppEnableHomepageOneByTwoTile and v8 and v8.primaryVideoAssetId then
					v10 = v8.primaryVideoAssetId
				else
					local v12 = getGameTileLayoutData(v8, v11)

					if fFlagLuaAppHomeMomentVideoFallback then
						v10 = getLayoutDataVideo(v12)

						if v10 then
							v10 = v10.assetId
						end
					else
						v10 = if v12 then v12.primaryMediaAsset and v12.primaryMediaAsset.wideVideoAssetId else v12
					end
				end
			end

			if not v10 then
				mutedError("reportVideoLoad requires a valid videoAssetId")
			end

			local v11

			if fFlagLuaAppEnableHomepageOneByTwoTile then
				v11 = v8.contentType == omniRecommendationsContentType.AdLink
			end

			if not (v8.universeId or v11) then
				discoveryEventErrorLogger.reportError(
					"UnifiedVideoEngagementEvent_MissingUniverseId",
					`reportVideoLoad: entry at index {p7} is missing universeId for unified "load" on page "{p4}"`,
					{
						index = p7,
						pageContext = p4,
						gameSortId = v5,
						placeId = v8.placeId,
						videoAssetId = v10
					}
				)
			end

			local v14 = {
				videoAssetId = v10,
				videoPlaybackSessionId = value or "INVALID_SESSION_ID",
				totalDuration = p8,
				loadTime = p9,
				universeId = v8.universeId,
				rootPlaceId = v8.placeId,
				gameSetTypeId = v5,
				sortPos = p5,
				nativeAdData = v8.adId,
				tileType = v8.componentType,
				contentType = v8.contentType,
				isMoment = 0
			}

			if not fFlagLuaAppDiscoveryMomentVideoTelemetry then
				v9 = nil
			end

			v14.isMoment = v9
			discoveryVideoLoadEvent(p4, v14)

			if fFlagLuaAppEnableHomepageOneByTwoTile then
				if v10 and (v11 or v8.universeId) then
					local reportVideoAction = videoLogger.reportVideoAction
					local load = videoActions.load

					local v17 = if v11 then tostring(v8.clickoutUrl) else tostring(v8.universeId)
					reportVideoAction(load, p4, {
						videoAssetId = v10,
						source = v11 and "adLink" or "universe",
						sourceId = v17,
						playbackSessionId = value or "INVALID_SESSION_ID"
					}, { loadTime = p9 })
				end
			elseif v8.universeId and v10 then
				videoLogger.reportVideoAction(videoActions.load, p4, {
					videoAssetId = v10,
					source = "universe",
					sourceId = tostring(v8.universeId),
					playbackSessionId = value or "INVALID_SESSION_ID"
				}, { loadTime = p9 })
			end
		end
	end, { p4, p6, v5, p5 })

	local v8 = React.useCallback(function(p7, value)
		if p7 ~= nil and p6 ~= nil then
			local v9 = p6[p7]

			if not v9 then
				mutedError("reportVideoLoop requires a valid entry")
			end

			local v10 = nil
			local v11

			if fFlagLuaAppDiscoveryMomentVideoTelemetry then
				local v12 = v5

				if fFlagLuaAppEnableHomepageOneByTwoTile and v9 and v9.primaryVideoAssetId then
					v11 = v9.primaryVideoAssetId
					v10 = false
				else
					local v14 = getLayoutDataVideo(getGameTileLayoutData(v9, v12), v9 and v9.primaryWideVideoAssetId)

					v11 = v14 and v14.assetId
					v10 = not (v14 == nil) and v14.isMoment == true
				end
			else
				local v12 = v5

				if v9 and v9.primaryWideVideoAssetId then
					v11 = v9.primaryWideVideoAssetId
				elseif fFlagLuaAppEnableHomepageOneByTwoTile and v9 and v9.primaryVideoAssetId then
					v11 = v9.primaryVideoAssetId
				else
					local v13 = getGameTileLayoutData(v9, v12)

					if fFlagLuaAppHomeMomentVideoFallback then
						v11 = getLayoutDataVideo(v13)

						if v11 then
							v11 = v11.assetId
						end
					else
						v11 = if v13 then v13.primaryMediaAsset and v13.primaryMediaAsset.wideVideoAssetId else v13
					end
				end
			end

			if not v11 then
				mutedError("reportVideoLoop requires a valid videoAssetId")
			end

			local v14 = {
				videoAssetId = v11,
				videoPlaybackSessionId = value or "INVALID_SESSION_ID",
				universeId = v9.universeId,
				rootPlaceId = v9.placeId,
				gameSetTypeId = v5,
				sortPos = p5,
				nativeAdData = v9.adId,
				tileType = v9.componentType,
				contentType = v9.contentType,
				isMoment = 0
			}

			if not fFlagLuaAppDiscoveryMomentVideoTelemetry then
				v10 = nil
			end

			v14.isMoment = v10
			discoveryVideoLoopEvent(p4, v14)
		end
	end, { p4, p6, v5, p5 })

	local v9 = React.useCallback(function(p7, p8, value, p9, p10)
		if p7 ~= nil and p6 ~= nil then
			local v10 = p6[p7]

			if not v10 then
				mutedError("reportVideoEnd requires a valid entry")
			end

			local v11 = nil
			local v12

			if fFlagLuaAppDiscoveryMomentVideoTelemetry then
				local v13 = v5

				if fFlagLuaAppEnableHomepageOneByTwoTile and v10 and v10.primaryVideoAssetId then
					v12 = v10.primaryVideoAssetId
					v11 = false
				else
					local v15 = getLayoutDataVideo(getGameTileLayoutData(v10, v13), v10 and v10.primaryWideVideoAssetId)

					v12 = v15 and v15.assetId
					v11 = not (v15 == nil) and v15.isMoment == true
				end
			else
				local v13 = v5

				if v10 and v10.primaryWideVideoAssetId then
					v12 = v10.primaryWideVideoAssetId
				elseif fFlagLuaAppEnableHomepageOneByTwoTile and v10 and v10.primaryVideoAssetId then
					v12 = v10.primaryVideoAssetId
				else
					local v14 = getGameTileLayoutData(v10, v13)

					if fFlagLuaAppHomeMomentVideoFallback then
						v12 = getLayoutDataVideo(v14)

						if v12 then
							v12 = v12.assetId
						end
					else
						v12 = if v14 then v14.primaryMediaAsset and v14.primaryMediaAsset.wideVideoAssetId else v14
					end
				end
			end

			if not v12 then
				mutedError("reportVideoEnd requires a valid videoAssetId")
			end

			local v15 = {
				videoAssetId = v12,
				videoPlaybackSessionId = value or "INVALID_SESSION_ID",
				endReason = p8,
				playbackTime = p9,
				universeId = v10.universeId,
				rootPlaceId = v10.placeId,
				gameSetTypeId = v5,
				sortPos = p5,
				targetUniverseId = p10,
				nativeAdData = v10.adId,
				tileType = v10.componentType,
				contentType = v10.contentType,
				isMoment = 0
			}

			if not fFlagLuaAppDiscoveryMomentVideoTelemetry then
				v11 = nil
			end

			v15.isMoment = v11
			discoveryVideoEndEvent(p4, v15)
		end
	end, { p4, p6, v5, p5 })

	return React.useMemo(function()
		return {
			reportVideoPlay = v6,
			reportVideoLoad = v7,
			reportVideoLoop = v8,
			reportVideoEnd = v9
		}
	end, { v6, v7, v8, v9 })
end

return useVideoAnalytics
