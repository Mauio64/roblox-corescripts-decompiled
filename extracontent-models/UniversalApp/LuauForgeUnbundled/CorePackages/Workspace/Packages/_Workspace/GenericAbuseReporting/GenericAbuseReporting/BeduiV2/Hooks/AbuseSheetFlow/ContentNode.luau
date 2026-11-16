local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local AbuseReportAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/AbuseReportAnalyticsContext")
local analyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local CommentNode = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Nodes/CommentNode")
local ConfirmationNode = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Nodes/ConfirmationNode")
local ListNodeV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Nodes/ListNodeV2")
local ParagraphNode = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Nodes/ParagraphNode")
local ReviewNode = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Nodes/ReviewNode")

local telemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics

local fFlagSupportSubmissionOnAllReportNodes = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagSupportSubmissionOnAllReportNodes
local fFlagAbuseReportInExpPlayerListV3 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagAbuseReportInExpPlayerListV3
local FFlagAbuseReportImproveErrorEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportImproveErrorEvents")

local function ContentNode(props)
	local sendEvent = useAbuseReportAnalytics().sendEvent

	if props.node.type == "list" then
		local v5 = if props.store then props.store[props.node.storeAs] else nil
		local v6 = if type(v5) == "table" then v5.id else nil
		return React.createElement(ListNodeV2, Dash.join(props.node, {
			initialValue = v6,
			isSubmitting = props.isSubmitting,
			onNext = function(p2, p3)
				if props.onNext then
					local onNext = props.onNext
					local v8

					if props.node.storeAs then
						v8 = {}
						v8[props.node.storeAs] = p3
					else
						v8 = {}
					end

					onNext({ store = v8 })
				end
			end
		}))
	elseif props.node.type == "comment" then
		local v5 = if props.store then props.store[props.node.storeAs] else nil
		return React.createElement(CommentNode, Dash.join(props.node, {
			initialValue = v5,
			isSubmitting = props.isSubmitting,
			onNext = function(p2)
				if props.onNext then
					local onNext = props.onNext
					local v7

					if props.node.storeAs then
						v7 = {}
						v7[props.node.storeAs] = p2
					else
						v7 = {}
					end

					onNext({ store = v7 })
				end
			end
		}))
	elseif props.node.type == "confirmation" then
		local createElement = React.createElement

		local join = Dash.join
		local node = props.node
		local v7 = if fFlagSupportSubmissionOnAllReportNodes then props.isSubmitting else nil
		return createElement(ConfirmationNode, join(node, {
			isSubmitting = v7,
			onNext = props.onNext and function()
				props.onNext({})
			end or nil
		}))
	elseif props.node.type == "paragraph" then
		local createElement = React.createElement

		local join = Dash.join
		local node = props.node
		local v7 = if fFlagSupportSubmissionOnAllReportNodes then props.isSubmitting else nil
		return createElement(ParagraphNode, join(node, {
			isSubmitting = v7,
			onNext = props.onNext and function()
				props.onNext({})
			end or nil
		}))
	elseif props.node.type == "review" then
		local createElement = React.createElement

		local join = Dash.join
		local node = props.node
		local v7 = if fFlagSupportSubmissionOnAllReportNodes then props.isSubmitting else nil
		return createElement(ReviewNode, join(node, {
			isSubmitting = v7,
			onNext = props.onNext and function()
				props.onNext({})
			end or nil
		}))
	elseif props.node.type == "inExpChatSelection" then
		local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Nodes/InExpChatSelectionNode")
		local v5 = if props.store then props.store[props.node.storeAs] else nil
		local v6 = if type(v5) == "table" then v5.id else nil
		return React.createElement(module11, Dash.join(props.node, {
			initialValue = v6,
			isSubmitting = props.isSubmitting,
			goBack = props.goBack,
			onNext = function(p2, p3)
				if props.onNext then
					local onNext = props.onNext
					local v8

					if props.node.storeAs then
						v8 = {}
						v8[props.node.storeAs] = p3
					else
						v8 = {}
					end

					onNext({ store = v8 })
				end
			end
		}))
	else
		if props.node.type == "inExpConfirmation" then
			local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Nodes/InExpConfirmationNode")
			return React.createElement(module11, Dash.join(props.node, {
				isSubmitting = props.isSubmitting,
				onNext = props.onNext and function(p2)
					local onNext = props.onNext
					local v6

					if props.node.storeAs then
						v6 = {}
						v6[props.node.storeAs.didBlockUser] = p2.didBlockUser
						v6[props.node.storeAs.didMuteUser] = p2.didMuteUser
					else
						v6 = {}
					end

					onNext({ store = v6 })
				end or nil
			}))
		end

		if props.node.type == "inExpSceneSelection" then
			local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Nodes/InExpSceneSelectionNode")
			return React.createElement(module11, Dash.join(props.node, {
				onNext = props.onNext and function()
					props.onNext({})
				end or nil,
				onFailure = props.onFailure,
				goBack = props.goBack,
				onExternalSubmit = props.onExternalSubmit
			}))
		end

		if fFlagAbuseReportInExpPlayerListV3 and props.node.type == "inExpUserSelection" then
			local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Nodes/InExpUserSelectionNode")
			local v5 = if props.store then props.store[props.node.storeAs] else nil
			local v6 = if type(v5) == "table" then v5.id else nil
			return React.createElement(module11, Dash.join(props.node, {
				initialValue = v6,
				isSubmitting = props.isSubmitting,
				onNext = props.onNext and function(p2, p3)
					if props.onNext then
						local onNext = props.onNext
						local v8

						if props.node.storeAs then
							v8 = {}
							v8[props.node.storeAs] = p3
						else
							v8 = {}
						end

						onNext({ store = v8 })
					end
				end or nil,
				goBack = props.goBack
			}))
		else
			local v5 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }

			local v6 = if FFlagAbuseReportImproveErrorEvents then {
				error_message = "Unknown node type",
				error_metadata = { node_type = tostring(props.node.type) }
			} else {
				error_message = `Unknown node type: {props.node.type}`
			}
			v5.error_detail = v6
			sendEvent(v5)

			return React.createElement(React.Fragment)
		end
	end
end

return React.memo(ContentNode)
