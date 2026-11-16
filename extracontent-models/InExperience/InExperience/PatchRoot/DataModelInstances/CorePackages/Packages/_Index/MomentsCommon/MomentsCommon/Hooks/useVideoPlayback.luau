local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)

local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState
local useToggleState = require(MomentsCommon.Hooks.useToggleState)

local Signal = require(MomentsCommon.Utils.Signal)

require(MomentsCommon.Types)

local v = { autoplay = false, looping = false, playbackRegion = NumberRange.new(0, 1e999) }

local function useVideoPlayback(flag: boolean, videoContent, options)
	local union = Cryo.Dictionary.union(v, options or {})

	local ref = useRef(nil)

	local v2 = useToggleState(false)
	local v3 = useToggleState(union.autoplay)
	local v4 = useToggleState(false)

	local state, setState = useState(0)
	local state2, setState2 = useState(0)

	local state3, setState3 = useState(0)
	local state4, setState4 = useState(0)

	local onVideoDidLoopSignalRef = useRef(Signal.new())
	local onVideoLoadedSignalRef = useRef(Signal.new())

	local seek = useCallback(function(p: number)
		local current = ref.current

		if current then
			current.TimePosition = math.clamp(p + union.playbackRegion.Min, 0, state)
		end
	end, { state, union.playbackRegion })

	local v5 = useCallback(function()
		local current = ref.current

		if current then
			onVideoLoadedSignalRef.current:fire()
			local v5 = union.playbackRegion.Max - union.playbackRegion.Min
			current.Volume = v4.enabled and 0 or 0.2
			setState3((math.min(v5, current.TimeLength)))
			setState(current.TimeLength)
		end
	end, { union.playbackRegion, v4.enabled })

	local v6 = useCallback(function()
		if not flag then
			return
		end

		local current = ref.current

		if current then
			setState4(current.TimePosition - union.playbackRegion.Min)
			setState2(current.TimePosition)
		end
	end, { flag, union.playbackRegion })

	local v7 = useCallback(function()
		if not ref.current then
			return
		end

		ref.current.TimePosition = union.playbackRegion.Min

		onVideoDidLoopSignalRef.current:fire()
	end, { union.playbackRegion })

	useEffect(function()
		local current = ref.current

		if not current then
			return
		end

		if videoContent then
			current.VideoContent = videoContent
		end
	end, { v2.enabled, videoContent })

	useEffect(function()
		local current = ref.current

		if not current then
			return
		end

		local loadedConnection = current.Loaded:Connect(v5)
		local RunService = game:GetService("RunService")
		local renderSteppedConnection = RunService.RenderStepped:Connect(v6)
		local didLoopConnection = current.DidLoop:Connect(v7)

		return function()
			loadedConnection:Disconnect()
			renderSteppedConnection:Disconnect()
			didLoopConnection:Disconnect()
		end
	end, { v2.enabled, v6, v5, v7 })

	useEffect(function()
		local current = ref.current

		if current then
			current.Looped = union.looping
		end
	end, { v2.enabled, union.looping })

	useEffect(function()
		local current = ref.current

		if current then
			current.Playing = v3.enabled
		end
	end, { v2.enabled, v3.enabled })

	useEffect(function()
		local current = ref.current

		if current then
			current.Volume = v4.enabled and 0 or 0.2
		end
	end, { v2.enabled, v4.enabled })

	useEffect(function()
		local current = ref.current

		if not current then
			return
		end

		if state2 >= union.playbackRegion.Max + 0.001 then
			if v3.enabled then
				if union.looping then
					current.TimePosition = union.playbackRegion.Min
					onVideoDidLoopSignalRef.current:fire()
				else
					v3.disable()
				end
			else
				state2 = union.playbackRegion.Max
			end
		end

		if state2 < union.playbackRegion.Min - 0.001 then
			current.TimePosition = union.playbackRegion.Min
		end
	end, { state2, union.playbackRegion, union.looping, v3.disable })

	useEffect(function()
		local current = ref.current

		if current then
			setState3((math.min(union.playbackRegion.Max - union.playbackRegion.Min, current.TimeLength)))
		end
	end, { union.playbackRegion })

	local updateRef = useCallback(function(current)
		v2.toggle()
		ref.current = current
	end, { v2.toggle })

	return {
		timeline = {
			duration = state3,
			elapsed = state4,
			seek = seek,
			timeLength = state,
			timePosition = state2
		},
		playback = {
			isPlaying = v3.enabled,
			pause = v3.disable,
			play = v3.enable,
			toggle = v3.toggle
		},
		volume = { isMuted = v4.enabled, mute = v4.enable, unmute = v4.disable, toggle = v4.toggle },
		onVideoDidLoopSignalRef = onVideoDidLoopSignalRef,
		onVideoLoadedSignalRef = onVideoLoadedSignalRef,
		ref = ref,
		updateRef = updateRef
	}
end

return useVideoPlayback
