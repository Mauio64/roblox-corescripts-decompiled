local Parent = script:FindFirstAncestor("MomentsCreation").Parent
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MomentsCommon = require(Parent.MomentsCommon)
local React = require(Parent.React)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useState = React.useState
local useToggleState = MomentsCommon.Hooks.useToggleState
local LocalPlayer = Players.LocalPlayer

local function assetIdAsContent(n1: number?) -- line: 62
	if n1 == nil then
		return nil
	end

	return `rbxassetid://{ n1 }`
end
local function useAudioPlayback(b1: boolean, n2: number?, t1: {[any]: any}?) -- line: 69
	-- upvalues: useRef (copy), useToggleState (copy), useState (copy), useMemo (copy), useCallback (copy), useEffect (copy), LocalPlayer (copy), RunService (copy)
	local v19 = t1 or {}
	local v20 = v19.autoplay ~= nil and v19.autoplay
	local v21 = v19.looping ~= nil and v19.looping
	local v22 = v19.playbackRegion or NumberRange.new(0, 1e999)
	local v23 = useRef(nil)
	local v24 = useToggleState(v20)
	local v25 = useToggleState(false)
	local v26, v27 = useState(0)
	local v28, v29 = useState(0)
	local v30, v31 = useState(0)
	local v32, v33 = useState(0)
	local v34 = useMemo(function() -- line: 90
		-- upvalues: n2 (copy)
		local v38 = n2

		if v38 == nil then
			return nil
		end

		return `rbxassetid://{ v38 }`
	end, { n2 })
	local v35 = useCallback(function(n3: number) -- line: 94
		-- upvalues: v23 (copy), v22 (copy), v26 (copy)
		local current = v23.current

		if current then
			current.TimePosition = math.clamp(n3 + v22.Min, 0, v26)
		end
	end, {
		v26,
		v22
	})
	local v36 = useCallback(function() -- line: 101
		-- upvalues: b1 (copy), v23 (copy), v33 (copy), v22 (copy), v29 (copy)
		if not b1 then
			return
		end

		local current = v23.current

		if current then
			v33(current.TimePosition - v22.Min)
			v29(current.TimePosition)
		end
	end, {
		b1,
		v22
	})

	useEffect(function() -- line: 115
		-- upvalues: v34 (copy), v22 (copy), v21 (copy), v27 (copy), v23 (copy), LocalPlayer (copy)
		if v34 == nil then
			return
		end

		local Folder = Instance.new("Folder")

		Folder.Name = `AudioPlayback_{ v34 }`

		local AudioPlayer = Instance.new("AudioPlayer")

		AudioPlayer.Asset = v34
		AudioPlayer.PlaybackRegion = v22
		AudioPlayer.Looping = v21
		AudioPlayer.Parent = Folder
		AudioPlayer.Volume = 0.2

		local function updateTimeLength() -- line: 130
			-- upvalues: v27 (copy), AudioPlayer (copy)
			v27(AudioPlayer.TimeLength)
		end

		AudioPlayer:GetPropertyChangedSignal("TimeLength"):Connect(updateTimeLength)
		v27(AudioPlayer.TimeLength)

		local AudioDeviceOutput = Instance.new("AudioDeviceOutput")

		AudioDeviceOutput.Parent = Folder

		local Wire = Instance.new("Wire")

		Wire.SourceInstance = AudioPlayer
		Wire.TargetInstance = AudioDeviceOutput
		Wire.Parent = Folder
		v23.current = AudioPlayer

		local u47 = false

		task.spawn(function() -- line: 148
			-- upvalues: LocalPlayer (copy), u47 (ref), Folder (copy)
			local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

			if u47 then
				return
			end

			Folder.Parent = PlayerGui
		end)

		return function() -- line: 156
			-- upvalues: u47 (ref), Folder (copy)
			u47 = true
			Folder:Destroy()
		end
	end, { v34 })
	useEffect(function() -- line: 162
		-- upvalues: v23 (copy), v22 (copy)
		local current = v23.current

		if current then
			current.PlaybackRegion = v22
			current.TimePosition = 0
		end
	end, { v22 })
	useEffect(function() -- line: 170
		-- upvalues: v31 (copy), v22 (copy), v26 (copy)
		v31((math.min(v22.Max - v22.Min, v26)))
	end, {
		v26,
		v22
	})
	useEffect(function() -- line: 177
		-- upvalues: v23 (copy), v24 (copy)
		local current = v23.current

		if current then
			if v24.enabled then
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
		v24.enabled,
		v34
	})
	useEffect(function() -- line: 194
		-- upvalues: v23 (copy), v25 (copy), v24 (copy)
		local current = v23.current

		if current then
			if v25.enabled or not v24.enabled then
				current.Volume = 0

				return
			end

			current.Volume = 0.2
		end
	end, {
		v25.enabled,
		v24.enabled
	})

	local v37 = useCallback(function() -- line: 209
		-- upvalues: v24 (copy)
		v24.disable()
	end, {})

	useEffect(function() -- line: 216
		-- upvalues: v23 (copy), RunService (copy), v36 (copy), v37 (copy)
		local t2 = {}
		local current = v23.current

		if current then
			table.insert(t2, RunService.RenderStepped:Connect(v36))
			table.insert(t2, current.Ended:Connect(v37))
		end

		return function() -- line: 224
			-- upvalues: t2 (copy)
			for _, v55 in t2 do
				v55:Disconnect()
			end
		end
	end, {
		v36,
		v37,
		v34
	})

	return {
		timeline = {
			duration = v30,
			elapsed = v32,
			seek = v35,
			timeLength = v26,
			timePosition = v28
		},
		playback = {
			isPlaying = v24.enabled,
			pause = v24.disable,
			play = v24.enable,
			toggle = v24.toggle
		},
		volume = {
			isMuted = v25.enabled,
			mute = v25.enable,
			unmute = v25.disable,
			toggle = v25.toggle
		},
		ref = v23
	}
end

return useAudioPlayback
