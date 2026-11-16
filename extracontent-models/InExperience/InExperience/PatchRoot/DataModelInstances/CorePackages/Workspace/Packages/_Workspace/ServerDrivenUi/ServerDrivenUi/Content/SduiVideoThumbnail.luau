local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local SduiCoreSystem = require(parent.SduiCoreSystem)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local VideoUtils = require(parent.VideoUtils)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppOneByTwoHoverIdleAutoplay = SharedFlags.FFlagLuaAppOneByTwoHoverIdleAutoplay

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppSduiSuppressVideoDetectorDuringScroll = SharedFlags2.FFlagLuaAppSduiSuppressVideoDetectorDuringScroll

local useTokens = Foundation.Hooks.useTokens

local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper
local getPlaybackDetectionMethod = VideoUtils.getPlaybackDetectionMethod
local VideoPlaybackDetectionMethod = VideoUtils.VideoPlaybackDetectionMethod
local useTagAsViewportAutoplayCandidate = VideoUtils.useTagAsViewportAutoplayCandidate

local signal = Signals.createSignal(false)

local function SduiVideoThumbnail(props)
	local v = useTokens()
	local cornerRadius = props.cornerRadius or v.Radius.Medium

	local ref = React.useRef(nil)
	local playbackCandidateRef = props.playbackCandidateRef or ref

	if not FFlagLuaAppOneByTwoHoverIdleAutoplay then
		local v2

		if props.videoPlayer then
			v2 = props.videoPlaybackContext
		end

		useTagAsViewportAutoplayCandidate(playbackCandidateRef, v2, props.videoPlayer ~= nil, nil)
	end

	local videoKey = `SduiVideoThumbnail_{SduiCoreSystem.useUidRefString().current}`

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		videoKey = React.useRef(videoKey).current
	end

	if FFlagLuaAppOneByTwoHoverIdleAutoplay then
		local v2

		if props.videoPlayer then
			v2 = props.videoPlaybackContext
		end

		useTagAsViewportAutoplayCandidate(
			playbackCandidateRef,
			v2,
			props.videoPlayer ~= nil,
			nil,
			nil,
			nil,
			nil,
			props.videoPlayer and { videoKey = videoKey, isUserIntentModeAutoplayCandidate = false } or nil
		)
	end

	local v2 = Responsive.usePreferredInput()
	local isHoverSupported = v2 == Responsive.Input.Pointer

	local playbackDetectionMethod = getPlaybackDetectionMethod(v2, isHoverSupported)

	local state, setState = React.useState(false)
	local onPlaybackChange = React.useCallback(function(flag: boolean)
		setState(flag)
	end, {})
	local videoPlaybackCoordinator

	if props.videoPlaybackContext then
		videoPlaybackCoordinator = props.videoPlaybackContext.videoPlaybackCoordinator
	else
		videoPlaybackCoordinator = nil
	end

	local onVideoLoaded = React.useCallback(function(p: number, p2: number)
		if videoPlaybackCoordinator and props.videoAnalytics then
			props.videoAnalytics.reportVideoLoad(nil, videoPlaybackCoordinator.currentPlaybackSessionId, p, p2)
		end
	end, { props.videoAnalytics, videoPlaybackCoordinator })

	local onVideoLooped = React.useCallback(function()
		if videoPlaybackCoordinator and props.videoAnalytics and props.videoAnalytics.reportVideoLoop then
			props.videoAnalytics.reportVideoLoop(nil, videoPlaybackCoordinator.currentPlaybackSessionId)
		end
	end, { props.videoAnalytics, videoPlaybackCoordinator })
	local viewportVideoAutoplayController

	if props.videoPlaybackContext then
		viewportVideoAutoplayController = props.videoPlaybackContext.viewportVideoAutoplayController
	end

	local v3

	if FFlagLuaAppSduiSuppressVideoDetectorDuringScroll then
		local v4

		if viewportVideoAutoplayController then
			v4 = viewportVideoAutoplayController.getDetectorsUnmounted
		end

		v3 = SignalsReact.useSignalState(v4 or signal)
	else
		v3 = false
	end

	local mediaContent

	if props.videoPlayer then
		mediaContent = React.createElement(getSduiComponentWrapper(props.videoPlayer), {
			componentConfig = props.videoPlayer,
			sduiContext = props.sduiContext,
			extraLocalProps = {
				defaultLoadingImageComponent = props.imageComponent,
				isPlaybackEnabledByClient = state,
				cornerRadius = cornerRadius,
				onVideoLoaded = onVideoLoaded,
				onVideoLooped = onVideoLooped
			},
			debugName = "SduiVideoThumbnail.VideoPlayer"
		})
	else
		mediaContent = props.imageComponent
	end

	local createElement = React.createElement

	if props.playbackCandidateRef then
		ref = nil
	end

	local v4 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ref = ref,
		Size = UDim2.fromScale(1, 1)
	}
	local playbackDetector

	if props.videoPlayer and not (FFlagLuaAppSduiSuppressVideoDetectorDuringScroll and v3) then
		local createElement2 = React.createElement
		local videoPlaybackDetector = VideoUtils.VideoPlaybackDetector
		local v5 = {
			videoKey = videoKey,
			itemFrameRef = playbackCandidateRef,
			playbackDetectionMethod = playbackDetectionMethod,
			isHoverSupported = isHoverSupported,
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
		local hasVideoPlaybackUserIntent

		if FFlagLuaAppOneByTwoHoverIdleAutoplay and playbackDetectionMethod == VideoPlaybackDetectionMethod.Hover then
			hasVideoPlaybackUserIntent = props.isHovered
		end

		v5.hasVideoPlaybackUserIntent = hasVideoPlaybackUserIntent

		v5.autoplay = v2 == Responsive.Input.Touch
		local videoPlaybackCoordinator2

		if props.videoPlaybackContext then
			videoPlaybackCoordinator2 = props.videoPlaybackContext.videoPlaybackCoordinator
		end

		v5.videoPlaybackCoordinator = videoPlaybackCoordinator2

		v5.onPlaybackChange = onPlaybackChange
		v5.videoAnalytics = props.videoAnalytics
		v5.videoDwellTimeInSec = props.videoDwellTimeInSec
		v5.videoVisiblePercent = props.videoVisiblePercent
		v5.isVideoEligible = props.isVideoEligible
		v5.onVideoIneligible = props.onVideoIneligible
		v5.onPlaybackCandidate = props.onPlaybackCandidate
		v5.viewportVideoAutoplayController = viewportVideoAutoplayController
		playbackDetector = createElement2(videoPlaybackDetector, v5)
	end

	return createElement("Frame", v4, {
		MediaContent = mediaContent,
		PlaybackDetector = playbackDetector
	})
end

return SduiVideoThumbnail
