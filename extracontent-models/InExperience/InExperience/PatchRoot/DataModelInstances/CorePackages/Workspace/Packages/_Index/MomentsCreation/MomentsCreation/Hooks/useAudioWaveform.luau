local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Players = game:GetService("Players")

local React = require(parent.React)

local useEffect = React.useEffect

local Constants = require(MomentsCreation.Constants)

local LocalPlayer = Players.LocalPlayer

local SegmentSelectorWidth = Constants.AudioWaveform.SegmentSelectorWidth
local WaveformWidth = Constants.AudioWaveform.WaveformWidth
local WaveformPadding = Constants.AudioWaveform.WaveformPadding

local function assetIdAsContent(p: number) -- 1 equivalent call inferred from this helper
	return `rbxassetid://{p}`
end

local function normalizeWaveform(result)
	local result2 = {}
	local maxValue = 0

	for _, item in result do
		local v = math.max(0, item)
		table.insert(result2, v)
		maxValue = math.max(maxValue, v)
	end

	if maxValue == 0 then
		return result2
	end

	local result3 = {}

	for _, v in result2 do
		table.insert(result3, v / maxValue)
	end

	return result3
end

local function useAudioWaveform(p: number, p2: number)
	local state, setState = React.useState({})

	useEffect(function()
		setState({})

		if p2 <= 0 then
			return nil
		end

		local v = SegmentSelectorWidth / (WaveformWidth + WaveformPadding) / p2

		local audioWaveform = Instance.new("Folder")
		audioWaveform.Name = "AudioWaveform"

		local audioPlayer = Instance.new("AudioPlayer")
		audioPlayer.Asset = assetIdAsContent(p) -- inferred equivalent call
		audioPlayer.Parent = audioWaveform
		audioWaveform.Parent = LocalPlayer:WaitForChild("PlayerGui")

		local v2 = false

		local function generate() -- 1 equivalent call inferred from this helper
			if v2 or not audioPlayer.IsReady then
				return
			end

			task.spawn(function()
				local success, result = pcall(function()
					return audioPlayer:GetWaveformAsync(
						NumberRange.new(0, audioPlayer.TimeLength),
						v * audioPlayer.TimeLength
					)
				end)

				if not v2 and success then
					setState(normalizeWaveform(result))
				end
			end)
		end

		local isReadyChangedConnection = audioPlayer:GetPropertyChangedSignal("IsReady"):Connect(generate)

		if audioPlayer.IsReady then
			generate() -- inferred equivalent call
		end

		return function()
			v2 = true
			isReadyChangedConnection:Disconnect()
			audioWaveform:Destroy()
		end
	end, { p, p2 })

	return state
end

return useAudioWaveform
