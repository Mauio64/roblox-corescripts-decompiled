local ExperienceService = game:GetService("ExperienceService")
local AppLifecycleObserverService = game:GetService("AppLifecycleObserverService")

require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/AppCommonLib")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")

local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/Responsive")
local useLastInput = Responsive.useLastInput

local fFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppOneByTwoHoverIdleAutoplay

require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/VideoAnalyticsTypes")
local videoEndReason = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/Analytics/Enums").VideoEndReason
local VideoPlaybackCoordinator = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoPlaybackCoordinator")
local VideoHoverPlaybackDetector = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoHoverPlaybackDetector")
local VideoPlaybackDetectionMethod = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoPlaybackDetectionMethod")
local VideoSelectionPlaybackDetector = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoSelectionPlaybackDetector")
local VideoViewportPlaybackDetector = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoViewportPlaybackDetector")
require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/ViewportVideoAutoplayController")

local fFlagLuaAppEdpMediaGalleryVideoPreview = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreview

local fFlagLuaAppGameTileSelectionVideoPlayback = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppGameTileSelectionVideoPlayback

local fFlagLuaAppSuppressVideoDetectorDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppSuppressVideoDetectorDuringScroll

local fFlagLuaAppSduiSuppressVideoDetectorDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppSduiSuppressVideoDetectorDuringScroll

local function VideoPlaybackDetector(props)
	local videoPlaybackCoordinator = props.videoPlaybackCoordinator or VideoPlaybackCoordinator.default

	local state, setState = React.useState(false)
	local v5

	if not (fFlagLuaAppEdpMediaGalleryVideoPreview or fFlagLuaAppGameTileSelectionVideoPlayback) then
		v5 = useLastInput()
	end

	local v6 = React.useCallback(function(p2)
		if props.onPlaybackCandidate then
			props.onPlaybackCandidate()
		end

		if props.isVideoEligible then
			videoPlaybackCoordinator:requestPlayback(
				props.videoKey,
				p2,
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

	local v7 = React.useCallback(function(p2)
		videoPlaybackCoordinator:cancelPlayback(props.videoKey, p2, props.itemIndex, props.videoAnalytics)
	end, {
		props.videoKey,
		props.itemIndex,
		props.videoAnalytics,
		videoPlaybackCoordinator
	})
	local v8

	if fFlagLuaAppSuppressVideoDetectorDuringScroll or fFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
		if props.viewportVideoAutoplayController == nil then
			v8 = false
		else
			v8 = props.viewportVideoAutoplayController.suppressDetectorsDuringScroll
		end
	else
		v8 = nil
	end

	local function fn()
		local function checkAndUpdateState(p2)
			local v9 = p2 == props.videoKey

			if v9 ~= state then
				props.onPlaybackChange(v9)
				setState(v9)
			end
		end

		if
			(fFlagLuaAppSuppressVideoDetectorDuringScroll or fFlagLuaAppSduiSuppressVideoDetectorDuringScroll)
			and v8
			and videoPlaybackCoordinator.playingVideoKey ~= props.videoKey
		then
			props.onPlaybackChange(false)
		end

		local v9 = videoPlaybackCoordinator.playingVideoKey == props.videoKey

		if v9 ~= state then
			props.onPlaybackChange(v9)
			setState(v9)
		end

		local changedConnection = videoPlaybackCoordinator.changed:connect(function(p2)
			local v10 = p2 == props.videoKey

			if v10 ~= state then
				props.onPlaybackChange(v10)
				setState(v10)
			end
		end)

		return function()
			if changedConnection ~= nil then
				changedConnection:disconnect()
				changedConnection = nil
			end
		end
	end

	local v10 = if fFlagLuaAppSuppressVideoDetectorDuringScroll or fFlagLuaAppSduiSuppressVideoDetectorDuringScroll then v8 else nil
	React.useEffect(fn, {
		props.videoKey,
		props.onPlaybackChange,
		videoPlaybackCoordinator,
		state,
		v10
	})

	React.useEffect(function()
		local viewportVideoAutoplayController = props.viewportVideoAutoplayController
		local current = props.itemFrameRef.current

		local onHideConnection = AppLifecycleObserverService.OnHide:Connect(function()
			if viewportVideoAutoplayController then
				viewportVideoAutoplayController:reset(videoEndReason.AppBackgrounded)
			else
				v7(videoEndReason.AppBackgrounded)
			end
		end)

		local connection = ExperienceService:RegisterForExperienceJoin(function()
			if viewportVideoAutoplayController then
				viewportVideoAutoplayController:reset(videoEndReason.ExperienceLaunched)
			else
				v7(videoEndReason.ExperienceLaunched)
			end
		end)

		return function()
			if viewportVideoAutoplayController and current then
				if not ((fFlagLuaAppSuppressVideoDetectorDuringScroll or fFlagLuaAppSduiSuppressVideoDetectorDuringScroll) and viewportVideoAutoplayController.suppressDetectorsDuringScroll and viewportVideoAutoplayController.isScrolling) then
					viewportVideoAutoplayController:resetIfActiveInstance(current, videoEndReason.Unmounted)
				end
			else
				v7(videoEndReason.Unmounted)
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
	end, { v7, props.viewportVideoAutoplayController, props.itemFrameRef })

	if fFlagLuaAppOneByTwoHoverIdleAutoplay then
		if props.playbackDetectionMethod == VideoPlaybackDetectionMethod.Hover then
			if
				props.viewportVideoAutoplayController == nil
				or not props.viewportVideoAutoplayController:isUserIntentWithSelectiveAutoplay()
			then
				return React.createElement(VideoHoverPlaybackDetector, {
					videoPlaybackCoordinator = videoPlaybackCoordinator,
					requestVideoPlayback = v6,
					cancelVideoPlayback = v7,
					isHovered = props.isHovered
				})
			end

			return React.createElement(VideoViewportPlaybackDetector, {
				videoKey = props.videoKey,
				videoPlaybackCoordinator = videoPlaybackCoordinator,
				requestVideoPlayback = v6,
				cancelVideoPlayback = v7,
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
				requestVideoPlayback = v6,
				cancelVideoPlayback = v7,
				itemFrameRef = props.itemFrameRef,
				isItemOccluded = props.isItemOccluded,
				videoVisiblePercent = props.videoVisiblePercent,
				viewportVideoAutoplayController = props.viewportVideoAutoplayController
			})
		end

		if props.playbackDetectionMethod == VideoPlaybackDetectionMethod.Selection then
			return React.createElement(VideoSelectionPlaybackDetector, {
				requestVideoPlayback = v6,
				cancelVideoPlayback = v7,
				isSelected = props.isSelected
			})
		end

		if fFlagLuaAppEdpMediaGalleryVideoPreview and props.autoplay or v5 == Responsive.Input.Touch then
			return React.createElement(VideoViewportPlaybackDetector, {
				videoPlaybackCoordinator = videoPlaybackCoordinator,
				requestVideoPlayback = v6,
				cancelVideoPlayback = v7,
				itemFrameRef = props.itemFrameRef,
				isItemOccluded = props.isItemOccluded,
				videoVisiblePercent = props.videoVisiblePercent,
				viewportVideoAutoplayController = props.viewportVideoAutoplayController
			})
		end

		return nil
	end

	if fFlagLuaAppGameTileSelectionVideoPlayback then
		if props.playbackDetectionMethod == VideoPlaybackDetectionMethod.Hover then
			return React.createElement(VideoHoverPlaybackDetector, {
				videoPlaybackCoordinator = videoPlaybackCoordinator,
				requestVideoPlayback = v6,
				cancelVideoPlayback = v7,
				isHovered = props.isHovered
			})
		end

		if props.playbackDetectionMethod == VideoPlaybackDetectionMethod.Viewport then
			return React.createElement(VideoViewportPlaybackDetector, {
				videoPlaybackCoordinator = videoPlaybackCoordinator,
				requestVideoPlayback = v6,
				cancelVideoPlayback = v7,
				itemFrameRef = props.itemFrameRef,
				isItemOccluded = props.isItemOccluded,
				videoVisiblePercent = props.videoVisiblePercent,
				viewportVideoAutoplayController = props.viewportVideoAutoplayController
			})
		end

		if props.playbackDetectionMethod == VideoPlaybackDetectionMethod.Selection then
			return React.createElement(VideoSelectionPlaybackDetector, {
				requestVideoPlayback = v6,
				cancelVideoPlayback = v7,
				isSelected = props.isSelected
			})
		end
	else
		if props.isHoverSupported then
			return React.createElement(VideoHoverPlaybackDetector, {
				videoPlaybackCoordinator = videoPlaybackCoordinator,
				requestVideoPlayback = v6,
				cancelVideoPlayback = v7,
				isHovered = props.isHovered
			})
		end

		if fFlagLuaAppEdpMediaGalleryVideoPreview and props.autoplay or v5 == Responsive.Input.Touch then
			return React.createElement(VideoViewportPlaybackDetector, {
				videoPlaybackCoordinator = videoPlaybackCoordinator,
				requestVideoPlayback = v6,
				cancelVideoPlayback = v7,
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
