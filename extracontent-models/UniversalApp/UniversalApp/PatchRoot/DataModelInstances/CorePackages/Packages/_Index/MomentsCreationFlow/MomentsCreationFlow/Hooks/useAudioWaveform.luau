local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local Players = game:GetService("Players")

local React = require(parent.React)

local useEffect = React.useEffect

local Constants = require(MomentsCreationFlow.Constants)

local LocalPlayer = Players.LocalPlayer

local SegmentSelectorWidth = Constants.AudioWaveform.SegmentSelectorWidth
local WaveformWidth = Constants.AudioWaveform.WaveformWidth
local WaveformPadding = Constants.AudioWaveform.WaveformPadding

local function assetIdAsContent(p: number) -- 1 equivalent call inferred from this helper
	return `rbxassetid://{p}`
end

local function normalizeWaveform(waveformAsync)
	local result = {}
	local maxValue = 0

	for _, item in waveformAsync do
		local v = math.max(0, item)
		table.insert(result, v)
		maxValue = math.max(maxValue, v)
	end

	if maxValue == 0 then
		return result
	end

	local result2 = {}

	for _, v in result do
		table.insert(result2, v / maxValue)
	end

	return result2
end

local function useAudioWaveform(p: number, p2: number)
	local state, setState = React.useState({})
	local ref = React.useRef(nil)

	local v = React.useMemo(function()
		return SegmentSelectorWidth / (WaveformWidth + WaveformPadding) / p2
	end, { p2 })

	local asset = React.useMemo(function()
		return assetIdAsContent(p) -- inferred equivalent call
	end, { p })

	useEffect(function()
		local audioWaveform = Instance.new("Folder")
		audioWaveform.Name = "AudioWaveform"

		local audioPlayer = Instance.new("AudioPlayer")
		audioPlayer.Asset = asset
		audioPlayer.Parent = audioWaveform

		ref.current = audioPlayer
		audioWaveform.Parent = LocalPlayer:WaitForChild("PlayerGui")

		return function()
			audioWaveform:Destroy()
		end
	end, { p, p2 })

	local v2 = React.useCallback(function()
		local current = ref.current

		if current and current.IsReady then
			task.spawn(function()
				setState(normalizeWaveform(current:GetWaveformAsync(
					NumberRange.new(0, current.TimeLength),
					v * current.TimeLength
				)))
			end)
		end
	end, {})

	useEffect(function()
		local current = ref.current
		local connections = {}

		if current then
			table.insert(connections, current:GetPropertyChangedSignal("IsReady"):Connect(v2))
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, {})

	return state
end

return useAudioWaveform
