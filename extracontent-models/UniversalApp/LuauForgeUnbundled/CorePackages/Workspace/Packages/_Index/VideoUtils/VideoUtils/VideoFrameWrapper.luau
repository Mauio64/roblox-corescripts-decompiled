local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")

local fFlagLuaAppVideoPlayerTrimAndMusic = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/SharedFlags").FFlagLuaAppVideoPlayerTrimAndMusic

local function VideoFrameWrapper(props)
	React.useEffect(function()
		local current = if props.videoFrameRef then props.videoFrameRef.current else nil

		return function()
			if current then
				current.Video = ""
			end
		end
	end, { props.videoFrameRef })

	local createElement = React.createElement
	local v6 = {
		Size = UDim2.fromScale(1, 1),
		Video = not props.isPlaying and "" or props.video,
		Playing = not (fFlagLuaAppVideoPlayerTrimAndMusic and props.startPaused) and props.isPlaying,
		Looped = props.looped,
		Volume = props.volume,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = props.zIndex or 1,
		ref = props.videoFrameRef,
		[React.Event.Loaded] = props.onLoaded,
		[React.Event.DidLoop] = props.onLooped,
		[React.Event.Ended] = props.onEnded
	}

	local v9 = if props.cornerRadius then React.createElement("UICorner", {
		CornerRadius = UDim.new(0, props.cornerRadius)
	}) else nil
	return createElement("VideoFrame", v6, { Corner = v9 })
end

return VideoFrameWrapper
