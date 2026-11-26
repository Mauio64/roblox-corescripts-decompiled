local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local appAppLifecycleObserverService = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RoactServiceTags").AppAppLifecycleObserverService
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RobloxAppHooks").useRoactService
local VideoUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/VideoUtils")

local videoPlayer = VideoUtils.VideoPlayer
local videoPlaybackCoordinator = VideoUtils.VideoPlaybackCoordinator
local videoPlaybackDetectionMethod = VideoUtils.VideoPlaybackDetectionMethod
local videoPlaybackDetector = VideoUtils.VideoPlaybackDetector

local function SplitPaneEducationalTourVideo(props)
	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local v5 = useRoactService(appAppLifecycleObserverService)
	local state2, setState2 = React.useState(true)

	React.useEffect(function()
		if v5 == nil then
			return
		end

		local onHideConnection = v5.OnHide:Connect(function()
			setState2(false)
		end)
		local onUnhideConnection = v5.OnUnhide:Connect(function()
			setState2(true)
		end)
		return function()
			onHideConnection:Disconnect()
			onUnhideConnection:Disconnect()
		end
	end, { v5 })

	local v6 = React.useCallback(function(current)
		ref.current = current
	end, {})

	local v7 = props.mediaWidth + 2

	local v8 = math.ceil(v7 / props.videoAspectRatio)
	local v9 = v8 - 1 - props.topRadius

	return React.createElement("Frame", {
		Name = "TourVideoPlayer",
		Size = UDim2.fromOffset(props.mediaWidth, v9),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		ref = v6
	}, {
		Viewport = React.createElement(
			"Frame",
			{
				Position = UDim2.fromOffset(-1, -1),
				Size = UDim2.fromOffset(v7, v8),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			},
			{
				Player = React.createElement(videoPlayer, {
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
		PlaybackDetector = React.createElement(videoPlaybackDetector, {
			videoKey = "SplitPaneEducationalTour",
			itemFrameRef = ref,
			playbackDetectionMethod = videoPlaybackDetectionMethod.Selection,
			isHoverSupported = true,
			isHovered = state2,
			isSelected = state2,
			videoPlaybackCoordinator = videoPlaybackCoordinator.default,
			onPlaybackChange = setState,
			videoDwellTimeInSec = 0,
			videoVisiblePercent = 0,
			isVideoEligible = true
		})
	})
end

return SplitPaneEducationalTourVideo
