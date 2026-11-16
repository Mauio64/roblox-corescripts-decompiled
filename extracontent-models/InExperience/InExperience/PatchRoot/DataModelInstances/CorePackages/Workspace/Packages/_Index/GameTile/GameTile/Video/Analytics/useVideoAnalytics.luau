local GameTile = script:FindFirstAncestor("GameTile")

local parent = GameTile.Parent

local DiscoveryTypes = require(parent.DiscoveryTypes)
local React = require(parent.React)

local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local VideoUtils = require(parent.VideoUtils)
local VideoActions = VideoUtils.AnalyticsEnums.VideoActions
local VideoUtils2 = require(parent.VideoUtils)
local VideoLogger = VideoUtils2.VideoLogger
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

require(GameTile.GameTileTypes)
local getGameTileLayoutData = require(GameTile.getGameTileLayoutData)
local getLayoutDataVideo = require(GameTile.getLayoutDataVideo)

local DiscoveryAnalytics = require(GameTile.Parent.DiscoveryAnalytics)
local discoveryVideoEndEvent = DiscoveryAnalytics.Events.discoveryVideoEndEvent
local discoveryVideoLoadEvent = DiscoveryAnalytics.Events.discoveryVideoLoadEvent
local discoveryVideoLoopEvent = DiscoveryAnalytics.Events.discoveryVideoLoopEvent
local discoveryVideoPlayEvent = DiscoveryAnalytics.Events.discoveryVideoPlayEvent
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppHomeMomentVideoFallback = SharedFlags2.FFlagLuaAppHomeMomentVideoFallback
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppDiscoveryMomentVideoTelemetry = SharedFlags3.FFlagLuaAppDiscoveryMomentVideoTelemetry

local OmniRecommendationsContentType = DiscoveryTypes.OmniRecommendationsContentType

local function getGameSortId(p, flag: boolean) -- 1 equivalent call inferred from this helper
	if p == nil then
		return nil
	end

	return if flag then p.topicId else p.gameSetTypeId
end

local function getVideoAssetId(p, p2: string?)
	if p and p.primaryWideVideoAssetId then
		return p.primaryWideVideoAssetId
	end

	if FFlagLuaAppEnableHomepageOneByTwoTile and p and p.primaryVideoAssetId then
		return p.primaryVideoAssetId
	end

	local gameTileLayoutData = getGameTileLayoutData(p, p2)

	if not FFlagLuaAppHomeMomentVideoFallback then
		return gameTileLayoutData
			and gameTileLayoutData.primaryMediaAsset
			and gameTileLayoutData.primaryMediaAsset.wideVideoAssetId
	end

	local layoutDataVideo = getLayoutDataVideo(gameTileLayoutData)
	return layoutDataVideo and layoutDataVideo.assetId
end

local function getVideoAssetIdAndIsMoment(p, p2: string?)
	if FFlagLuaAppEnableHomepageOneByTwoTile and p and p.primaryVideoAssetId then
		return p.primaryVideoAssetId, false
	end

	local layoutDataVideo = getLayoutDataVideo(getGameTileLayoutData(p, p2), p and p.primaryWideVideoAssetId)

	local assetId = layoutDataVideo and layoutDataVideo.assetId
	return assetId, layoutDataVideo ~= nil and layoutDataVideo.isMoment == true
end

local function useVideoAnalytics(p, flag: boolean, pageContext: string, sortPos: number, p2)
	local gameSortId = getGameSortId(p, flag) -- inferred equivalent call
	local reportVideoPlay = React.useCallback(function(p3: number?, value: string?)
		if p3 ~= nil and p2 ~= nil then
			local v = p2[p3]

			if not v then
				mutedError("reportVideoPlay requires a valid entry")
			end

			local isMoment = nil
			local videoAssetId

			if FFlagLuaAppDiscoveryMomentVideoTelemetry then
				local v2 = gameSortId

				if FFlagLuaAppEnableHomepageOneByTwoTile and v and v.primaryVideoAssetId then
					videoAssetId = v.primaryVideoAssetId
					isMoment = false
				else
					local layoutDataVideo = getLayoutDataVideo(
						getGameTileLayoutData(v, v2),
						v and v.primaryWideVideoAssetId
					)

					videoAssetId = layoutDataVideo and layoutDataVideo.assetId

					if layoutDataVideo == nil then
						isMoment = false
					else
						isMoment = layoutDataVideo.isMoment == true
					end
				end
			else
				local v2 = gameSortId

				if v and v.primaryWideVideoAssetId then
					videoAssetId = v.primaryWideVideoAssetId
				elseif FFlagLuaAppEnableHomepageOneByTwoTile and v and v.primaryVideoAssetId then
					videoAssetId = v.primaryVideoAssetId
				else
					local gameTileLayoutData = getGameTileLayoutData(v, v2)

					if FFlagLuaAppHomeMomentVideoFallback then
						videoAssetId = getLayoutDataVideo(gameTileLayoutData)

						if videoAssetId then
							videoAssetId = videoAssetId.assetId
						end
					elseif gameTileLayoutData then
						videoAssetId = gameTileLayoutData.primaryMediaAsset
							and gameTileLayoutData.primaryMediaAsset.wideVideoAssetId
					else
						videoAssetId = gameTileLayoutData
					end
				end
			end

			if not videoAssetId then
				mutedError("reportVideoPlay requires a valid videoAssetId")
			end

			local v2 = {
				videoAssetId = videoAssetId,
				videoPlaybackSessionId = value or "INVALID_SESSION_ID",
				universeId = v.universeId,
				rootPlaceId = v.placeId,
				gameSetTypeId = gameSortId,
				sortPos = sortPos,
				nativeAdData = v.adId,
				tileType = v.componentType,
				contentType = v.contentType,
				isMoment = 0
			}

			if not FFlagLuaAppDiscoveryMomentVideoTelemetry then
				isMoment = nil
			end

			v2.isMoment = isMoment
			discoveryVideoPlayEvent(pageContext, v2)
		end
	end, { pageContext, p2, gameSortId, sortPos })

	local reportVideoLoad = React.useCallback(
		function(p3: number?, value: string?, totalDuration: number, loadTime: number)
			if p3 ~= nil and p2 ~= nil then
				local v = p2[p3]

				if not v then
					mutedError("reportVideoLoad requires a valid entry")
				end

				local isMoment = nil
				local videoAssetId

				if FFlagLuaAppDiscoveryMomentVideoTelemetry then
					local v2 = gameSortId

					if FFlagLuaAppEnableHomepageOneByTwoTile and v and v.primaryVideoAssetId then
						videoAssetId = v.primaryVideoAssetId
						isMoment = false
					else
						local layoutDataVideo = getLayoutDataVideo(
							getGameTileLayoutData(v, v2),
							v and v.primaryWideVideoAssetId
						)

						videoAssetId = layoutDataVideo and layoutDataVideo.assetId

						if layoutDataVideo == nil then
							isMoment = false
						else
							isMoment = layoutDataVideo.isMoment == true
						end
					end
				else
					local v2 = gameSortId

					if v and v.primaryWideVideoAssetId then
						videoAssetId = v.primaryWideVideoAssetId
					elseif FFlagLuaAppEnableHomepageOneByTwoTile and v and v.primaryVideoAssetId then
						videoAssetId = v.primaryVideoAssetId
					else
						local gameTileLayoutData = getGameTileLayoutData(v, v2)

						if FFlagLuaAppHomeMomentVideoFallback then
							videoAssetId = getLayoutDataVideo(gameTileLayoutData)

							if videoAssetId then
								videoAssetId = videoAssetId.assetId
							end
						elseif gameTileLayoutData then
							videoAssetId = gameTileLayoutData.primaryMediaAsset
								and gameTileLayoutData.primaryMediaAsset.wideVideoAssetId
						else
							videoAssetId = gameTileLayoutData
						end
					end
				end

				if not videoAssetId then
					mutedError("reportVideoLoad requires a valid videoAssetId")
				end

				local v2

				if FFlagLuaAppEnableHomepageOneByTwoTile then
					v2 = v.contentType == OmniRecommendationsContentType.AdLink
				end

				if not (v.universeId or v2) then
					DiscoveryEventErrorLogger.reportError(
						"UnifiedVideoEngagementEvent_MissingUniverseId",
						`reportVideoLoad: entry at index {p3} is missing universeId for unified "load" on page "{pageContext}"`,
						{
							index = p3,
							pageContext = pageContext,
							gameSortId = gameSortId,
							placeId = v.placeId,
							videoAssetId = videoAssetId
						}
					)
				end

				local v3 = {
					videoAssetId = videoAssetId,
					videoPlaybackSessionId = value or "INVALID_SESSION_ID",
					totalDuration = totalDuration,
					loadTime = loadTime,
					universeId = v.universeId,
					rootPlaceId = v.placeId,
					gameSetTypeId = gameSortId,
					sortPos = sortPos,
					nativeAdData = v.adId,
					tileType = v.componentType,
					contentType = v.contentType,
					isMoment = 0
				}

				if not FFlagLuaAppDiscoveryMomentVideoTelemetry then
					isMoment = nil
				end

				v3.isMoment = isMoment
				discoveryVideoLoadEvent(pageContext, v3)

				if FFlagLuaAppEnableHomepageOneByTwoTile then
					if videoAssetId and (v2 or v.universeId) then
						local reportVideoAction = VideoLogger.reportVideoAction
						local load = VideoActions.load
						local v4 = {
							videoAssetId = videoAssetId,
							source = v2 and "adLink" or "universe",
							sourceId = 0,
							playbackSessionId = 0
						}
						local sourceId

						if v2 then
							sourceId = tostring(v.clickoutUrl)
						else
							sourceId = tostring(v.universeId)
						end

						v4.sourceId = sourceId

						v4.playbackSessionId = value or "INVALID_SESSION_ID"
						reportVideoAction(load, pageContext, v4, { loadTime = loadTime })
					end
				elseif v.universeId and videoAssetId then
					VideoLogger.reportVideoAction(VideoActions.load, pageContext, {
						videoAssetId = videoAssetId,
						source = "universe",
						sourceId = tostring(v.universeId),
						playbackSessionId = value or "INVALID_SESSION_ID"
					}, { loadTime = loadTime })
				end
			end
		end,
		{ pageContext, p2, gameSortId, sortPos }
	)

	local reportVideoLoop = React.useCallback(function(p3: number?, value: string?)
		if p3 ~= nil and p2 ~= nil then
			local v = p2[p3]

			if not v then
				mutedError("reportVideoLoop requires a valid entry")
			end

			local isMoment = nil
			local videoAssetId

			if FFlagLuaAppDiscoveryMomentVideoTelemetry then
				local v2 = gameSortId

				if FFlagLuaAppEnableHomepageOneByTwoTile and v and v.primaryVideoAssetId then
					videoAssetId = v.primaryVideoAssetId
					isMoment = false
				else
					local layoutDataVideo = getLayoutDataVideo(
						getGameTileLayoutData(v, v2),
						v and v.primaryWideVideoAssetId
					)

					videoAssetId = layoutDataVideo and layoutDataVideo.assetId

					if layoutDataVideo == nil then
						isMoment = false
					else
						isMoment = layoutDataVideo.isMoment == true
					end
				end
			else
				local v2 = gameSortId

				if v and v.primaryWideVideoAssetId then
					videoAssetId = v.primaryWideVideoAssetId
				elseif FFlagLuaAppEnableHomepageOneByTwoTile and v and v.primaryVideoAssetId then
					videoAssetId = v.primaryVideoAssetId
				else
					local gameTileLayoutData = getGameTileLayoutData(v, v2)

					if FFlagLuaAppHomeMomentVideoFallback then
						videoAssetId = getLayoutDataVideo(gameTileLayoutData)

						if videoAssetId then
							videoAssetId = videoAssetId.assetId
						end
					elseif gameTileLayoutData then
						videoAssetId = gameTileLayoutData.primaryMediaAsset
							and gameTileLayoutData.primaryMediaAsset.wideVideoAssetId
					else
						videoAssetId = gameTileLayoutData
					end
				end
			end

			if not videoAssetId then
				mutedError("reportVideoLoop requires a valid videoAssetId")
			end

			local v2 = {
				videoAssetId = videoAssetId,
				videoPlaybackSessionId = value or "INVALID_SESSION_ID",
				universeId = v.universeId,
				rootPlaceId = v.placeId,
				gameSetTypeId = gameSortId,
				sortPos = sortPos,
				nativeAdData = v.adId,
				tileType = v.componentType,
				contentType = v.contentType,
				isMoment = 0
			}

			if not FFlagLuaAppDiscoveryMomentVideoTelemetry then
				isMoment = nil
			end

			v2.isMoment = isMoment
			discoveryVideoLoopEvent(pageContext, v2)
		end
	end, { pageContext, p2, gameSortId, sortPos })

	local reportVideoEnd = React.useCallback(
		function(p3: number?, endReason: string, value: string?, playbackTime: number, targetUniverseId: string?)
			if p3 ~= nil and p2 ~= nil then
				local v = p2[p3]

				if not v then
					mutedError("reportVideoEnd requires a valid entry")
				end

				local isMoment = nil
				local videoAssetId

				if FFlagLuaAppDiscoveryMomentVideoTelemetry then
					local v2 = gameSortId

					if FFlagLuaAppEnableHomepageOneByTwoTile and v and v.primaryVideoAssetId then
						videoAssetId = v.primaryVideoAssetId
						isMoment = false
					else
						local layoutDataVideo = getLayoutDataVideo(
							getGameTileLayoutData(v, v2),
							v and v.primaryWideVideoAssetId
						)

						videoAssetId = layoutDataVideo and layoutDataVideo.assetId

						if layoutDataVideo == nil then
							isMoment = false
						else
							isMoment = layoutDataVideo.isMoment == true
						end
					end
				else
					local v2 = gameSortId

					if v and v.primaryWideVideoAssetId then
						videoAssetId = v.primaryWideVideoAssetId
					elseif FFlagLuaAppEnableHomepageOneByTwoTile and v and v.primaryVideoAssetId then
						videoAssetId = v.primaryVideoAssetId
					else
						local gameTileLayoutData = getGameTileLayoutData(v, v2)

						if FFlagLuaAppHomeMomentVideoFallback then
							videoAssetId = getLayoutDataVideo(gameTileLayoutData)

							if videoAssetId then
								videoAssetId = videoAssetId.assetId
							end
						elseif gameTileLayoutData then
							videoAssetId = gameTileLayoutData.primaryMediaAsset
								and gameTileLayoutData.primaryMediaAsset.wideVideoAssetId
						else
							videoAssetId = gameTileLayoutData
						end
					end
				end

				if not videoAssetId then
					mutedError("reportVideoEnd requires a valid videoAssetId")
				end

				local v2 = {
					videoAssetId = videoAssetId,
					videoPlaybackSessionId = value or "INVALID_SESSION_ID",
					endReason = endReason,
					playbackTime = playbackTime,
					universeId = v.universeId,
					rootPlaceId = v.placeId,
					gameSetTypeId = gameSortId,
					sortPos = sortPos,
					targetUniverseId = targetUniverseId,
					nativeAdData = v.adId,
					tileType = v.componentType,
					contentType = v.contentType,
					isMoment = 0
				}

				if not FFlagLuaAppDiscoveryMomentVideoTelemetry then
					isMoment = nil
				end

				v2.isMoment = isMoment
				discoveryVideoEndEvent(pageContext, v2)
			end
		end,
		{ pageContext, p2, gameSortId, sortPos }
	)

	return (React.useMemo(function()
		return {
			reportVideoPlay = reportVideoPlay,
			reportVideoLoad = reportVideoLoad,
			reportVideoLoop = reportVideoLoop,
			reportVideoEnd = reportVideoEnd
		}
	end, { reportVideoPlay, reportVideoLoad, reportVideoLoop, reportVideoEnd }))
end

return useVideoAnalytics
