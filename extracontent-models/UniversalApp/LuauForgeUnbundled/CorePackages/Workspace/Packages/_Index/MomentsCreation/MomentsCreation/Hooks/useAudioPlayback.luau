local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local fadeVolume = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Audio/fadeVolume")
local startAudioOnLoad = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Audio/startAudioOnLoad")
local FFlagMomentsCreationStartAudioOnLoad = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationStartAudioOnLoad")
local GetFFlagMomentsTTSAudioOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsTTSAudioOverlay")

local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useState = React.useState
local useToggleState = MomentsCommon.Hooks.useToggleState

local localPlayer = Players.LocalPlayer

local function assetIdAsContent(p2)
	if p2 == nil then
		return nil
	end

	return `rbxassetid://{p2}`
end

local function useAudioPlayback(p2, p3, options)
	local v5 = options or {}
	local v6 = not (v5.autoplay == nil) and v5.autoplay
	local v7 = not (v5.looping == nil) and v5.looping
	local playbackRegion = v5.playbackRegion or NumberRange.new(0, 1e999)
	local v8 = v5.duckScalar == nil and 1 or v5.duckScalar

	local v9 = useRef(nil)

	local v10 = useToggleState(v6)
	local v11 = useToggleState(false)
	local v12 = useRef(v10.enabled)

	if FFlagMomentsCreationStartAudioOnLoad then
		v12.current = v10.enabled
	end

	local state, setState = useState(0)
	local state2, setState2 = useState(0)
	local state3, setState3 = useState(0)
	local state4, setState4 = useState(0)

	local v13 = useMemo(function()
		local v14 = p3

		if v14 == nil then
			return nil
		end

		return `rbxassetid://{v14}`
	end, { p3 })

	local v14 = useCallback(function(p4)
		local current = v9.current

		if current then
			current.TimePosition = math.clamp(p4 + playbackRegion.Min, 0, state)
		end
	end, { state, playbackRegion })

	local v15 = useCallback(function()
		if not p2 then
			return
		end

		local current = v9.current

		if current then
			setState4(current.TimePosition - playbackRegion.Min)
			setState2(current.TimePosition)
		end
	end, { p2, playbackRegion })

	useEffect(function()
		if v13 == nil then
			return
		end

		local folder = Instance.new("Folder")
		folder.Name = `AudioPlayback_{v13}`

		local audioPlayer = Instance.new("AudioPlayer")
		audioPlayer.Asset = v13
		audioPlayer.PlaybackRegion = playbackRegion
		audioPlayer.Looping = v7
		audioPlayer.Parent = folder
		audioPlayer.Volume = 0.2

		local function updateTimeLength()
			setState(audioPlayer.TimeLength)
		end
		audioPlayer:GetPropertyChangedSignal("TimeLength"):Connect(updateTimeLength)
		setState(audioPlayer.TimeLength)

		local audioDeviceOutput = Instance.new("AudioDeviceOutput")
		audioDeviceOutput.Parent = folder

		local wire = Instance.new("Wire")
		wire.SourceInstance = audioPlayer
		wire.TargetInstance = audioDeviceOutput
		wire.Parent = folder

		v9.current = audioPlayer
		local connection

		if FFlagMomentsCreationStartAudioOnLoad then
			connection = startAudioOnLoad(audioPlayer, function()
				return v12.current
			end)
		else
			connection = nil
		end

		local flag = false
		task.spawn(function()
			local playerGui = localPlayer:WaitForChild("PlayerGui")

			if flag then
				return
			end

			folder.Parent = playerGui
		end)

		return function()
			flag = true

			if connection ~= nil then
				connection:Disconnect()
			end

			folder:Destroy()
		end
	end, { v13 })

	useEffect(function()
		local current = v9.current

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
		local current = v9.current

		if current then
			if FFlagMomentsCreationStartAudioOnLoad and not current.IsReady then
				current.PlaybackSpeed = 0
			elseif v10.enabled then
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
	end, { v10.enabled, v13 })

	useEffect(function()
		if GetFFlagMomentsTTSAudioOverlay then
			return
		end

		local current = v9.current

		if current ~= nil then
			current.Volume = (v11.enabled or not v10.enabled) and 0 or 0.2
		end
	end, { v11.enabled, v10.enabled })

	useEffect(function()
		if not GetFFlagMomentsTTSAudioOverlay then
			return
		end

		local current = v9.current

		if current ~= nil then
			if v11.enabled or not v10.enabled then
				fadeVolume(current, 0, true)
			else
				fadeVolume(current, 0.2 * v8)
			end
		end
	end, { v11.enabled, v10.enabled, v8, v13 })

	local v16 = useCallback(function()
		v10.disable()
	end, {})

	useEffect(function()
		local connections = {}
		local current = v9.current

		if current then
			table.insert(connections, RunService.RenderStepped:Connect(v15))
			table.insert(connections, current.Ended:Connect(v16))
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, { v15, v16, v13 })

	return {
		timeline = {
			duration = state3,
			elapsed = state4,
			seek = v14,
			timeLength = state,
			timePosition = state2
		},
		playback = {
			isPlaying = v10.enabled,
			pause = v10.disable,
			play = v10.enable,
			toggle = v10.toggle
		},
		volume = {
			isMuted = v11.enabled,
			mute = v11.enable,
			unmute = v11.disable,
			toggle = v11.toggle
		},
		ref = v9
	}
end

return useAudioPlayback
