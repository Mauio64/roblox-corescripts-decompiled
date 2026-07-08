local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local Players = game:GetService("Players")
local Cryo = require(MomentsCommonParent.Cryo)
local React = require(MomentsCommonParent.React)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useState = React.useState
local useToggleState = require(MomentsCommon.Hooks.useToggleState)

require(MomentsCommon.Types)

local LocalPlayer = Players.LocalPlayer

local function assetIdAsContent(n1: number?) -- line: 22
	if not n1 then
		return nil
	end

	return `rbxassetid://{ n1 }`
end

local t1 = {
	autoplay = false,
	looping = false,
	playbackRegion = NumberRange.new(0, 1e999)
}

local function useAudioPlayback(b1: boolean, n2: number?, t2: {[any]: any}?) -- line: 46
	-- upvalues: Cryo (copy), t1 (copy), useRef (copy), useToggleState (copy), useState (copy), useCallback (copy), useMemo (copy), useEffect (copy), LocalPlayer (copy)
	local v21 = Cryo.Dictionary.union(t1, t2 or {})
	local v22 = useRef(nil)
	local v23 = useToggleState(v21.autoplay)
	local v24 = useToggleState(false)
	local v25, v26 = useState(0)
	local v27, v28 = useState(0)
	local v29, v30 = useState(0)
	local v31, v32 = useState(0)
	local v33 = useCallback(function(n3: number) -- line: 64
		-- upvalues: v22 (copy), v21 (copy), v25 (copy)
		local current = v22.current

		if current then
			current.TimePosition = math.clamp(n3 + v21.playbackRegion.Min, 0, v25)
		end
	end, {
		v25,
		v21.playbackRegion
	})
	local v34 = useCallback(function() -- line: 72
		-- upvalues: b1 (copy), v22 (copy), v32 (copy), v21 (copy), v28 (copy)
		if not b1 then
			return
		end

		local current = v22.current

		if current then
			v32(current.TimePosition - v21.playbackRegion.Min)
			v28(current.TimePosition)
		end
	end, {
		b1,
		n2,
		v21.playbackRegion
	})

	n2 = useMemo(function() -- line: 87
		-- upvalues: n2 (ref)
		local v39 = n2

		if not v39 then
			return nil
		end

		return `rbxassetid://{ v39 }`
	end, { n2 })
	useEffect(function() -- line: 91
		-- upvalues: n2 (ref), v21 (copy), v26 (copy), v22 (copy), LocalPlayer (copy)
		if not n2 then
			return
		end

		local Folder = Instance.new("Folder")

		Folder.Name = `AudioPlayback_{ n2 }`

		local AudioPlayer = Instance.new("AudioPlayer")

		AudioPlayer.Asset = n2
		AudioPlayer.PlaybackRegion = v21.playbackRegion
		AudioPlayer.Looping = v21.looping or false
		AudioPlayer.Parent = Folder
		AudioPlayer.Volume = 0.2

		local function updateTimeLength() -- line: 106
			-- upvalues: v26 (copy), AudioPlayer (copy)
			v26(AudioPlayer.TimeLength)
		end

		AudioPlayer:GetPropertyChangedSignal("TimeLength"):Connect(updateTimeLength)
		v26(AudioPlayer.TimeLength)

		local AudioDeviceOutput = Instance.new("AudioDeviceOutput")

		AudioDeviceOutput.Parent = Folder

		local Wire = Instance.new("Wire")

		Wire.SourceInstance = AudioPlayer
		Wire.TargetInstance = AudioDeviceOutput
		Wire.Parent = Folder
		v22.current = AudioPlayer
		task.spawn(function() -- line: 123
			-- upvalues: Folder (copy), LocalPlayer (copy)
			Folder.Parent = LocalPlayer:WaitForChild("PlayerGui")
		end)

		return function() -- line: 127
			-- upvalues: Folder (copy)
			Folder:Destroy()
		end
	end, { n2 })
	useEffect(function() -- line: 132
		-- upvalues: v22 (copy), v21 (copy)
		local current = v22.current

		if current then
			current.PlaybackRegion = v21.playbackRegion
			current.TimePosition = 0
		end
	end, { v21.playbackRegion })
	useEffect(function() -- line: 140
		-- upvalues: v21 (copy), v30 (copy), v25 (copy)
		local v46 = v21.playbackRegion.Max - v21.playbackRegion.Min

		v30((math.min(v46, v25)))
	end, {
		v25,
		v21.playbackRegion
	})
	useEffect(function() -- line: 145
		-- upvalues: v22 (copy), v23 (copy)
		local current = v22.current

		if current then
			if v23.enabled then
				current.PlaybackSpeed = 1

				if not current.IsPlaying then
					current:Play()

					return
				end
			else
				current.PlaybackSpeed = 0

				if current.IsPlaying then
					current:Stop()
				end
			end
		end
	end, {
		n2,
		v23.enabled
	})
	useEffect(function() -- line: 163
		-- upvalues: v22 (copy), v24 (copy), v23 (copy)
		local current = v22.current

		if current then
			if v24.enabled or not v23.enabled then
				current.Volume = 0

				return
			end

			current.Volume = 0.2
		end
	end, {
		v24.enabled,
		v23.enabled
	})

	local v35 = useCallback(function() -- line: 180
		-- upvalues: v23 (copy)
		v23.disable()
	end, {})

	useEffect(function() -- line: 184
		-- upvalues: v22 (copy), v34 (copy), v35 (copy)
		local t3 = {}

		if v22.current then
			table.insert(t3, game:GetService("RunService").RenderStepped:Connect(v34))
			table.insert(t3, v22.current.Ended:Connect(v35))
		end

		return function() -- line: 192
			-- upvalues: t3 (copy)
			for _, v51 in t3 do
				v51:Disconnect()
			end
		end
	end, {
		v34,
		v35
	})

	return {
		timeline = {
			duration = v29,
			elapsed = v31,
			seek = v33,
			timeLength = v25,
			timePosition = v27
		},
		playback = {
			isPlaying = v23.enabled,
			pause = v23.disable,
			play = v23.enable,
			toggle = v23.toggle
		},
		volume = {
			isMuted = v24.enabled,
			mute = v24.enable,
			unmute = v24.disable,
			toggle = v24.toggle
		},
		ref = v22
	}
end

return useAudioPlayback
