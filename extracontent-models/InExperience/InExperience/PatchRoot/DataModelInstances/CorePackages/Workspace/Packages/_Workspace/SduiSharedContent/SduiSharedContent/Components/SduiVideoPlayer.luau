local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local VideoUtils = require(parent.VideoUtils)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppHomeMomentVideoFallback = SharedFlags.FFlagLuaAppHomeMomentVideoFallback
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppVideoPlayerTrimAndMusic = SharedFlags2.FFlagLuaAppVideoPlayerTrimAndMusic

local v = { PlayWhenReady = "PlayWhenReady" }

local function resolvePlaybackState(value: string?, flag: boolean?)
	if flag ~= nil then
		return flag, true
	end

	if (value or "PlayWhenReady") == "PlayWhenReady" then
		return true, true
	end

	return false, false
end

local function asString(p) -- 2 equivalent calls inferred from this helper
	if p == nil then
		return ""
	end

	return (tostring(p))
end

local function normalizeAssetId(videoAssetId: string?) -- 1 equivalent call inferred from this helper
	if videoAssetId == nil or videoAssetId == "" then
		return nil
	end

	if string.find(videoAssetId, "://", 1, true) then
		return videoAssetId
	end

	return `rbxassetid://{videoAssetId}`
end

local function SduiVideoPlayer(props)
	local assetId = normalizeAssetId(props.videoAssetId) -- inferred equivalent call

	local looped = not (props.loop == nil) and props.loop
	local muted = props.muted == nil or props.muted
	local v2 = props.disableControls == nil or props.disableControls
	local scaleType = props.scaleType or Enum.ScaleType.Crop

	local playbackBehavior = props.playbackBehavior
	local shouldStartPlayback = props.isPlaybackEnabledByClient
	local v3

	if shouldStartPlayback == nil then
		if (playbackBehavior or v.PlayWhenReady) == v.PlayWhenReady then
			v3 = true
			shouldStartPlayback = true
		else
			v3 = false
			shouldStartPlayback = false
		end
	else
		v3 = true
	end

	local source = asString(findAnalyticsFieldInAncestors("source", props.analyticsContext)) -- inferred equivalent call
	local sourceId = asString(findAnalyticsFieldInAncestors("sourceId", props.analyticsContext)) -- inferred equivalent call
	local videoPlaybackContext = props.sduiContext.videoPlaybackContext

	local videoAnalyticsContext = React.useMemo(function()
		return {
			videoAnalyticsData = { source = source, sourceId = sourceId },
			getPlaybackSessionId = function()
				if videoPlaybackContext then
					return videoPlaybackContext.videoPlaybackCoordinator.currentPlaybackSessionId
				end

				return nil
			end
		}
	end, { source, sourceId, videoPlaybackContext })
	local defaultLoadingImageComponent

	if props.loadingImage == nil or props.loadingImage == "" then
		defaultLoadingImageComponent = props.defaultLoadingImageComponent
	end

	React.useEffect(function()
		if not assetId then
			props.sduiContext.dependencies.logger.reportError(SduiCoreSystem.SduiErrors.SduiErrorType.InvalidProps, {
				componentType = SduiCoreSystem.SduiComponentType.VideoPlayer,
				propName = "videoAssetId",
				value = props.videoAssetId or "",
				message = "Missing videoAssetId for video player"
			}, props.sduiContext.appPage)
		end

		if not v3 then
			props.sduiContext.dependencies.logger.reportError(
				SduiCoreSystem.SduiErrors.SduiErrorType.InvalidProps,
				{
					componentType = SduiCoreSystem.SduiComponentType.VideoPlayer,
					propName = "playbackBehavior",
					value = props.playbackBehavior,
					message = "Unsupported playbackBehavior for video player"
				},
				props.sduiContext.appPage
			)
		end

		if source == "" or sourceId == "" then
			props.sduiContext.dependencies.logger.reportError(
				SduiCoreSystem.SduiErrors.SduiErrorType.InvalidProps,
				{
					componentType = SduiCoreSystem.SduiComponentType.VideoPlayer,
					propName = "analyticsData",
					value = "",
					message = "Missing source or sourceId for video player analytics"
				},
				props.sduiContext.appPage
			)
		end
	end, {
		v3,
		props.playbackBehavior,
		props.sduiContext,
		props.videoAssetId,
		source,
		sourceId,
		assetId
	})

	if not assetId then
		return nil
	end

	local createElement = React.createElement
	local videoPlayer = VideoUtils.VideoPlayer
	local v4 = {
		video = assetId,
		accessContext = 0,
		trimStartTime = 0,
		trimEndTime = 0,
		musicAssetId = 0,
		musicStartTime = 0,
		thumbnail = 0,
		thumbnailComponentOverride = 0,
		shouldStartPlayback = 0,
		muted = 0,
		looped = 0,
		disableActivation = 0,
		hideCenterPlayButton = 0,
		Size = 0,
		ScaleType = 0,
		cornerRadius = 0,
		onVideoLoaded = 0,
		onVideoLooped = 0,
		videoAnalyticsContext = 0
	}
	local accessContext

	if FFlagLuaAppHomeMomentVideoFallback then
		accessContext = props.accessContext
	end

	v4.accessContext = accessContext
	local trimStartTime

	if FFlagLuaAppVideoPlayerTrimAndMusic then
		trimStartTime = props.trimStartTime
	end

	v4.trimStartTime = trimStartTime
	local trimEndTime

	if FFlagLuaAppVideoPlayerTrimAndMusic then
		trimEndTime = props.trimEndTime
	end

	v4.trimEndTime = trimEndTime
	local musicAssetId

	if FFlagLuaAppVideoPlayerTrimAndMusic then
		musicAssetId = props.musicAssetId
	end

	v4.musicAssetId = musicAssetId
	local musicStartTime

	if FFlagLuaAppVideoPlayerTrimAndMusic then
		musicStartTime = props.musicStartTime
	end

	v4.musicStartTime = musicStartTime
	v4.thumbnail = props.loadingImage
	v4.thumbnailComponentOverride = defaultLoadingImageComponent
	v4.shouldStartPlayback = shouldStartPlayback
	v4.muted = muted
	v4.looped = looped
	v4.disableActivation = v2
	v4.hideCenterPlayButton = v2
	v4.Size = UDim2.fromScale(1, 1)
	v4.ScaleType = scaleType
	v4.cornerRadius = props.cornerRadius
	v4.onVideoLoaded = props.onVideoLoaded
	v4.onVideoLooped = props.onVideoLooped
	v4.videoAnalyticsContext = videoAnalyticsContext
	return createElement(videoPlayer, v4)
end

return SduiVideoPlayer
