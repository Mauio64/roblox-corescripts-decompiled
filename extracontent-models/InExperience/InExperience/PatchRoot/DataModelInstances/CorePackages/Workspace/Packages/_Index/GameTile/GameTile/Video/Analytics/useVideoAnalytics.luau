local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent

require(GameTileParent.DiscoveryTypes)

local React = require(GameTileParent.React)
local mutedError = require(GameTileParent.Loggers).mutedError
local VideoActions = require(GameTileParent.VideoUtils).AnalyticsEnums.VideoActions
local VideoLogger = require(GameTileParent.VideoUtils).VideoLogger
local DiscoveryEventErrorLogger = require(GameTileParent.DiscoveryUtils).DiscoveryEventErrorLogger

require(GameTile.GameTileTypes)

local getGameTileLayoutData = require(GameTile.getGameTileLayoutData)
local FFlagLuaAppHomeReduceRenders = require(GameTileParent.SharedFlags).FFlagLuaAppHomeReduceRenders
local DiscoveryAnalytics = require(GameTile.Parent.DiscoveryAnalytics)
local discoveryVideoEndEvent = DiscoveryAnalytics.Events.discoveryVideoEndEvent
local discoveryVideoLoadEvent = DiscoveryAnalytics.Events.discoveryVideoLoadEvent
local discoveryVideoLoopEvent = DiscoveryAnalytics.Events.discoveryVideoLoopEvent
local discoveryVideoPlayEvent = DiscoveryAnalytics.Events.discoveryVideoPlayEvent

local function getGameSortId(p1, b1: boolean) -- line: 29
	if p1 ~= nil then
		if b1 then
			return p1.topicId
		end

		return p1.gameSetTypeId
	end

	return nil
end
local function getVideoAssetId(p2, s1: string?) -- line: 41
	-- upvalues: getGameTileLayoutData (copy)
	if p2 and p2.primaryWideVideoAssetId then
		return p2.primaryWideVideoAssetId
	end

	local v22 = getGameTileLayoutData(p2, s1)

	return v22 and (v22.primaryMediaAsset and v22.primaryMediaAsset.wideVideoAssetId)
end
local function useVideoAnalytics(p3, b2: boolean, s2: string, n1: number, t1: {[any]: any}?) -- line: 54
	-- upvalues: React (copy), mutedError (copy), getGameTileLayoutData (copy), discoveryVideoPlayEvent (copy), DiscoveryEventErrorLogger (copy), discoveryVideoLoadEvent (copy), VideoLogger (copy), VideoActions (copy), discoveryVideoLoopEvent (copy), discoveryVideoEndEvent (copy), FFlagLuaAppHomeReduceRenders (copy)
	local v28 = if p3 == nil then nil else if not b2 then p3.gameSetTypeId else p3.topicId
	local v29 = React.useCallback(function(n2: number?, s3: string?) -- line: 63
		-- upvalues: t1 (copy), mutedError (copy), v28 (copy), getGameTileLayoutData (copy), discoveryVideoPlayEvent (copy), s2 (copy), n1 (copy)
		if n2 ~= nil and t1 ~= nil then
			local v35 = t1[n2]

			if not v35 then
				mutedError("reportVideoPlay requires a valid entry")
			end

			local v36 = v28
			local primaryWideVideoAssetId

			if v35 and v35.primaryWideVideoAssetId then
				primaryWideVideoAssetId = v35.primaryWideVideoAssetId
			else
				local v38 = getGameTileLayoutData(v35, v36)

				primaryWideVideoAssetId = v38 and (v38.primaryMediaAsset and v38.primaryMediaAsset.wideVideoAssetId)
			end

			if not primaryWideVideoAssetId then
				mutedError("reportVideoPlay requires a valid videoAssetId")
			end

			discoveryVideoPlayEvent(s2, {
				videoAssetId = primaryWideVideoAssetId,
				videoPlaybackSessionId = s3 or "INVALID_SESSION_ID",
				universeId = v35.universeId,
				rootPlaceId = v35.placeId,
				gameSetTypeId = v28,
				sortPos = n1
			})
		end
	end, {
		s2,
		t1,
		v28,
		n1
	})
	local v30 = React.useCallback(function(n3: number?, s4: string?, n4: number, n5: number) -- line: 87
		-- upvalues: t1 (copy), mutedError (copy), v28 (copy), getGameTileLayoutData (copy), DiscoveryEventErrorLogger (copy), s2 (copy), discoveryVideoLoadEvent (copy), n1 (copy), VideoLogger (copy), VideoActions (copy)
		if n3 ~= nil and t1 ~= nil then
			local v43 = t1[n3]

			if not v43 then
				mutedError("reportVideoLoad requires a valid entry")
			end

			local v44 = v28
			local primaryWideVideoAssetId

			if v43 and v43.primaryWideVideoAssetId then
				primaryWideVideoAssetId = v43.primaryWideVideoAssetId
			else
				local v46 = getGameTileLayoutData(v43, v44)

				primaryWideVideoAssetId = v46 and (v46.primaryMediaAsset and v46.primaryMediaAsset.wideVideoAssetId)
			end

			if not primaryWideVideoAssetId then
				mutedError("reportVideoLoad requires a valid videoAssetId")
			end

			if not v43.universeId then
				DiscoveryEventErrorLogger.reportError("UnifiedVideoEngagementEvent_MissingUniverseId", `reportVideoLoad: entry at index { n3 } is missing universeId for unified "load" on page "{ s2 }"`, {
					index = n3,
					pageContext = s2,
					gameSortId = v28,
					placeId = v43.placeId,
					videoAssetId = primaryWideVideoAssetId
				})
			end

			discoveryVideoLoadEvent(s2, {
				videoAssetId = primaryWideVideoAssetId,
				videoPlaybackSessionId = s4 or "INVALID_SESSION_ID",
				totalDuration = n4,
				loadTime = n5,
				universeId = v43.universeId,
				rootPlaceId = v43.placeId,
				gameSetTypeId = v28,
				sortPos = n1
			})

			if v43.universeId and primaryWideVideoAssetId then
				VideoLogger.reportVideoAction(VideoActions.load, s2, {
					source = "universe",
					videoAssetId = primaryWideVideoAssetId,
					sourceId = tostring(v43.universeId),
					playbackSessionId = s4 or "INVALID_SESSION_ID"
				}, {
					loadTime = n5
				})
			end
		end
	end, {
		s2,
		t1,
		v28,
		n1
	})
	local v31 = React.useCallback(function(n6: number?, s5: string?) -- line: 137
		-- upvalues: t1 (copy), mutedError (copy), v28 (copy), getGameTileLayoutData (copy), discoveryVideoLoopEvent (copy), s2 (copy), n1 (copy)
		if n6 ~= nil and t1 ~= nil then
			local v49 = t1[n6]

			if not v49 then
				mutedError("reportVideoLoop requires a valid entry")
			end

			local v50 = v28
			local primaryWideVideoAssetId

			if v49 and v49.primaryWideVideoAssetId then
				primaryWideVideoAssetId = v49.primaryWideVideoAssetId
			else
				local v52 = getGameTileLayoutData(v49, v50)

				primaryWideVideoAssetId = v52 and (v52.primaryMediaAsset and v52.primaryMediaAsset.wideVideoAssetId)
			end

			if not primaryWideVideoAssetId then
				mutedError("reportVideoLoop requires a valid videoAssetId")
			end

			discoveryVideoLoopEvent(s2, {
				videoAssetId = primaryWideVideoAssetId,
				videoPlaybackSessionId = s5 or "INVALID_SESSION_ID",
				universeId = v49.universeId,
				rootPlaceId = v49.placeId,
				gameSetTypeId = v28,
				sortPos = n1
			})
		end
	end, {
		s2,
		t1,
		v28,
		n1
	})
	local v32 = React.useCallback(function(n7: number?, s6: string, s7: string?, n8: number, s8: string?) -- line: 161
		-- upvalues: t1 (copy), mutedError (copy), v28 (copy), getGameTileLayoutData (copy), discoveryVideoEndEvent (copy), s2 (copy), n1 (copy)
		if n7 ~= nil and t1 ~= nil then
			local v58 = t1[n7]

			if not v58 then
				mutedError("reportVideoEnd requires a valid entry")
			end

			local v59 = v28
			local primaryWideVideoAssetId

			if v58 and v58.primaryWideVideoAssetId then
				primaryWideVideoAssetId = v58.primaryWideVideoAssetId
			else
				local v61 = getGameTileLayoutData(v58, v59)

				primaryWideVideoAssetId = v61 and (v61.primaryMediaAsset and v61.primaryMediaAsset.wideVideoAssetId)
			end

			if not primaryWideVideoAssetId then
				mutedError("reportVideoEnd requires a valid videoAssetId")
			end

			discoveryVideoEndEvent(s2, {
				videoAssetId = primaryWideVideoAssetId,
				videoPlaybackSessionId = s7 or "INVALID_SESSION_ID",
				endReason = s6,
				playbackTime = n8,
				universeId = v58.universeId,
				rootPlaceId = v58.placeId,
				gameSetTypeId = v28,
				sortPos = n1,
				targetUniverseId = s8
			})
		end
	end, {
		s2,
		t1,
		v28,
		n1
	})

	if FFlagLuaAppHomeReduceRenders then
		return (React.useMemo(function() -- line: 196
			-- upvalues: v29 (copy), v30 (copy), v31 (copy), v32 (copy)
			return {
				reportVideoPlay = v29,
				reportVideoLoad = v30,
				reportVideoLoop = v31,
				reportVideoEnd = v32
			}
		end, {
			v29,
			v30,
			v31,
			v32
		}))
	end

	return {
		reportVideoPlay = v29,
		reportVideoLoad = v30,
		reportVideoLoop = v31,
		reportVideoEnd = v32
	}
end

return useVideoAnalytics
