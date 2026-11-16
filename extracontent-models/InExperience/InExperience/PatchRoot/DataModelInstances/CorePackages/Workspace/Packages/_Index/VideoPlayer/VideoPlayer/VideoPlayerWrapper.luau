local parent = script:FindFirstAncestor("VideoPlayer").Parent

local React = require(parent.React)
local ArgCheck = require(parent.ArgCheck)

local function VideoPlayerWrapper(props)
	local videoContent = React.useMemo(function()
		return Content.fromUri(props.video)
	end, { props.video })

	local v = React.useCallback(function()
		if props.onVideoLooped then
			props.onVideoLooped()
		end
	end, { props.onVideoLooped })

	local v2 = React.useCallback(function()
		if props.onVideoEnded then
			props.onVideoEnded()
		end
	end, { props.onVideoEnded })

	React.useEffect(function()
		local current = props.videoPlayerRef.current
		local current2 = props.videoDisplayRef.current
		ArgCheck.assert(
			current ~= nil and current2 ~= nil,
			"VideoPlayerWrapper expects videoPlayer and videoDisplay refs to be set before wiring"
		)

		local wire = Instance.new("Wire")
		wire.SourceInstance = current
		wire.TargetInstance = current2
		wire.Parent = current

		local videoAudioOutput = Instance.new("AudioDeviceOutput")
		videoAudioOutput.Name = "VideoAudioOutput"
		videoAudioOutput.Parent = current

		local wire2 = Instance.new("Wire")
		wire2.SourceInstance = current
		wire2.TargetInstance = videoAudioOutput
		wire2.Parent = current

		return function()
			wire2:Destroy()
			videoAudioOutput:Destroy()
			wire:Destroy()
		end
	end, { props.videoPlayerRef, props.videoDisplayRef })

	return React.createElement("VideoPlayer", {
		Name = "VideoPlayer",
		VideoContent = videoContent,
		Volume = props.muted and 0 or 1,
		Looping = props.looped or false,
		[React.Event.DidLoop] = v,
		[React.Event.DidEnd] = v2,
		ref = props.videoPlayerRef
	})
end

return VideoPlayerWrapper
