local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local view = Foundation.View

local useAudioWaveform = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useAudioWaveform")
local useTokens = Foundation.Hooks.useTokens

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")

local waveformWidth = Constants.AudioWaveform.WaveformWidth
local waveformPadding = Constants.AudioWaveform.WaveformPadding
local waveformMinHeight = Constants.AudioWaveform.WaveformMinHeight

local function Waveform(props, p2)
	local v5 = useTokens()
	local v6 = useAudioWaveform(props.audioAssetId, props.videoDuration)

	React.useEffect(function()
		if v6 and #v6 > 0 then
			props.onWaveformReady()
		end
	end, { props.audioAssetId, props.onWaveformReady, v6 })

	return React.createElement(view, {
		Position = props.position,
		tag = "align-x-left align-y-center anchor-center-left auto-x size-0-full row",
		ZIndex = props.zIndex,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, waveformPadding)
		},
		ref = p2
	}, Dash.map(v6, function(p3, p4)
		return React.createElement(view, {
			key = p4,
			LayoutOrder = p4,
			Size = UDim2.new(0, waveformWidth, p3, waveformMinHeight),
			backgroundStyle = v5.Color.Content.Muted,
			tag = "radius-circle"
		})
	end))
end

return React.forwardRef(Waveform)
