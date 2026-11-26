local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local videoPlayer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/VideoUtils").VideoPlayer

local function JoinCardBannerVideoView(props)
	return React.createElement("Frame", {
		[React.Tag] = "data-testid=JoinCardBannerVideoView",
		Size = props.Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Visible = props.isVisible,
		ZIndex = props.ZIndex
	}, {
		VideoPlayer = React.createElement(videoPlayer, {
			video = props.video,
			shouldStartPlayback = props.shouldStartPlayback,
			muted = true,
			looped = true,
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Crop,
			cornerRadius = props.cornerRadius,
			hideCenterPlayButton = true,
			disableActivation = props.onActivated == nil,
			onVideoPlayerActivated = props.onActivated,
			videoAnalyticsContext = props.videoAnalyticsContext,
			onVideoLoaded = props.onVideoLoaded
		})
	})
end

return JoinCardBannerVideoView
