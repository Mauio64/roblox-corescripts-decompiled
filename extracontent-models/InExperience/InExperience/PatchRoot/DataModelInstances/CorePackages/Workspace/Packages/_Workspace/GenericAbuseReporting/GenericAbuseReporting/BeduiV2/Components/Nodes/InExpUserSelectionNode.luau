local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local SignalsReact = require(GenericAbuseReportingParent.SignalsReact)
local View = Foundation.View

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local ListNodeV2 = require(GenericAbuseReporting.BeduiV2.Components.Nodes.ListNodeV2)
local RecentlyLeftBadge = require(GenericAbuseReporting.BeduiV2.Components.Shared.RecentlyLeftBadge)
local recentlyLeftSignals = require(GenericAbuseReporting.BeduiV2.Utils.Signals.recentlyLeftSignals)
local VoiceSpeakingIcon = require(GenericAbuseReporting.BeduiV2.Components.Shared.VoiceSpeakingIcon)
local voiceSpeakingSignals = require(GenericAbuseReporting.BeduiV2.Utils.Signals.voiceSpeakingSignals)

local function InExpUserSelectionNode(p1) -- line: 26
	-- upvalues: Dash (copy), voiceSpeakingSignals (copy), SignalsReact (copy), recentlyLeftSignals (copy), React (copy), VoiceSpeakingIcon (copy), RecentlyLeftBadge (copy), View (copy), ListNodeV2 (copy)
	local trailingAccessories = p1.trailingAccessories
	local v16 = Dash.join(p1, {
		trailingAccessories = Dash.None
	})
	local v17 = voiceSpeakingSignals.useVoiceSpeakingStore()
	local v18 = SignalsReact.useSignalState(recentlyLeftSignals.getRecentlyLeftIds())
	local v19 = React.useCallback(function(p2) -- line: 34
		-- upvalues: trailingAccessories (copy), React (copy), VoiceSpeakingIcon (copy), v17 (copy), v18 (copy), RecentlyLeftBadge (copy), View (copy)
		if not trailingAccessories or #trailingAccessories == 0 then
			return nil
		end

		local t1 = {}

		for v22, v23 in trailingAccessories do
			if v23.type == "voiceSpeakingIndicator" then
				table.insert(t1, React.createElement(VoiceSpeakingIcon, {
					isSpeakingSignal = v17.getIsSpeaking(p2.id),
					layoutOrder = v22
				}))
			elseif v23.type == "recentlyLeftIndicator" and v18[p2.id] then
				table.insert(t1, React.createElement(RecentlyLeftBadge, {
					text = v23.text,
					layoutOrder = v22
				}))
			end
		end

		if next(t1) == nil then
			return nil
		end

		return React.createElement(View, {
			tag = "row align-y-center gap-small auto-xy"
		}, t1)
	end, {
		trailingAccessories,
		v17,
		v18
	})

	return React.createElement(ListNodeV2, Dash.join(v16, {
		renderTrailingAccessory = v19
	}))
end

return React.memo(InExpUserSelectionNode)
