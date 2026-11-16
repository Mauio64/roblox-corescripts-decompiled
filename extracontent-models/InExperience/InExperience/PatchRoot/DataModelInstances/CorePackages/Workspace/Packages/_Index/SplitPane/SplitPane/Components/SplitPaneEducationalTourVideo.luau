local parent = script:FindFirstAncestor("SplitPane").Parent

local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local AppAppLifecycleObserverService = RoactServiceTags.AppAppLifecycleObserverService
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local VideoUtils = require(parent.VideoUtils)

local VideoPlayer = VideoUtils.VideoPlayer
local VideoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local VideoPlaybackDetectionMethod = VideoUtils.VideoPlaybackDetectionMethod
local VideoPlaybackDetector = VideoUtils.VideoPlaybackDetector

local function SplitPaneEducationalTourVideo(props)
	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local v = useRoactService(AppAppLifecycleObserverService)
	local state2, setState2 = React.useState(true)

	React.useEffect(function()
		if v == nil then
			return
		end

		local onHideConnection = v.OnHide:Connect(function()
			setState2(false)
		end)
		local onUnhideConnection = v.OnUnhide:Connect(function()
			setState2(true)
		end)
		return function()
			onHideConnection:Disconnect()
			onUnhideConnection:Disconnect()
		end
	end, { v })

	local ref2 = React.useCallback(function(current)
		ref.current = current
	end, {})

	local v2 = props.mediaWidth + 2

	local v3 = math.ceil(v2 / props.videoAspectRatio)
	local v4 = v3 - 1 - props.topRadius

	return React.createElement("Frame", {
		Name = "TourVideoPlayer",
		Size = UDim2.fromOffset(props.mediaWidth, v4),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ref = ref2
	}, {
		Viewport = React.createElement(
			"Frame",
			{
				Position = UDim2.fromOffset(-1, -1),
				Size = UDim2.fromOffset(v2, v3),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			{
				Player = React.createElement(VideoPlayer, {
					video = props.videoAssetId,
					shouldStartPlayback = state,
					muted = true,
					looped = true,
					Size = UDim2.fromScale(1, 1),
					ScaleType = Enum.ScaleType.Crop,
					cornerRadius = props.topRadius + 1,
					disableActivation = true,
					hideCenterPlayButton = true
				})
			}
		),
		PlaybackDetector = React.createElement(VideoPlaybackDetector, {
			videoKey = "SplitPaneEducationalTour",
			itemFrameRef = ref,
			playbackDetectionMethod = VideoPlaybackDetectionMethod.Selection,
			isHoverSupported = true,
			isHovered = state2,
			isSelected = state2,
			videoPlaybackCoordinator = VideoPlaybackCoordinator.default,
			onPlaybackChange = setState,
			videoDwellTimeInSec = 0,
			videoVisiblePercent = 0,
			isVideoEligible = true
		})
	})
end

return SplitPaneEducationalTourVideo
