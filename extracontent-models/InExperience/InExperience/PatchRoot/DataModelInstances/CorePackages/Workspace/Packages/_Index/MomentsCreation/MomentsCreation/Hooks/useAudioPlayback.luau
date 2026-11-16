local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local fadeVolume = require(MomentsCreation.Audio.fadeVolume)
local startAudioOnLoad = require(MomentsCreation.Audio.startAudioOnLoad)
local FFlagMomentsCreationStartAudioOnLoad = require(MomentsCreation.Flags.FFlagMomentsCreationStartAudioOnLoad)
local GetFFlagMomentsTTSAudioOverlay = require(MomentsCreation.Flags.GetFFlagMomentsTTSAudioOverlay)

local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useState = React.useState
local useToggleState = MomentsCommon.Hooks.useToggleState

local LocalPlayer = Players.LocalPlayer

local function assetIdAsContent(p: number?) -- 1 equivalent call inferred from this helper
	if p == nil then
		return nil
	end

	return `rbxassetid://{p}`
end

local function useAudioPlayback(flag: boolean, p: number?, options)
	local v = options or {}
	local v2 = not (v.autoplay == nil) and v.autoplay
	local looping

	if v.looping == nil then
		looping = false
	else
		looping = v.looping
	end

	local playbackRegion = v.playbackRegion or NumberRange.new(0, 1e999)
	local v3 = v.duckScalar == nil and 1 or v.duckScalar

	local ref = useRef(nil)

	local v4 = useToggleState(v2)
	local v5 = useToggleState(false)
	local v6 = useRef(v4.enabled)

	if FFlagMomentsCreationStartAudioOnLoad then
		v6.current = v4.enabled
	end

	local state, setState = useState(0)
	local state2, setState2 = useState(0)
	local state3, setState3 = useState(0)
	local state4, setState4 = useState(0)

	local asset = useMemo(function()
		return assetIdAsContent(p) -- inferred equivalent call
	end, { p })

	local seek = useCallback(function(p2: number)
		local current = ref.current

		if current then
			current.TimePosition = math.clamp(p2 + playbackRegion.Min, 0, state)
		end
	end, { state, playbackRegion })

	local v7 = useCallback(function()
		if not flag then
			return
		end

		local current = ref.current

		if current then
			setState4(current.TimePosition - playbackRegion.Min)
			setState2(current.TimePosition)
		end
	end, { flag, playbackRegion })

	useEffect(function()
		if asset == nil then
			return
		end

		local folder = Instance.new("Folder")
		folder.Name = `AudioPlayback_{asset}`

		local audioPlayer = Instance.new("AudioPlayer")
		audioPlayer.Asset = asset
		audioPlayer.PlaybackRegion = playbackRegion
		audioPlayer.Looping = looping
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
		local connection

		if FFlagMomentsCreationStartAudioOnLoad then
			connection = startAudioOnLoad(audioPlayer, function()
				return v6.current
			end)
		else
			connection = nil
		end

		local flag2 = false
		task.spawn(function()
			local playerGui = LocalPlayer:WaitForChild("PlayerGui")

			if flag2 then
				return
			end

			folder.Parent = playerGui
		end)

		return function()
			flag2 = true

			if connection ~= nil then
				connection:Disconnect()
			end

			folder:Destroy()
		end
	end, { asset })

	useEffect(function()
		local current = ref.current

		if current then
			current.PlaybackRegion = playbackRegion

			if FFlagMomentsCreationStartAudioOnLoad then
				if current.IsReady then
					current.TimePosition = playbackRegion.Min
				end
			else
				current.TimePosition = 0
			end
		end
	end, { playbackRegion })

	useEffect(function()
		setState3((math.min(playbackRegion.Max - playbackRegion.Min, state)))
	end, { state, playbackRegion })

	useEffect(function()
		local current = ref.current

		if current then
			if FFlagMomentsCreationStartAudioOnLoad and not current.IsReady then
				current.PlaybackSpeed = 0
			elseif v4.enabled then
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
	end, { v4.enabled, asset })

	useEffect(function()
		if GetFFlagMomentsTTSAudioOverlay then
			return
		end

		local current = ref.current

		if current ~= nil then
			current.Volume = (v5.enabled or not v4.enabled) and 0 or 0.2
		end
	end, { v5.enabled, v4.enabled })

	useEffect(function()
		if not GetFFlagMomentsTTSAudioOverlay then
			return
		end

		local current = ref.current

		if current ~= nil then
			if v5.enabled or not v4.enabled then
				fadeVolume(current, 0, true)
			else
				fadeVolume(current, 0.2 * v3)
			end
		end
	end, { v5.enabled, v4.enabled, v3, asset })

	local v8 = useCallback(function()
		v4.disable()
	end, {})

	useEffect(function()
		local connections = {}
		local current = ref.current

		if current then
			table.insert(connections, RunService.RenderStepped:Connect(v7))
			table.insert(connections, current.Ended:Connect(v8))
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { v7, v8, asset })

	return {
		timeline = {
			duration = state3,
			elapsed = state4,
			seek = seek,
			timeLength = state,
			timePosition = state2
		},
		playback = {
			isPlaying = v4.enabled,
			pause = v4.disable,
			play = v4.enable,
			toggle = v4.toggle
		},
		volume = { isMuted = v5.enabled, mute = v5.enable, unmute = v5.disable, toggle = v5.toggle },
		ref = ref
	}
end

return useAudioPlayback
