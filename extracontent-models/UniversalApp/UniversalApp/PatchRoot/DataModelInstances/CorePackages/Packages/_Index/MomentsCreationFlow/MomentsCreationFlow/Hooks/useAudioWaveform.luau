local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local Players = game:GetService("Players")
local React = require(MomentsCreationFlowParent.React)
local useEffect = React.useEffect
local Constants = require(MomentsCreationFlow.Constants)
local LocalPlayer = Players.LocalPlayer
local SegmentSelectorWidth = Constants.AudioWaveform.SegmentSelectorWidth
local WaveformWidth = Constants.AudioWaveform.WaveformWidth
local WaveformPadding = Constants.AudioWaveform.WaveformPadding

local function assetIdAsContent(n1: number) -- line: 18
	return `rbxassetid://{ n1 }`
end
local function normalizeWaveform(t1: {[any]: any}) -- line: 22
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
local function useAudioWaveform(n3: number, n4: number) -- line: 47
	-- upvalues: React (copy), SegmentSelectorWidth (copy), WaveformWidth (copy), WaveformPadding (copy), useEffect (copy), LocalPlayer (copy), normalizeWaveform (copy)
	local v26, v27 = React.useState({})
	local v28 = React.useRef(nil)
	local v29 = React.useMemo(function() -- line: 51
		-- upvalues: SegmentSelectorWidth (copy), WaveformWidth (copy), WaveformPadding (copy), n4 (copy)
		return SegmentSelectorWidth / (WaveformWidth + WaveformPadding) / n4
	end, { n4 })
	local v30 = React.useMemo(function() -- line: 55
		-- upvalues: n3 (copy)
		return `rbxassetid://{ n3 }`
	end, { n3 })

	useEffect(function() -- line: 59
		-- upvalues: v30 (copy), v28 (copy), LocalPlayer (copy)
		local Folder = Instance.new("Folder")

		Folder.Name = "AudioWaveform"

		local AudioPlayer = Instance.new("AudioPlayer")

		AudioPlayer.Asset = v30
		AudioPlayer.Parent = Folder
		v28.current = AudioPlayer
		Folder.Parent = LocalPlayer:WaitForChild("PlayerGui")

		return function() -- line: 70
			-- upvalues: Folder (copy)
			Folder:Destroy()
		end
	end, {
		n3,
		n4
	})

	local v31 = React.useCallback(function() -- line: 78
		-- upvalues: v28 (copy), v29 (copy), v27 (copy), normalizeWaveform (copy)
		local current = v28.current

		if current and current.IsReady then
			task.spawn(function() -- line: 82
				-- upvalues: current (copy), v29 (copy), v27 (copy), normalizeWaveform (copy)
				local WaveformAsync = current:GetWaveformAsync(NumberRange.new(0, current.TimeLength), v29 * current.TimeLength)

				v27((normalizeWaveform(WaveformAsync)))
			end)
		end
	end, {})

	useEffect(function() -- line: 92
		-- upvalues: v28 (copy), v31 (copy)
		local current = v28.current
		local t4 = {}

		if current then
			table.insert(t4, current:GetPropertyChangedSignal("IsReady"):Connect(v31))
		end

		return function() -- line: 99
			-- upvalues: t4 (copy)
			for _, v39 in t4 do
				v39:Disconnect()
			end
		end
	end, {})

	return v26
end

return useAudioWaveform
