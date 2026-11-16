local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local ReactIs = require(parent.ReactIs)
local Foundation = require(parent.Foundation)
local Components = require(parent.DictationCore.Components)

local function DictationWaveformOverlay(props)
	local createElement = React.createElement
	local view = Foundation.View
	local v = {
		tag = "position-center-left anchor-center-left",
		Size = UDim2.new(1, 0, 0, props.lineHeight),
		Visible = props.isAudioActiveBinding,
		ZIndex = 3
	}

	local createElement2 = React.createElement
	local waveform = Components.Waveform
	local v2 = {
		isActive = props.isAudioActive,
		audioDeviceInput = props.audioDeviceInput,
		onSample = props.onWaveformSample,
		transcribedSamplesBinding = props.transcribedSamplesBinding,
		transparencyValue = 0
	}
	local transparencyValue

	if ReactIs.isBinding(props.transparencyValue) then
		transparencyValue = props.transparencyValue
	end

	v2.transparencyValue = transparencyValue
	return createElement(view, v, { Waveform = createElement2(waveform, v2) })
end

return React.memo(DictationWaveformOverlay)
