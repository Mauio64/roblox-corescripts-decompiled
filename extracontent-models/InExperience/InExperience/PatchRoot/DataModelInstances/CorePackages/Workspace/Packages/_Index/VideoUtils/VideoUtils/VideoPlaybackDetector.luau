local ExperienceService = game:GetService("ExperienceService")
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")
local VideoUtils = script:FindFirstAncestor("VideoUtils")

local parent = VideoUtils.Parent
require(parent.AppCommonLib)
local React = require(parent.React)

local Responsive = require(parent.Responsive)
local useLastInput = Responsive.useLastInput

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay

require(VideoUtils.Analytics.VideoAnalyticsTypes)
local Enums = require(VideoUtils.Analytics.Enums)
local VideoEndReason = Enums.VideoEndReason
local VideoPlaybackCoordinator = require(VideoUtils.VideoPlaybackCoordinator)
local VideoHoverPlaybackDetector = require(VideoUtils.VideoHoverPlaybackDetector)
local VideoPlaybackDetectionMethod = require(VideoUtils.VideoPlaybackDetectionMethod)
local VideoSelectionPlaybackDetector = require(VideoUtils.VideoSelectionPlaybackDetector)
local VideoViewportPlaybackDetector = require(VideoUtils.VideoViewportPlaybackDetector)
require(VideoUtils.ViewportVideoAutoplayController)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppEdpMediaGalleryVideoPreview = SharedFlags2.FFlagLuaAppEdpMediaGalleryVideoPreview

local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppGameTileSelectionVideoPlayback = SharedFlags3.FFlagLuaAppGameTileSelectionVideoPlayback

local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppSuppressVideoDetectorDuringScroll = SharedFlags4.FFlagLuaAppSuppressVideoDetectorDuringScroll

local SharedFlags5 = require(parent.SharedFlags)
local FFlagLuaAppSduiSuppressVideoDetectorDuringScroll = SharedFlags5.FFlagLuaAppSduiSuppressVideoDetectorDuringScroll

local function VideoPlaybackDetector(props)
	local videoPlaybackCoordinator = props.videoPlaybackCoordinator or VideoPlaybackCoordinator.default

	local state, setState = React.useState(false)
	local v

	if not (FFlagLuaAppEdpMediaGalleryVideoPreview or FFlagLuaAppGameTileSelectionVideoPlayback) then
		v = useLastInput()
	end

	local requestVideoPlayback = React.useCallback(function(flag: boolean)
		if props.onPlaybackCandidate then
			props.onPlaybackCandidate()
		end

		if props.isVideoEligible then
			videoPlaybackCoordinator:requestPlayback(
				props.videoKey,
				flag,
				props.videoDwellTimeInSec,
				props.itemIndex,
				props.videoAnalytics
			)
		elseif props.onVideoIneligible then
			props.onVideoIneligible(videoPlaybackCoordinator.currentPlaybackSessionId)
		end
	end, {
		props.videoKey,
		props.itemIndex,
		props.videoAnalytics,
		props.isVideoEligible,
		props.onVideoIneligible,
		props.onPlaybackCandidate,
		props.videoDwellTimeInSec,
		videoPlaybackCoordinator
	})

	local cancelVideoPlayback = React.useCallback(function(p: string)
		videoPlaybackCoordinator:cancelPlayback(props.videoKey, p, props.itemIndex, props.videoAnalytics)
	end, { props.videoKey, props.itemIndex, props.videoAnalytics, videoPlaybackCoordinator })
	local v2

	if FFlagLuaAppSuppressVideoDetectorDuringScroll or FFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
		if props.viewportVideoAutoplayController == nil then
			v2 = false
		else
			v2 = props.viewportVideoAutoplayController.suppressDetectorsDuringScroll
		end
	else
		v2 = nil
	end

	local useEffect = React.useEffect
	local function fn()
		local function checkAndUpdateState(p: string?) -- 2 equivalent calls inferred from this helper
			local v3 = p == props.videoKey

			if v3 ~= state then
				props.onPlaybackChange(v3)
				setState(v3)
			end
		end

		if
			(FFlagLuaAppSuppressVideoDetectorDuringScroll or FFlagLuaAppSduiSuppressVideoDetectorDuringScroll)
			and v2
			and videoPlaybackCoordinator.playingVideoKey ~= props.videoKey
		then
			props.onPlaybackChange(false)
		end

		checkAndUpdateState(videoPlaybackCoordinator.playingVideoKey) -- inferred equivalent call

		local changedConnection = videoPlaybackCoordinator.changed:connect(function(p)
			checkAndUpdateState(p) -- inferred equivalent call
		end)

		return function()
			if changedConnection ~= nil then
				changedConnection:disconnect()
				changedConnection = nil
			end
		end
	end

	local videoKey = props.videoKey
	local onPlaybackChange = props.onPlaybackChange
	local v3

	if FFlagLuaAppSuppressVideoDetectorDuringScroll or FFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
		v3 = v2
	end

	useEffect(fn, { videoKey, onPlaybackChange, videoPlaybackCoordinator, state, v3 })

	React.useEffect(function()
		local viewportVideoAutoplayController = props.viewportVideoAutoplayController
		local current = props.itemFrameRef.current

		local onHideConnection = AppLifecycleObserverService.OnHide:Connect(function()
			if viewportVideoAutoplayController then
				viewportVideoAutoplayController:reset(VideoEndReason.AppBackgrounded)
			else
				cancelVideoPlayback(VideoEndReason.AppBackgrounded)
			end
		end)

		local connection = ExperienceService:RegisterForExperienceJoin(function()
			if viewportVideoAutoplayController then
				viewportVideoAutoplayController:reset(VideoEndReason.ExperienceLaunched)
			else
				cancelVideoPlayback(VideoEndReason.ExperienceLaunched)
			end
		end)

		return function()
			if viewportVideoAutoplayController and current then
				if not ((FFlagLuaAppSuppressVideoDetectorDuringScroll or FFlagLuaAppSduiSuppressVideoDetectorDuringScroll) and viewportVideoAutoplayController.suppressDetectorsDuringScroll and viewportVideoAutoplayController.isScrolling) then
					viewportVideoAutoplayController:resetIfActiveInstance(current, VideoEndReason.Unmounted)
				end
			else
				cancelVideoPlayback(VideoEndReason.Unmounted)
			end

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if onHideConnection then
				onHideConnection:Disconnect()
				onHideConnection = nil
			end
		end
	end, { cancelVideoPlayback, props.viewportVideoAutoplayController, props.itemFrameRef })

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		if props.playbackDetectionMethod == VideoPlaybackDetectionMethod.Hover then
			if
				props.viewportVideoAutoplayController == nil
				or not props.viewportVideoAutoplayController:isUserIntentWithSelectiveAutoplay()
			then
				return React.createElement(VideoHoverPlaybackDetector, {
					videoPlaybackCoordinator = videoPlaybackCoordinator,
					requestVideoPlayback = requestVideoPlayback,
					cancelVideoPlayback = cancelVideoPlayback,
					isHovered = props.isHovered
				})
			end

			return React.createElement(VideoViewportPlaybackDetector, {
				videoKey = props.videoKey,
				videoPlaybackCoordinator = videoPlaybackCoordinator,
				requestVideoPlayback = requestVideoPlayback,
				cancelVideoPlayback = cancelVideoPlayback,
				itemFrameRef = props.itemFrameRef,
				isItemOccluded = props.isItemOccluded,
				videoVisiblePercent = props.videoVisiblePercent,
				viewportVideoAutoplayController = props.viewportVideoAutoplayController,
				hasVideoPlaybackUserIntent = props.hasVideoPlaybackUserIntent
			})
		end

		if props.playbackDetectionMethod == VideoPlaybackDetectionMethod.Viewport then
			return React.createElement(VideoViewportPlaybackDetector, {
				videoKey = props.videoKey,
				videoPlaybackCoordinator = videoPlaybackCoordinator,
				requestVideoPlayback = requestVideoPlayback,
				cancelVideoPlayback = cancelVideoPlayback,
				itemFrameRef = props.itemFrameRef,
				isItemOccluded = props.isItemOccluded,
				videoVisiblePercent = props.videoVisiblePercent,
				viewportVideoAutoplayController = props.viewportVideoAutoplayController
			})
		end

		if props.playbackDetectionMethod == VideoPlaybackDetectionMethod.Selection then
			return React.createElement(VideoSelectionPlaybackDetector, {
				requestVideoPlayback = requestVideoPlayback,
				cancelVideoPlayback = cancelVideoPlayback,
				isSelected = props.isSelected
			})
		end

		if FFlagLuaAppEdpMediaGalleryVideoPreview and props.autoplay or v == Responsive.Input.Touch then
			return React.createElement(VideoViewportPlaybackDetector, {
				videoPlaybackCoordinator = videoPlaybackCoordinator,
				requestVideoPlayback = requestVideoPlayback,
				cancelVideoPlayback = cancelVideoPlayback,
				itemFrameRef = props.itemFrameRef,
				isItemOccluded = props.isItemOccluded,
				videoVisiblePercent = props.videoVisiblePercent,
				viewportVideoAutoplayController = props.viewportVideoAutoplayController
			})
		end

		return nil
	end

	if FFlagLuaAppGameTileSelectionVideoPlayback then
		if props.playbackDetectionMethod == VideoPlaybackDetectionMethod.Hover then
			return React.createElement(VideoHoverPlaybackDetector, {
				videoPlaybackCoordinator = videoPlaybackCoordinator,
				requestVideoPlayback = requestVideoPlayback,
				cancelVideoPlayback = cancelVideoPlayback,
				isHovered = props.isHovered
			})
		end

		if props.playbackDetectionMethod == VideoPlaybackDetectionMethod.Viewport then
			return React.createElement(VideoViewportPlaybackDetector, {
				videoPlaybackCoordinator = videoPlaybackCoordinator,
				requestVideoPlayback = requestVideoPlayback,
				cancelVideoPlayback = cancelVideoPlayback,
				itemFrameRef = props.itemFrameRef,
				isItemOccluded = props.isItemOccluded,
				videoVisiblePercent = props.videoVisiblePercent,
				viewportVideoAutoplayController = props.viewportVideoAutoplayController
			})
		end

		if props.playbackDetectionMethod == VideoPlaybackDetectionMethod.Selection then
			return React.createElement(VideoSelectionPlaybackDetector, {
				requestVideoPlayback = requestVideoPlayback,
				cancelVideoPlayback = cancelVideoPlayback,
				isSelected = props.isSelected
			})
		end
	else
		if props.isHoverSupported then
			return React.createElement(VideoHoverPlaybackDetector, {
				videoPlaybackCoordinator = videoPlaybackCoordinator,
				requestVideoPlayback = requestVideoPlayback,
				cancelVideoPlayback = cancelVideoPlayback,
				isHovered = props.isHovered
			})
		end

		if FFlagLuaAppEdpMediaGalleryVideoPreview and props.autoplay or v == Responsive.Input.Touch then
			return React.createElement(VideoViewportPlaybackDetector, {
				videoPlaybackCoordinator = videoPlaybackCoordinator,
				requestVideoPlayback = requestVideoPlayback,
				cancelVideoPlayback = cancelVideoPlayback,
				itemFrameRef = props.itemFrameRef,
				isItemOccluded = props.isItemOccluded,
				videoVisiblePercent = props.videoVisiblePercent,
				viewportVideoAutoplayController = props.viewportVideoAutoplayController
			})
		end
	end

	return nil
end

return VideoPlaybackDetector
