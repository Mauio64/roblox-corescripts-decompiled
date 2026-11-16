local parent = script:FindFirstAncestor("VideoUtils").Parent

local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppVideoPlayerTrimAndMusic = SharedFlags.FFlagLuaAppVideoPlayerTrimAndMusic

local function VideoFrameWrapper(props)
	React.useEffect(function()
		local current

		if props.videoFrameRef then
			current = props.videoFrameRef.current
		else
			current = nil
		end

		return function()
			if current then
				current.Video = ""
			end
		end
	end, { props.videoFrameRef })

	local createElement = React.createElement
	local v = {
		Size = UDim2.fromScale(1, 1),
		Video = not props.isPlaying and "" or props.video,
		Playing = not (FFlagLuaAppVideoPlayerTrimAndMusic and props.startPaused) and props.isPlaying,
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
	local corner

	if props.cornerRadius then
		corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.cornerRadius)
		})
	end

	return createElement("VideoFrame", v, { Corner = corner })
end

return VideoFrameWrapper
