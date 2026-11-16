local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local LibraryAudioPlayerContentView = require(script.Parent.LibraryAudioPlayerContentView)

local function LibraryAudioPlayerView(props)
	local v = Foundation.Hooks.useScaledValue(168)

	if props.status == "Failed" then
		return React.createElement(Foundation.Text, {
			Text = props.unavailableText,
			tag = "auto-xy text-body-medium content-default"
		})
	end

	if props.status == "Ready" then
		return React.createElement(LibraryAudioPlayerContentView, {
			isCompact = props.isCompact,
			title = props.title,
			artist = props.artist,
			isPlaying = props.isPlaying,
			elapsed = props.elapsed,
			duration = props.duration,
			onTogglePlayback = props.onTogglePlayback,
			onSeek = props.onSeek,
			onSeekStarted = props.onSeekStarted,
			onSeekEnded = props.onSeekEnded
		})
	end

	return React.createElement(Foundation.Skeleton, {
		Size = UDim2.fromOffset(v, v),
		radius = Foundation.Enums.Radius.Medium,
		testId = "Library.Preview.SoundLoading"
	})
end

return LibraryAudioPlayerView
