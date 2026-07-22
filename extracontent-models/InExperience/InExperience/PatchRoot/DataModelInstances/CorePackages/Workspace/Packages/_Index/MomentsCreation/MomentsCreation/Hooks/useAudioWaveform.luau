local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Players = game:GetService("Players")
local React = require(MomentsCreationParent.React)
local useEffect = React.useEffect
local Constants = require(MomentsCreation.Constants)
local LocalPlayer = Players.LocalPlayer
local SegmentSelectorWidth = Constants.AudioWaveform.SegmentSelectorWidth
local WaveformWidth = Constants.AudioWaveform.WaveformWidth
local WaveformPadding = Constants.AudioWaveform.WaveformPadding

local function assetIdAsContent(n1: number) -- line: 28
	return `rbxassetid://{ n1 }`
end
local function normalizeWaveform(t1: {[any]: any}) -- line: 32
	local n2 = 0
	local t2 = {}

	for _, v19 in t1 do
		local v20 = math.max(0, v19)

		table.insert(t2, v20)
		n2 = math.max(n2, v20)
	end

	if n2 == 0 then
		return t2
	end

	local t3 = {}

	for _, v23 in t2 do
		table.insert(t3, v23 / n2)
	end

	return t3
end
local function useAudioWaveform(n3: number, n4: number) -- line: 55
	-- upvalues: React (copy), useEffect (copy), SegmentSelectorWidth (copy), WaveformWidth (copy), WaveformPadding (copy), LocalPlayer (copy), normalizeWaveform (copy)
	local v26, v27 = React.useState({})

	useEffect(function() -- line: 63
		-- upvalues: v27 (copy), n4 (copy), SegmentSelectorWidth (copy), WaveformWidth (copy), WaveformPadding (copy), n3 (copy), LocalPlayer (copy), normalizeWaveform (copy)
		v27({})

		if n4 <= 0 then
			return nil
		end

		local v28 = SegmentSelectorWidth / (WaveformWidth + WaveformPadding) / n4
		local Folder = Instance.new("Folder")

		Folder.Name = "AudioWaveform"

		local AudioPlayer = Instance.new("AudioPlayer")

		AudioPlayer.Asset = `rbxassetid://{ n3 }`
		AudioPlayer.Parent = Folder
		Folder.Parent = LocalPlayer:WaitForChild("PlayerGui")

		local u31 = false

		local function generate() -- line: 83
			-- upvalues: u31 (ref), AudioPlayer (copy), v28 (copy), v27 (copy), normalizeWaveform (copy)
			if u31 or not AudioPlayer.IsReady then
				return
			end

			task.spawn(function() -- line: 87
				-- upvalues: AudioPlayer (copy), v28 (copy), u31 (ref), v27 (copy), normalizeWaveform (copy)
				local ok, result = pcall(function() -- line: 88
					-- upvalues: AudioPlayer (copy), v28 (copy)
					return AudioPlayer:GetWaveformAsync(NumberRange.new(0, AudioPlayer.TimeLength), v28 * AudioPlayer.TimeLength)
				end)

				if not u31 and ok then
					v27((normalizeWaveform(result)))
				end
			end)
		end

		local connection = AudioPlayer:GetPropertyChangedSignal("IsReady"):Connect(generate)

		if AudioPlayer.IsReady and not u31 and AudioPlayer.IsReady then
			task.spawn(function() -- line: 87
				-- upvalues: AudioPlayer (copy), v28 (copy), u31 (ref), v27 (copy), normalizeWaveform (copy)
				local ok, result = pcall(function() -- line: 88
					-- upvalues: AudioPlayer (copy), v28 (copy)
					return AudioPlayer:GetWaveformAsync(NumberRange.new(0, AudioPlayer.TimeLength), v28 * AudioPlayer.TimeLength)
				end)

				if not u31 and ok then
					v27((normalizeWaveform(result)))
				end
			end)
		end

		return function() -- line: 106
			-- upvalues: u31 (ref), connection (copy), Folder (copy)
			u31 = true
			connection:Disconnect()
			Folder:Destroy()
		end
	end, {
		n3,
		n4
	})

	return v26
end

return useAudioWaveform
