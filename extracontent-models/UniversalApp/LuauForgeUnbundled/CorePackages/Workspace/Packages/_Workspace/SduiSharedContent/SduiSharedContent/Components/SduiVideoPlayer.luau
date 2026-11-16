local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/VideoUtils")

local fFlagLuaAppHomeMomentVideoFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagLuaAppHomeMomentVideoFallback
local fFlagLuaAppVideoPlayerTrimAndMusic = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagLuaAppVideoPlayerTrimAndMusic

local v5 = { PlayWhenReady = "PlayWhenReady" }

local function resolvePlaybackState(value, p2)
	if p2 ~= nil then
		return p2, true
	end

	if (value or "PlayWhenReady") == "PlayWhenReady" then
		return true, true
	end

	return false, false
end

local function asString(p2)
	if p2 == nil then
		return ""
	end

	return (tostring(p2))
end

local function normalizeAssetId(value)
	if value == nil or value == "" then
		return nil
	end

	if string.find(value, "://", 1, true) then
		return value
	end

	return `rbxassetid://{value}`
end

local function SduiVideoPlayer(props)
	local videoAssetId = props.videoAssetId

	if videoAssetId == nil or videoAssetId == "" then
		videoAssetId = nil
	elseif not string.find(videoAssetId, "://", 1, true) then
		videoAssetId = `rbxassetid://{videoAssetId}`
	end

	local v6 = not (props.loop == nil) and props.loop
	local v7 = props.muted == nil or props.muted
	local v8 = props.disableControls == nil or props.disableControls
	local scaleType = props.scaleType or Enum.ScaleType.Crop

	local playbackBehavior = props.playbackBehavior
	local v9 = props.isPlaybackEnabledByClient
	local v10

	if v9 == nil then
		if (playbackBehavior or v5.PlayWhenReady) == v5.PlayWhenReady then
			v10 = true
			v9 = true
		else
			v10 = false
			v9 = false
		end
	else
		v10 = true
	end

	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("source", props.analyticsContext)
	local v11 = analyticsFieldInAncestors == nil and "" or tostring(analyticsFieldInAncestors)

	local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors("sourceId", props.analyticsContext)
	local v12 = analyticsFieldInAncestors2 == nil and "" or tostring(analyticsFieldInAncestors2)

	local videoPlaybackContext = props.sduiContext.videoPlaybackContext

	local v13 = React.useMemo(function()
		return {
			videoAnalyticsData = { source = v11, sourceId = v12 },
			getPlaybackSessionId = function()
				if videoPlaybackContext then
					return videoPlaybackContext.videoPlaybackCoordinator.currentPlaybackSessionId
				end

				return nil
			end
		}
	end, { v11, v12, videoPlaybackContext })
	local defaultLoadingImageComponent

	if props.loadingImage == nil or props.loadingImage == "" then
		defaultLoadingImageComponent = props.defaultLoadingImageComponent
	end

	React.useEffect(function()
		if not videoAssetId then
			props.sduiContext.dependencies.logger.reportError(
				SduiCoreSystem.SduiErrors.SduiErrorType.InvalidProps,
				{
					componentType = SduiCoreSystem.SduiComponentType.VideoPlayer,
					propName = "videoAssetId",
					value = props.videoAssetId or "",
					message = "Missing videoAssetId for video player"
				},
				props.sduiContext.appPage
			)
		end

		if not v10 then
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

		if v11 == "" or v12 == "" then
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
		v10,
		props.playbackBehavior,
		props.sduiContext,
		props.videoAssetId,
		v11,
		v12,
		videoAssetId
	})

	if not videoAssetId then
		return nil
	end

	local createElement = React.createElement
	local videoPlayer = VideoUtils.VideoPlayer
	local v14 = {
		video = videoAssetId,
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

	local v15 = if fFlagLuaAppHomeMomentVideoFallback then props.accessContext else nil
	v14.accessContext = v15
	local v16 = if fFlagLuaAppVideoPlayerTrimAndMusic then props.trimStartTime else nil
	v14.trimStartTime = v16
	local v17 = if fFlagLuaAppVideoPlayerTrimAndMusic then props.trimEndTime else nil
	v14.trimEndTime = v17
	local v18 = if fFlagLuaAppVideoPlayerTrimAndMusic then props.musicAssetId else nil
	v14.musicAssetId = v18
	local v19 = if fFlagLuaAppVideoPlayerTrimAndMusic then props.musicStartTime else nil
	v14.musicStartTime = v19
	v14.thumbnail = props.loadingImage
	v14.thumbnailComponentOverride = defaultLoadingImageComponent
	v14.shouldStartPlayback = v9
	v14.muted = v7
	v14.looped = v6
	v14.disableActivation = v8
	v14.hideCenterPlayButton = v8
	v14.Size = UDim2.fromScale(1, 1)
	v14.ScaleType = scaleType
	v14.cornerRadius = props.cornerRadius
	v14.onVideoLoaded = props.onVideoLoaded
	v14.onVideoLooped = props.onVideoLooped
	v14.videoAnalyticsContext = v13
	return createElement(videoPlayer, v14)
end

return SduiVideoPlayer
