local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Cryo = require(MomentsCommonParent.Cryo)
local React = require(MomentsCommonParent.React)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState
local useToggleState = require(MomentsCommon.Hooks.useToggleState)
local Signal = require(MomentsCommon.Utils.Signal)

require(MomentsCommon.Types)

local t1 = {
	autoplay = false,
	looping = false,
	playbackRegion = NumberRange.new(0, 1e999)
}

local function useVideoPlayback(b1: boolean, p1, t2: {[any]: any}?) -- line: 41
	-- upvalues: Cryo (copy), t1 (copy), useRef (copy), useToggleState (copy), useState (copy), Signal (copy), useCallback (copy), useEffect (copy)
	local v16 = Cryo.Dictionary.union(t1, t2 or {})
	local v17 = useRef(nil)
	local v18 = useToggleState(false)
	local v19 = useToggleState(v16.autoplay)
	local v20 = useToggleState(false)
	local v21, v22 = useState(0)
	local u23, v24 = useState(0)
	local v25, v26 = useState(0)
	local v27, v28 = useState(0)
	local v29 = useRef(Signal.new())
	local v30 = useRef(Signal.new())
	local v31 = useCallback(function(n1: number) -- line: 64
		-- upvalues: v17 (copy), v16 (copy), v21 (copy)
		local current = v17.current

		if current then
			current.TimePosition = math.clamp(n1 + v16.playbackRegion.Min, 0, v21)
		end
	end, {
		v21,
		v16.playbackRegion
	})
	local v32 = useCallback(function() -- line: 72
		-- upvalues: v17 (copy), v30 (copy), v16 (copy), v20 (copy), v26 (copy), v22 (copy)
		local current = v17.current

		if current then
			v30.current:fire()

			local v39 = v16.playbackRegion.Max - v16.playbackRegion.Min

			current.Volume = not v20.enabled and 0.2 or 0
			v26((math.min(v39, current.TimeLength)))
			v22(current.TimeLength)
		end
	end, {
		v16.playbackRegion,
		v20.enabled
	})
	local v33 = useCallback(function() -- line: 83
		-- upvalues: b1 (copy), v17 (copy), v28 (copy), v16 (copy), v24 (copy)
		if not b1 then
			return
		end

		local current = v17.current

		if current then
			v28(current.TimePosition - v16.playbackRegion.Min)
			v24(current.TimePosition)
		end
	end, {
		b1,
		v16.playbackRegion
	})
	local v34 = useCallback(function() -- line: 95
		-- upvalues: v17 (copy), v16 (copy), v29 (copy)
		if not v17.current then
			return
		end

		v17.current.TimePosition = v16.playbackRegion.Min
		v29.current:fire()
	end, { v16.playbackRegion })

	useEffect(function() -- line: 106
		-- upvalues: v17 (copy), p1 (copy)
		local current = v17.current

		if not current then
			return
		end

		if p1 then
			current.VideoContent = p1
		end
	end, {
		v18.enabled,
		p1
	})
	useEffect(function() -- line: 117
		-- upvalues: v17 (copy), v32 (copy), v33 (copy), v34 (copy)
		local current = v17.current

		if not current then
			return
		end

		local connection = current.Loaded:Connect(v32)
		local connection2 = game:GetService("RunService").RenderStepped:Connect(v33)
		local connection3 = current.DidLoop:Connect(v34)

		return function() -- line: 127
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, {
		v18.enabled,
		v33,
		v32,
		v34
	})
	useEffect(function() -- line: 134
		-- upvalues: v17 (copy), v16 (copy)
		local current = v17.current

		if current then
			current.Looped = v16.looping
		end
	end, {
		v18.enabled,
		v16.looping
	})
	useEffect(function() -- line: 141
		-- upvalues: v17 (copy), v19 (copy)
		local current = v17.current

		if current then
			current.Playing = v19.enabled
		end
	end, {
		v18.enabled,
		v19.enabled
	})
	useEffect(function() -- line: 148
		-- upvalues: v17 (copy), v20 (copy)
		local current = v17.current

		if current then
			current.Volume = not v20.enabled and 0.2 or 0
		end
	end, {
		v18.enabled,
		v20.enabled
	})
	useEffect(function() -- line: 155
		-- upvalues: v17 (copy), u23 (ref), v16 (copy), v19 (copy), v29 (copy)
		local current = v17.current

		if not current then
			return
		end

		if u23 >= v16.playbackRegion.Max + 0.001 then
			if not v19.enabled then
				u23 = v16.playbackRegion.Max
			elseif v16.looping then
				current.TimePosition = v16.playbackRegion.Min
				v29.current:fire()
			else
				v19.disable()
			end
		end

		if u23 < v16.playbackRegion.Min - 0.001 then
			current.TimePosition = v16.playbackRegion.Min
		end
	end, {
		u23,
		v16.playbackRegion,
		v16.looping,
		v19.disable
	})
	useEffect(function() -- line: 182
		-- upvalues: v17 (copy), v16 (copy), v26 (copy)
		local current = v17.current

		if current then
			local v51 = v16.playbackRegion.Max - v16.playbackRegion.Min

			v26((math.min(v51, current.TimeLength)))
		end
	end, { v16.playbackRegion })

	local v35 = useCallback(function(p2) -- line: 190
		-- upvalues: v18 (copy), v17 (copy)
		v18.toggle()
		v17.current = p2
	end, { v18.toggle })

	return {
		timeline = {
			duration = v25,
			elapsed = v27,
			seek = v31,
			timeLength = v21,
			timePosition = u23
		},
		playback = {
			isPlaying = v19.enabled,
			pause = v19.disable,
			play = v19.enable,
			toggle = v19.toggle
		},
		volume = {
			isMuted = v20.enabled,
			mute = v20.enable,
			unmute = v20.disable,
			toggle = v20.toggle
		},
		onVideoDidLoopSignalRef = v29,
		onVideoLoadedSignalRef = v30,
		ref = v17,
		updateRef = v35
	}
end

return useVideoPlayback
