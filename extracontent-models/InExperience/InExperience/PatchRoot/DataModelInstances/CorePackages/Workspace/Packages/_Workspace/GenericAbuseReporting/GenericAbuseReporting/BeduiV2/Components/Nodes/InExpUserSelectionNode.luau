local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local View = Foundation.View

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local ListNodeV2 = require(GenericAbuseReporting.BeduiV2.Components.Nodes.ListNodeV2)
local RecentlyLeftBadge = require(GenericAbuseReporting.BeduiV2.Components.Shared.RecentlyLeftBadge)
local recentlyLeftSignals = require(GenericAbuseReporting.BeduiV2.Utils.Signals.recentlyLeftSignals)
local VoiceSpeakingIcon = require(GenericAbuseReporting.BeduiV2.Components.Shared.VoiceSpeakingIcon)
local voiceSpeakingSignals = require(GenericAbuseReporting.BeduiV2.Utils.Signals.voiceSpeakingSignals)

local function InExpUserSelectionNode(p)
	local trailingAccessories = p.trailingAccessories
	local joined = Dash.join(p, { trailingAccessories = Dash.None })

	local v = voiceSpeakingSignals.useVoiceSpeakingStore()

	local v2 = SignalsReact.useSignalState(recentlyLeftSignals.getRecentlyLeftIds())

	local renderTrailingAccessory = React.useCallback(function(p2)
		if not trailingAccessories or #trailingAccessories == 0 then
			return nil
		end

		local children = {}

		for k, trailingAccessory in trailingAccessories do
			if trailingAccessory.type == "voiceSpeakingIndicator" then
				table.insert(
					children,
					React.createElement(VoiceSpeakingIcon, {
						isSpeakingSignal = v.getIsSpeaking(p2.id),
						layoutOrder = k
					})
				)
			elseif trailingAccessory.type == "recentlyLeftIndicator" and v2[p2.id] then
				table.insert(
					children,
					React.createElement(RecentlyLeftBadge, {
						text = trailingAccessory.text,
						layoutOrder = k
					})
				)
			end
		end

		if next(children) == nil then
			return nil
		end

		return React.createElement(View, { tag = "row align-y-center gap-small auto-xy" }, children)
	end, { trailingAccessories, v, v2 })

	return React.createElement(ListNodeV2, Dash.join(joined, {
		renderTrailingAccessory = renderTrailingAccessory
	}))
end

return React.memo(InExpUserSelectionNode)
