local parent = script:FindFirstAncestor("GameJoinCard").Parent
local React = require(parent.React)
local VideoUtils = require(parent.VideoUtils)
local VideoPlayer = VideoUtils.VideoPlayer

local function JoinCardBannerVideoView(props)
	return React.createElement("Frame", {
		[React.Tag] = "data-testid=JoinCardBannerVideoView",
		Size = props.Size,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Visible = props.isVisible,
		ZIndex = props.ZIndex
	}, {
		VideoPlayer = React.createElement(VideoPlayer, {
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
