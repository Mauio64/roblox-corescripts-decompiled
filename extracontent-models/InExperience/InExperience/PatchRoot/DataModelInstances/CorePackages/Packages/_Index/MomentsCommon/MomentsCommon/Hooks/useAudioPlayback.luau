local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local Players = game:GetService("Players")

local Cryo = require(parent.Cryo)
local React = require(parent.React)

local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useState = React.useState
local useToggleState = require(MomentsCommon.Hooks.useToggleState)

require(MomentsCommon.Types)

local LocalPlayer = Players.LocalPlayer

local function assetIdAsContent(asset: number?) -- 1 equivalent call inferred from this helper
	if asset then
		return `rbxassetid://{asset}`
	end

	return nil
end

local v = { autoplay = false, looping = false, playbackRegion = NumberRange.new(0, 1e999) }

local function useAudioPlayback(flag: boolean, asset: number?, options)
	local union = Cryo.Dictionary.union(v, options or {})

	local ref = useRef(nil)

	local v2 = useToggleState(union.autoplay)
	local v3 = useToggleState(false)

	local state, setState = useState(0)
	local state2, setState2 = useState(0)

	local state3, setState3 = useState(0)
	local state4, setState4 = useState(0)

	local seek = useCallback(function(p: number)
		local current = ref.current

		if current then
			current.TimePosition = math.clamp(p + union.playbackRegion.Min, 0, state)
		end
	end, { state, union.playbackRegion })

	local v4 = useCallback(function()
		if not flag then
			return
		end

		local current = ref.current

		if current then
			setState4(current.TimePosition - union.playbackRegion.Min)
			setState2(current.TimePosition)
		end
	end, { flag, asset, union.playbackRegion })

	asset = useMemo(function()
		return assetIdAsContent(asset) -- inferred equivalent call
	end, { asset })

	useEffect(function()
		if not asset then
			return
		end

		local folder = Instance.new("Folder")
		folder.Name = `AudioPlayback_{asset}`

		local audioPlayer = Instance.new("AudioPlayer")
		audioPlayer.Asset = asset
		audioPlayer.PlaybackRegion = union.playbackRegion
		audioPlayer.Looping = union.looping or false
		audioPlayer.Parent = folder
		audioPlayer.Volume = 0.2

		local function updateTimeLength() -- 1 equivalent call inferred from this helper
			setState(audioPlayer.TimeLength)
		end

		audioPlayer:GetPropertyChangedSignal("TimeLength"):Connect(updateTimeLength)
		updateTimeLength() -- inferred equivalent call
		local audioDeviceOutput = Instance.new("AudioDeviceOutput")
		audioDeviceOutput.Parent = folder

		local wire = Instance.new("Wire")
		wire.SourceInstance = audioPlayer
		wire.TargetInstance = audioDeviceOutput
		wire.Parent = folder

		ref.current = audioPlayer
		task.spawn(function()
			folder.Parent = LocalPlayer:WaitForChild("PlayerGui")
		end)

		return function()
			folder:Destroy()
		end
	end, { asset })

	useEffect(function()
		local current = ref.current

		if current then
			current.PlaybackRegion = union.playbackRegion
			current.TimePosition = 0
		end
	end, { union.playbackRegion })

	useEffect(function()
		local v5 = union.playbackRegion.Max - union.playbackRegion.Min
		setState3((math.min(v5, state)))
	end, { state, union.playbackRegion })

	useEffect(function()
		local current = ref.current

		if current then
			if v2.enabled then
				current.PlaybackSpeed = 1

				if not current.IsPlaying then
					current:Play()
				end
			else
				current.PlaybackSpeed = 0

				if current.IsPlaying then
					current:Stop()
				end
			end
		end
	end, { asset, v2.enabled })

	useEffect(function()
		local current = ref.current

		if current then
			if v3.enabled or not v2.enabled then
				current.Volume = 0
			else
				current.Volume = 0.2
			end
		end
	end, { v3.enabled, v2.enabled })

	local v5 = useCallback(function()
		v2.disable()
	end, {})

	useEffect(function()
		local connections = {}

		if ref.current then
			local RunService = game:GetService("RunService")
			table.insert(connections, RunService.RenderStepped:Connect(v4))
			table.insert(connections, ref.current.Ended:Connect(v5))
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { v4, v5 })

	return {
		timeline = {
			duration = state3,
			elapsed = state4,
			seek = seek,
			timeLength = state,
			timePosition = state2
		},
		playback = {
			isPlaying = v2.enabled,
			pause = v2.disable,
			play = v2.enable,
			toggle = v2.toggle
		},
		volume = { isMuted = v3.enabled, mute = v3.enable, unmute = v3.disable, toggle = v3.toggle },
		ref = ref
	}
end

return useAudioPlayback
