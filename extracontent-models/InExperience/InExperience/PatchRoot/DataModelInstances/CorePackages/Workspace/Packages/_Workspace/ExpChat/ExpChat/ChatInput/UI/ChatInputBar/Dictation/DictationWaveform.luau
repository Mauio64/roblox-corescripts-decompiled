local parent = script:FindFirstAncestor("ExpChat").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local useTokens = Foundation.Hooks.useTokens

local Waveform = require(script.Parent.Parent.Waveform)
require(script.Parent.useTranscribedSamples)

local binding = React.createBinding({})

local function isItemTranscribed(transcribed, itemIdx: number): boolean -- 1 equivalent call inferred from this helper
	for _, item in transcribed do
		if item.startIdx <= itemIdx and itemIdx <= item.endIdx then
			return true
		end
	end

	return false
end

local function fadeInTransparency(p: number, p2: number)
	if p2 <= p then
		return 0
	end

	return 1 - p / p2
end

local function compositeWithFade(p: number, fade: number) -- 1 equivalent call inferred from this helper
	return p + fade * (1 - p)
end

local function DictationWaveform(props)
	local v = useTokens()
	local color3 = v.Color.Content.Emphasis.Color3
	local color3_2 = v.Color.Content.Muted.Color3
	local color3_3 = v.Color.System.Success.Color3

	local transcribedSamplesBinding = props.transcribedSamplesBinding or binding
	local transparencyValue = props.transparencyValue
	local fadeInTicks = props.fadeInTicks or 10

	local bindBarStyle = React.useCallback(function(sample2)
		local v2 = { sample = sample2, transcribed = transcribedSamplesBinding }

		if transparencyValue ~= nil then
			v2.fade = transparencyValue
		end

		return React.joinBindings(v2):map(function(data)
			local sample = data.sample
			local transcribed = data.transcribed
			local color, transparency

			if sample.age == nil then
				color = color3_2
				transparency = 0.85
			else
				if isItemTranscribed(transcribed, sample.itemIdx) then -- inferred equivalent call
					color = color3_3
				else
					color = color3
				end

				local age = sample.age
				local v3 = fadeInTicks

				if v3 <= age then
					transparency = 0
				else
					transparency = 1 - age / v3
				end
			end

			if data.fade ~= nil then
				transparency = compositeWithFade(transparency, data.fade) -- inferred equivalent call
			end

			return { color = color, transparency = transparency }
		end)
	end, { color3, color3_2, color3_3, transcribedSamplesBinding, transparencyValue, fadeInTicks })

	return React.createElement(Waveform, {
		isActive = props.isActive,
		audioDeviceInput = props.audioDeviceInput,
		onSample = props.onSample,
		bindBarStyle = bindBarStyle
	})
end

return React.memo(DictationWaveform)
