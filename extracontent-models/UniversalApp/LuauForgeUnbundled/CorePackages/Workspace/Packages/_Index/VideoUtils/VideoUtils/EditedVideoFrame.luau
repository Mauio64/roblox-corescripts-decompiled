local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VideoUtils/React")

local VideoFrameWrapper = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/VideoFrameWrapper")
local createVideoEditPlayback = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/createVideoEditPlayback")
require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/getVideoEdits")

local function EditedVideoFrame(props)
	local ref = React.useRef(nil)
	local videoFrameRef = props.videoFrameRef or ref
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	ref3.current = { onEnded = props.onEnded, onLooped = props.onLooped }
	local v5 = props.volume == 0

	React.useLayoutEffect(function()
		local current = videoFrameRef.current

		if current == nil or not props.isPlaying then
			return nil
		end

		local v6 = createVideoEditPlayback(current, props.edits, props.looped == true, function()
			return ref3.current
		end)

		ref2.current = v6
		return function()
			v6.destroy()
			ref2.current = nil
		end
	end, { videoFrameRef, props.video, props.isPlaying, props.edits, props.looped })

	React.useLayoutEffect(function()
		if ref2.current then
			ref2.current.setMuted(v5)
		end
	end, { v5, props.video, props.isPlaying, props.edits, props.looped })

	return React.createElement(VideoFrameWrapper, {
		videoFrameRef = videoFrameRef,
		video = props.video,
		isPlaying = props.isPlaying,
		startPaused = true,
		looped = props.looped == true and props.edits.trim == nil,
		volume = props.edits.music and 0 or props.volume,
		onLoaded = props.onLoaded,
		cornerRadius = props.cornerRadius,
		zIndex = props.zIndex
	})
end

return EditedVideoFrame
