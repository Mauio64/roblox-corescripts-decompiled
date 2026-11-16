local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Responsive")
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")
local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/VideoUtils")

local fFlagLuaAppOneByTwoHoverIdleAutoplay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppOneByTwoHoverIdleAutoplay

local fFlagLuaAppSduiSuppressVideoDetectorDuringScroll = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagLuaAppSduiSuppressVideoDetectorDuringScroll

local useTokens = Foundation.Hooks.useTokens

local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local getPlaybackDetectionMethod = VideoUtils.getPlaybackDetectionMethod
local videoPlaybackDetectionMethod = VideoUtils.VideoPlaybackDetectionMethod
local useTagAsViewportAutoplayCandidate = VideoUtils.useTagAsViewportAutoplayCandidate

local signal = Signals.createSignal(false)

local function SduiVideoThumbnail(props)
	local v5 = useTokens()
	local cornerRadius = props.cornerRadius or v5.Radius.Medium

	local ref = React.useRef(nil)
	local playbackCandidateRef = props.playbackCandidateRef or ref

	if not fFlagLuaAppOneByTwoHoverIdleAutoplay then
		local v7 = if props.videoPlayer then props.videoPlaybackContext else nil
		useTagAsViewportAutoplayCandidate(playbackCandidateRef, v7, props.videoPlayer ~= nil, nil)
	end

	local v6 = `SduiVideoThumbnail_{module4.useUidRefString().current}`

	if fFlagLuaAppOneByTwoHoverIdleAutoplay then
		v6 = React.useRef(v6).current
	end

	if fFlagLuaAppOneByTwoHoverIdleAutoplay then
		local v8 = if props.videoPlayer then props.videoPlaybackContext else nil
		useTagAsViewportAutoplayCandidate(
			playbackCandidateRef,
			v8,
			props.videoPlayer ~= nil,
			nil,
			nil,
			nil,
			nil,
			props.videoPlayer and {
				videoKey = v6,
				isUserIntentModeAutoplayCandidate = false
			} or nil
		)
	end

	local v7 = Responsive.usePreferredInput()
	local v8 = v7 == Responsive.Input.Pointer

	local playbackDetectionMethod = getPlaybackDetectionMethod(v7, v8)

	local state, setState = React.useState(false)
	local v9 = React.useCallback(function(p2)
		setState(p2)
	end, {})
	local videoPlaybackCoordinator

	if props.videoPlaybackContext then
		videoPlaybackCoordinator = props.videoPlaybackContext.videoPlaybackCoordinator
	else
		videoPlaybackCoordinator = nil
	end

	local v10 = React.useCallback(function(p2, p3)
		if videoPlaybackCoordinator and props.videoAnalytics then
			props.videoAnalytics.reportVideoLoad(
				nil,
				videoPlaybackCoordinator.currentPlaybackSessionId,
				p2,
				p3
			)
		end
	end, { props.videoAnalytics, videoPlaybackCoordinator })

	local v11 = React.useCallback(function()
		if videoPlaybackCoordinator and props.videoAnalytics and props.videoAnalytics.reportVideoLoop then
			props.videoAnalytics.reportVideoLoop(nil, videoPlaybackCoordinator.currentPlaybackSessionId)
		end
	end, { props.videoAnalytics, videoPlaybackCoordinator })
	local viewportVideoAutoplayController

	if props.videoPlaybackContext then
		viewportVideoAutoplayController = props.videoPlaybackContext.viewportVideoAutoplayController
	end

	local v12

	if fFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
		local v13

		if viewportVideoAutoplayController then
			v13 = viewportVideoAutoplayController.getDetectorsUnmounted
		end

		v12 = SignalsReact.useSignalState(v13 or signal)
	else
		v12 = false
	end

	local v13

	if props.videoPlayer then
		v13 = React.createElement(getSduiComponentWrapper(props.videoPlayer), {
			componentConfig = props.videoPlayer,
			sduiContext = props.sduiContext,
			extraLocalProps = {
				defaultLoadingImageComponent = props.imageComponent,
				isPlaybackEnabledByClient = state,
				cornerRadius = cornerRadius,
				onVideoLoaded = v10,
				onVideoLooped = v11
			},
			debugName = "SduiVideoThumbnail.VideoPlayer"
		})
	else
		v13 = props.imageComponent
	end

	local createElement = React.createElement

	if props.playbackCandidateRef then
		ref = nil
	end

	local v15 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ref = ref,
		Size = UDim2.fromScale(1, 1)
	}
	local v17

	if props.videoPlayer and not (fFlagLuaAppSduiSuppressVideoDetectorDuringScroll and v12) then
		local createElement2 = React.createElement
		local videoPlaybackDetector = VideoUtils.VideoPlaybackDetector
		local v18 = {
			videoKey = v6,
			itemFrameRef = playbackCandidateRef,
			playbackDetectionMethod = playbackDetectionMethod,
			isHoverSupported = v8,
			isHovered = props.isHovered,
			isSelected = props.isSelected,
			hasVideoPlaybackUserIntent = 0,
			autoplay = 0,
			videoPlaybackCoordinator = 0,
			onPlaybackChange = 0,
			videoAnalytics = 0,
			videoDwellTimeInSec = 0,
			videoVisiblePercent = 0,
			isVideoEligible = 0,
			onVideoIneligible = 0,
			onPlaybackCandidate = 0,
			viewportVideoAutoplayController = 0
		}

		local v19 = if fFlagLuaAppOneByTwoHoverIdleAutoplay and playbackDetectionMethod == videoPlaybackDetectionMethod.Hover then props.isHovered else nil
		v18.hasVideoPlaybackUserIntent = v19

		v18.autoplay = v7 == Responsive.Input.Touch
		local v20 = if props.videoPlaybackContext then props.videoPlaybackContext.videoPlaybackCoordinator else nil
		v18.videoPlaybackCoordinator = v20

		v18.onPlaybackChange = v9
		v18.videoAnalytics = props.videoAnalytics
		v18.videoDwellTimeInSec = props.videoDwellTimeInSec
		v18.videoVisiblePercent = props.videoVisiblePercent
		v18.isVideoEligible = props.isVideoEligible
		v18.onVideoIneligible = props.onVideoIneligible
		v18.onPlaybackCandidate = props.onPlaybackCandidate
		v18.viewportVideoAutoplayController = viewportVideoAutoplayController
		v17 = createElement2(videoPlaybackDetector, v18)
	end

	return createElement("Frame", v15, { MediaContent = v13, PlaybackDetector = v17 })
end

return SduiVideoThumbnail
