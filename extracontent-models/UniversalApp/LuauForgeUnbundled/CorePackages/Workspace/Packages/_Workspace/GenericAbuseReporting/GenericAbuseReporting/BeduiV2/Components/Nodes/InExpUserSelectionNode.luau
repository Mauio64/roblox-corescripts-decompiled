local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SignalsReact")

local view = Foundation.View

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local ListNodeV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Nodes/ListNodeV2")
local RecentlyLeftBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Shared/RecentlyLeftBadge")
local recentlyLeftSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Signals/recentlyLeftSignals")
local VoiceSpeakingIcon = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Shared/VoiceSpeakingIcon")
local voiceSpeakingSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Signals/voiceSpeakingSignals")

local function InExpUserSelectionNode(p2)
	local trailingAccessories = p2.trailingAccessories
	local joined = Dash.join(p2, { trailingAccessories = Dash.None })

	local v5 = voiceSpeakingSignals.useVoiceSpeakingStore()

	local v6 = SignalsReact.useSignalState(recentlyLeftSignals.getRecentlyLeftIds())

	local v7 = React.useCallback(function(p3)
		if not trailingAccessories or #trailingAccessories == 0 then
			return nil
		end

		local children = {}

		for k, trailingAccessory in trailingAccessories do
			if trailingAccessory.type == "voiceSpeakingIndicator" then
				table.insert(
					children,
					React.createElement(VoiceSpeakingIcon, {
						isSpeakingSignal = v5.getIsSpeaking(p3.id),
						layoutOrder = k
					})
				)
			elseif trailingAccessory.type == "recentlyLeftIndicator" and v6[p3.id] then
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

		return React.createElement(view, {
			tag = "row align-y-center gap-small auto-xy"
		}, children)
	end, { trailingAccessories, v5, v6 })

	return React.createElement(ListNodeV2, Dash.join(joined, {
		renderTrailingAccessory = v7
	}))
end

return React.memo(InExpUserSelectionNode)
