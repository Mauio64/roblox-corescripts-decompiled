local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Cryo = require(MomentsCommonParent.Cryo)
local React = require(MomentsCommonParent.React)
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

local t1 = {
	autoplay = false,
	looping = false,
	content = nil,
	captureType = nil,
	edits = {
		music = nil,
		trim = nil
	}
}

local function useUnifiedPlayback(b1: boolean, t2: {[any]: any}) -- line: 40
	-- upvalues: Cryo (copy), t1 (copy), useToggleState (copy), useRef (copy), Signal (copy), useMemo (copy), Constants (copy), useAudioPlayback (copy), useVideoPlayback (copy), useImageDisplay (copy), useCallback (copy), useEffect (copy)
	local v19 = Cryo.Dictionary.union(t1, t2)
	local v20 = useToggleState(false)
	local v21 = useToggleState(false)
	local v22 = useRef(Signal.new())
	local v23 = useMemo(function() -- line: 49
		-- upvalues: v19 (copy)
		if v19.edits.music then
			return v19.edits.music.assetId
		end

		return nil
	end, { v19.edits })
	local v24 = useMemo(function() -- line: 57
		-- upvalues: v19 (copy), Constants (copy)
		if v19.captureType == Enum.CaptureType.Screenshot then
			return NumberRange.new(0, Constants.ScreenshotMusicDuration)
		end

		if v19.edits.trim then
			return NumberRange.new(v19.edits.trim.startTime, v19.edits.trim.endTime)
		end

		return NumberRange.new(0, 1e999)
	end, {
		v19.edits,
		v19.captureType
	})
	local v25 = useMemo(function() -- line: 69
		-- upvalues: v19 (copy), v24 (copy)
		if v19.edits.music then
			return NumberRange.new(v19.edits.music.startTime, v19.edits.music.startTime + (v24.Max - v24.Min))
		end

		return NumberRange.new(0, 1e999)
	end, {
		v19.edits,
		v24
	})
	local v26 = useAudioPlayback(b1, v23, {
		playbackRegion = v25,
		looping = t2.looping
	})
	local v27 = useVideoPlayback(b1, if v19.captureType ~= Enum.CaptureType.Screenshot then v19.content else nil, {
		playbackRegion = v24,
		looping = t2.looping
	})
	local v28 = useImageDisplay(b1, if v19.captureType ~= Enum.CaptureType.Screenshot then nil else v19.content)
	local v29 = useCallback(function(n1: number) -- line: 94
		-- upvalues: v27 (copy), v26 (copy)
		if not v27.ref.current or not v27.ref.current.IsLoaded then
			return
		end

		v27.timeline.seek(n1)
		v26.timeline.seek(n1)
	end, {
		v27.timeline.seek,
		v26.timeline.seek
	})

	useEffect(function() -- line: 103
		-- upvalues: v27 (copy), v28 (copy), b1 (copy), v20 (copy)
		if (not v27.ref.current or not v27.ref.current.IsLoaded) and (not v28.ref.current or not v28.isLoadedRef.current) then
			return
		end

		if b1 then
			v20.enable()

			return
		end

		v20.disable()
	end, { b1 })
	useEffect(function() -- line: 118
		-- upvalues: v27 (copy), v28 (copy), v20 (copy), v26 (copy)
		if (not v27.ref.current or not v27.ref.current.IsLoaded) and (not v28.ref.current or not v28.isLoadedRef.current) then
			return
		end

		if v20.enabled then
			v27.playback.play()
			v26.playback.play()

			return
		end

		v27.playback.pause()
		v26.playback.pause()
	end, { v20.enabled })
	useEffect(function() -- line: 135
		-- upvalues: v21 (copy), v26 (copy), v23 (copy), v27 (copy)
		if v21.enabled then
			v26.volume.mute()
		else
			v26.volume.unmute()
		end

		if v23 or v21.enabled then
			v27.volume.mute()

			return
		end

		v27.volume.unmute()
	end, {
		v21.enabled,
		v23
	})

	local v30 = useCallback(function(p1) -- line: 149
		-- upvalues: b1 (copy), v19 (copy), v20 (copy), v22 (copy)
		if b1 and v19.autoplay then
			v20.enable()
		end

		v22.current:fire(p1)
	end, {
		b1,
		v19.autoplay
	})
	local v31 = useCallback(function() -- line: 156
		-- upvalues: v30 (copy)
		v30(Enum.AssetType.Image)
	end, { v30 })
	local v32 = useCallback(function() -- line: 160
		-- upvalues: v30 (copy)
		v30(Enum.AssetType.Video)
	end, { v30 })
	local v33 = useCallback(function() -- line: 164
		-- upvalues: v26 (copy)
		v26.timeline.seek(0)
	end, { v26.timeline.seek })

	useEffect(function() -- line: 168
		-- upvalues: v27 (copy), v33 (copy), v32 (copy), v28 (copy), v31 (copy)
		local t3 = {}

		if v27.onVideoDidLoopSignalRef.current then
			table.insert(t3, v27.onVideoDidLoopSignalRef.current:connect(v33))
		end

		if v27.onVideoLoadedSignalRef.current then
			table.insert(t3, v27.onVideoLoadedSignalRef.current:connect(v32))
		end

		if v28.onImageLoadedSignalRef.current then
			table.insert(t3, v28.onImageLoadedSignalRef.current:connect(v31))
		end

		return function() -- line: 183
			-- upvalues: t3 (copy)
			for _, v38 in t3 do
				v38.disconnect()
			end
		end
	end, {
		v32,
		v33,
		v31
	})

	return {
		timeline = if v19.captureType ~= Enum.CaptureType.Video then {
			duration = Constants.ScreenshotMusicDuration,
			elapsed = v26.timeline.elapsed,
			seek = v29,
			timeLength = Constants.ScreenshotMusicDuration,
			timePosition = v26.timeline.timePosition
		} else {
			duration = v27.timeline.duration,
			elapsed = v27.timeline.elapsed,
			seek = v29,
			timeLength = v27.timeline.timeLength,
			timePosition = v27.timeline.timePosition
		},
		playback = {
			isPlaying = v20.enabled,
			pause = v20.disable,
			play = v20.enable,
			toggle = v20.toggle
		},
		volume = {
			isMuted = v21.enabled,
			mute = v21.enable,
			unmute = v21.disable,
			toggle = v21.toggle
		},
		audio = {
			timeLength = v26.timeline.timeLength,
			timePosition = v26.timeline.timePosition
		},
		onContentLoadedSignalRef = v22,
		imageRef = v28.updateRef,
		videoRef = v27.updateRef,
		audioRef = v26.ref
	}
end

return useUnifiedPlayback
