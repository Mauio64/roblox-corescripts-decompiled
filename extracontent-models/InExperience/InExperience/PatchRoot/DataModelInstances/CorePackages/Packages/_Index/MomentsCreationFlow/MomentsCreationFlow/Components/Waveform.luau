local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local Dash = require(MomentsCreationFlowParent.Dash)
local Foundation = require(MomentsCreationFlowParent.Foundation)
local React = require(MomentsCreationFlowParent.React)
local View = Foundation.View
local useAudioWaveform = require(MomentsCreationFlow.Hooks.useAudioWaveform)
local useTokens = Foundation.Hooks.useTokens
local Constants = require(MomentsCreationFlow.Constants)
local WaveformWidth = Constants.AudioWaveform.WaveformWidth
local WaveformPadding = Constants.AudioWaveform.WaveformPadding
local WaveformMinHeight = Constants.AudioWaveform.WaveformMinHeight

local function Waveform(t1: {[any]: any}, p1) -- line: 29
	-- upvalues: useTokens (copy), useAudioWaveform (copy), React (copy), View (copy), WaveformPadding (copy), Dash (copy), WaveformWidth (copy), WaveformMinHeight (copy)
	local v16 = useTokens()
	local v17 = useAudioWaveform(t1.audioAssetId, t1.videoDuration)

	React.useEffect(function() -- line: 33
		-- upvalues: v17 (copy), t1 (copy)
		if v17 and #v17 > 0 then
			t1.onWaveformReady()
		end
	end, {
		t1.audioAssetId,
		t1.onWaveformReady,
		v17
	})

	return React.createElement(View, {
		tag = "align-x-left align-y-center anchor-center-left auto-x size-0-full row",
		Position = t1.position,
		ZIndex = t1.zIndex,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, WaveformPadding)
		},
		ref = p1
	}, Dash.map(v17, function(p2, p3) -- line: 51
		-- upvalues: React (copy), View (copy), WaveformWidth (copy), WaveformMinHeight (copy), v16 (copy)
		return React.createElement(View, {
			tag = "radius-circle",
			key = p3,
			LayoutOrder = p3,
			Size = UDim2.new(0, WaveformWidth, p2, WaveformMinHeight),
			backgroundStyle = v16.Color.Content.Muted
		})
	end))
end

return React.forwardRef(Waveform)
