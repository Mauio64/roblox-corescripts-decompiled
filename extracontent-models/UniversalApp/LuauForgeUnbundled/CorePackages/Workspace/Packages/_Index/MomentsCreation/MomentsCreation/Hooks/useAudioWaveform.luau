local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local useEffect = React.useEffect

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")

local localPlayer = Players.LocalPlayer

local segmentSelectorWidth = Constants.AudioWaveform.SegmentSelectorWidth
local waveformWidth = Constants.AudioWaveform.WaveformWidth
local waveformPadding = Constants.AudioWaveform.WaveformPadding

local function assetIdAsContent(p2)
	return `rbxassetid://{p2}`
end

local function normalizeWaveform(result)
	local result2 = {}
	local maxValue = 0

	for k, item in result do
		local v5 = math.max(0, item)
		table.insert(result2, v5)
		maxValue = math.max(maxValue, v5)
	end

	if maxValue == 0 then
		return result2
	end

	local result3 = {}

	for k, v5 in result2 do
		table.insert(result3, v5 / maxValue)
	end

	return result3
end

local function useAudioWaveform(p2, p3)
	local state, setState = React.useState({})

	useEffect(function()
		setState({})

		if p3 <= 0 then
			return nil
		end

		local v5 = segmentSelectorWidth / (waveformWidth + waveformPadding) / p3

		local audioWaveform = Instance.new("Folder")
		audioWaveform.Name = "AudioWaveform"

		local audioPlayer = Instance.new("AudioPlayer")
		audioPlayer.Asset = `rbxassetid://{p2}`
		audioPlayer.Parent = audioWaveform
		audioWaveform.Parent = localPlayer:WaitForChild("PlayerGui")

		local v6 = false

		local function generate()
			if v6 or not audioPlayer.IsReady then
				return
			end

			task.spawn(function()
				local success, result = pcall(function()
					return audioPlayer:GetWaveformAsync(
						NumberRange.new(0, audioPlayer.TimeLength),
						v5 * audioPlayer.TimeLength
					)
				end)

				if not v6 and success then
					setState(normalizeWaveform(result))
				end
			end)
		end

		local isReadyChangedConnection = audioPlayer:GetPropertyChangedSignal("IsReady"):Connect(generate)

		if audioPlayer.IsReady and not v6 and audioPlayer.IsReady then
			task.spawn(function()
				local success, result = pcall(function()
					return audioPlayer:GetWaveformAsync(
						NumberRange.new(0, audioPlayer.TimeLength),
						v5 * audioPlayer.TimeLength
					)
				end)

				if not v6 and success then
					setState(normalizeWaveform(result))
				end
			end)
		end

		return function()
			v6 = true
			isReadyChangedConnection:Disconnect()
			audioWaveform:Destroy()
		end
	end, { p2, p3 })

	return state
end

return useAudioWaveform
