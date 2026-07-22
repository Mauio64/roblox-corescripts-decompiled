local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local React = require(GenericAbuseReportingParent.React)

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local ListNodeV2 = require(GenericAbuseReporting.BeduiV2.Components.Nodes.ListNodeV2)
local VoiceSpeakingIcon = require(GenericAbuseReporting.BeduiV2.Components.Shared.VoiceSpeakingIcon)
local voiceSpeakingSignals = require(GenericAbuseReporting.BeduiV2.Utils.Signals.voiceSpeakingSignals)

local function InExpUserSelectionNode(p1) -- line: 20
	-- upvalues: Dash (copy), voiceSpeakingSignals (copy), React (copy), VoiceSpeakingIcon (copy), ListNodeV2 (copy)
	local trailingAccessories = p1.trailingAccessories
	local v11 = Dash.join(p1, {
		trailingAccessories = Dash.None
	})
	local v12 = voiceSpeakingSignals.useVoiceSpeakingStore()
	local v13 = React.useCallback(function(p2) -- line: 26
		-- upvalues: trailingAccessories (copy), React (copy), VoiceSpeakingIcon (copy), v12 (copy)
		if not trailingAccessories or #trailingAccessories == 0 then
			return nil
		end

		local t1 = {}

		for v16, v17 in trailingAccessories do
			if v17.type == "voiceSpeakingIndicator" then
				t1[v16] = React.createElement(VoiceSpeakingIcon, {
					isSpeakingSignal = v12.getIsSpeaking(p2.id)
				})
			end
		end

		return React.createElement(React.Fragment, nil, t1)
	end, {
		trailingAccessories,
		v12
	})

	return React.createElement(ListNodeV2, Dash.join(v11, {
		renderTrailingAccessory = v13
	}))
end

return React.memo(InExpUserSelectionNode)
