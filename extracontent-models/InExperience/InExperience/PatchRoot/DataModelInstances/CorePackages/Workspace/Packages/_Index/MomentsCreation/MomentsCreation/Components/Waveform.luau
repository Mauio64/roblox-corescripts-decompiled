local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Dash = require(MomentsCreationParent.Dash)
local Foundation = require(MomentsCreationParent.Foundation)
local React = require(MomentsCreationParent.React)
local View = Foundation.View
local useAudioWaveform = require(MomentsCreation.Hooks.useAudioWaveform)
local useTokens = Foundation.Hooks.useTokens
local Constants = require(MomentsCreation.Constants)
local WaveformWidth = Constants.AudioWaveform.WaveformWidth
local WaveformPadding = Constants.AudioWaveform.WaveformPadding
local WaveformMinHeight = Constants.AudioWaveform.WaveformMinHeight

local function Waveform(t1: {[any]: any}, p1) -- line: 33
	-- upvalues: useTokens (copy), useAudioWaveform (copy), React (copy), View (copy), WaveformPadding (copy), Dash (copy), WaveformWidth (copy), WaveformMinHeight (copy)
	local v16 = useTokens()
	local v17 = useAudioWaveform(t1.audioAssetId, t1.videoDuration)

	React.useEffect(function() -- line: 37
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
	}, Dash.map(v17, function(n1: number, n2: number) -- line: 55
		-- upvalues: React (copy), View (copy), WaveformWidth (copy), WaveformMinHeight (copy), v16 (copy)
		return React.createElement(View, {
			tag = "radius-circle",
			key = n2,
			LayoutOrder = n2,
			Size = UDim2.new(0, WaveformWidth, n1, WaveformMinHeight),
			backgroundStyle = v16.Color.Content.Muted
		})
	end))
end

return React.forwardRef(Waveform)
