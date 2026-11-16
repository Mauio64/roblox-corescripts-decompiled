local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local View = Foundation.View

local useAudioWaveform = require(MomentsCreation.Hooks.useAudioWaveform)
local useTokens = Foundation.Hooks.useTokens

local Constants = require(MomentsCreation.Constants)

local WaveformWidth = Constants.AudioWaveform.WaveformWidth
local WaveformPadding = Constants.AudioWaveform.WaveformPadding
local WaveformMinHeight = Constants.AudioWaveform.WaveformMinHeight

local function Waveform(props, ref)
	local v = useTokens()
	local v2 = useAudioWaveform(props.audioAssetId, props.videoDuration)

	React.useEffect(function()
		if v2 and #v2 > 0 then
			props.onWaveformReady()
		end
	end, { props.audioAssetId, props.onWaveformReady, v2 })

	return React.createElement(View, {
		Position = props.position,
		tag = "align-x-left align-y-center anchor-center-left auto-x size-0-full row",
		ZIndex = props.zIndex,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, WaveformPadding)
		},
		ref = ref
	}, Dash.map(v2, function(p: number, layoutOrder: number)
		return React.createElement(View, {
			key = layoutOrder,
			LayoutOrder = layoutOrder,
			Size = UDim2.new(0, WaveformWidth, p, WaveformMinHeight),
			backgroundStyle = v.Color.Content.Muted,
			tag = "radius-circle"
		})
	end))
end

return React.forwardRef(Waveform)
