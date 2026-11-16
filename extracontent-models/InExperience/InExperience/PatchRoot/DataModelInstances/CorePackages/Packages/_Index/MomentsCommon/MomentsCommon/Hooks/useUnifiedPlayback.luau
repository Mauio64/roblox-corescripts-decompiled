local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)

local useAudioPlayback = require(MomentsCommon.Hooks.useAudioPlayback)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useImageDisplay = require(MomentsCommon.Hooks.useImageDisplay)
local useMemo = React.useMemo
local useRef = React.useRef
local useToggleState = require(MomentsCommon.Hooks.useToggleState)
local useVideoPlayback = require(MomentsCommon.Hooks.useVideoPlayback)

local Signal = require(MomentsCommon.Utils.Signal)

local Constants = require(MomentsCommon.Constants)
require(MomentsCommon.Types)

local v = {
	autoplay = false,
	edits = { music = nil, trim = nil },
	looping = false,
	content = nil,
	captureType = nil
}

local function useUnifiedPlayback(flag: boolean, p)
	local union = Cryo.Dictionary.union(v, p)
	local v2 = useToggleState(false)
	local v3 = useToggleState(false)
	local onContentLoadedSignalRef = useRef(Signal.new())

	local v4 = useMemo(function()
		if union.edits.music then
			return union.edits.music.assetId
		end

		return nil
	end, { union.edits })

	local playbackRegion = useMemo(function()
		if union.captureType == Enum.CaptureType.Screenshot then
			return NumberRange.new(0, Constants.ScreenshotMusicDuration)
		end

		if union.edits.trim then
			return NumberRange.new(union.edits.trim.startTime, union.edits.trim.endTime)
		end

		return NumberRange.new(0, 1e999)
	end, { union.edits, union.captureType })

	local v5 = useAudioPlayback(flag, v4, {
		playbackRegion = useMemo(function()
			if union.edits.music then
				return NumberRange.new(
					union.edits.music.startTime,
					union.edits.music.startTime + (playbackRegion.Max - playbackRegion.Min)
				)
			end

			return NumberRange.new(0, 1e999)
		end, { union.edits, playbackRegion }),
		looping = p.looping
	})
	local v6

	if union.captureType ~= Enum.CaptureType.Screenshot then
		v6 = union.content
	end

	local v7 = useVideoPlayback(flag, v6, { playbackRegion = playbackRegion, looping = p.looping })
	local v8

	if union.captureType == Enum.CaptureType.Screenshot then
		v8 = union.content
	end

	local v9 = useImageDisplay(flag, v8)

	local seek = useCallback(function(p2: number)
		if v7.ref.current and v7.ref.current.IsLoaded then
			v7.timeline.seek(p2)
			v5.timeline.seek(p2)
		end
	end, { v7.timeline.seek, v5.timeline.seek })

	useEffect(function()
		if not (v7.ref.current and v7.ref.current.IsLoaded or v9.ref.current and v9.isLoadedRef.current) then
			return
		end

		if flag then
			v2.enable()
		else
			v2.disable()
		end
	end, { flag })

	useEffect(function()
		if not (v7.ref.current and v7.ref.current.IsLoaded or v9.ref.current and v9.isLoadedRef.current) then
			return
		end

		if v2.enabled then
			v7.playback.play()
			v5.playback.play()
		else
			v7.playback.pause()
			v5.playback.pause()
		end
	end, { v2.enabled })

	useEffect(function()
		if v3.enabled then
			v5.volume.mute()
		else
			v5.volume.unmute()
		end

		if v4 or v3.enabled then
			v7.volume.mute()
		else
			v7.volume.unmute()
		end
	end, { v3.enabled, v4 })

	local v10 = useCallback(function(p2)
		if flag and union.autoplay then
			v2.enable()
		end

		onContentLoadedSignalRef.current:fire(p2)
	end, { flag, union.autoplay })

	local v11 = useCallback(function()
		v10(Enum.AssetType.Image)
	end, { v10 })

	local v12 = useCallback(function()
		v10(Enum.AssetType.Video)
	end, { v10 })

	local v13 = useCallback(function()
		v5.timeline.seek(0)
	end, { v5.timeline.seek })

	useEffect(function()
		local connections = {}

		if v7.onVideoDidLoopSignalRef.current then
			table.insert(connections, v7.onVideoDidLoopSignalRef.current:connect(v13))
		end

		if v7.onVideoLoadedSignalRef.current then
			table.insert(connections, v7.onVideoLoadedSignalRef.current:connect(v12))
		end

		if v9.onImageLoadedSignalRef.current then
			table.insert(connections, v9.onImageLoadedSignalRef.current:connect(v11))
		end

		return function()
			for _, connection in connections do
				connection.disconnect()
			end
		end
	end, { v12, v13, v11 })
	local timeline

	if union.captureType == Enum.CaptureType.Video then
		timeline = {
			duration = v7.timeline.duration,
			elapsed = v7.timeline.elapsed,
			seek = seek,
			timeLength = v7.timeline.timeLength,
			timePosition = v7.timeline.timePosition
		}
	else
		timeline = {
			duration = Constants.ScreenshotMusicDuration,
			elapsed = v5.timeline.elapsed,
			seek = seek,
			timeLength = Constants.ScreenshotMusicDuration,
			timePosition = v5.timeline.timePosition
		}
	end

	return {
		timeline = timeline,
		playback = {
			isPlaying = v2.enabled,
			pause = v2.disable,
			play = v2.enable,
			toggle = v2.toggle
		},
		volume = { isMuted = v3.enabled, mute = v3.enable, unmute = v3.disable, toggle = v3.toggle },
		audio = { timeLength = v5.timeline.timeLength, timePosition = v5.timeline.timePosition },
		onContentLoadedSignalRef = onContentLoadedSignalRef,
		imageRef = v9.updateRef,
		videoRef = v7.updateRef,
		audioRef = v5.ref
	}
end

return useUnifiedPlayback
