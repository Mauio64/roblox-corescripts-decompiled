local Parent = script:FindFirstAncestor("VideoUtils").Parent
local React = require(Parent.React)

local function VideoFrameWrapper(t1: {[any]: any}) -- line: 20
	-- upvalues: React (copy)
	React.useEffect(function() -- line: 21
		-- upvalues: t1 (copy)
		local v5 = if not t1.videoFrameRef then nil else t1.videoFrameRef.current

		return function() -- line: 24
			-- upvalues: v5 (copy)
			if v5 then
				v5.Video = ""
			end
		end
	end, { t1.videoFrameRef })

	return React.createElement("VideoFrame", {
		Size = UDim2.fromScale(1, 1),
		Video = not t1.isPlaying and "" or t1.video,
		Playing = t1.isPlaying,
		Looped = t1.looped,
		Volume = t1.volume,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = t1.zIndex or 1,
		ref = t1.videoFrameRef,
		[React.Event.Loaded] = t1.onLoaded,
		[React.Event.DidLoop] = t1.onLooped,
		[React.Event.Ended] = t1.onEnded
	}, {
		Corner = if not t1.cornerRadius then nil else React.createElement("UICorner", {
			CornerRadius = UDim.new(0, t1.cornerRadius)
		})
	})
end

return VideoFrameWrapper
