local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local React = require(GenericAbuseReportingParent.React)
local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)

require(script.Parent.AbuseSheetFlowTypes)

local CommentNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.CommentNode)
local ConfirmationNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.ConfirmationNode)
local ListNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.ListNode)
local ListNodeV2 = require(GenericAbuseReporting.BeduiV2.Components.Nodes.ListNodeV2)
local ParagraphNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.ParagraphNode)
local ReviewNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.ReviewNode)
local TelemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local FFlagSupportSubmissionOnAllReportNodes = require(GenericAbuseReportingParent.SharedFlags).FFlagSupportSubmissionOnAllReportNodes
local FFlagAbuseReportMenuV2 = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportMenuV2
local FFlagAbuseReportInExpPlayerListV3 = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportInExpPlayerListV3
local FFlagAbuseReportSceneSelectionSubmitTracking = require(GenericAbuseReporting.Flags.FFlagAbuseReportSceneSelectionSubmitTracking)

local function ContentNode(t1: {[any]: any}) -- line: 45
	-- upvalues: useAbuseReportAnalytics (copy), React (copy), FFlagAbuseReportMenuV2 (copy), ListNodeV2 (copy), ListNode (copy), Dash (copy), CommentNode (copy), ConfirmationNode (copy), FFlagSupportSubmissionOnAllReportNodes (copy), ParagraphNode (copy), ReviewNode (copy), GenericAbuseReporting (copy), FFlagAbuseReportSceneSelectionSubmitTracking (copy), FFlagAbuseReportInExpPlayerListV3 (copy), TelemetryEventType (copy)
	local sendEvent = useAbuseReportAnalytics().sendEvent

	if t1.node.type == "list" then
		local v22 = if not t1.store then nil else t1.store[t1.node.storeAs]
		local v23 = if type(v22) ~= "table" then nil else v22.id

		return React.createElement(if not FFlagAbuseReportMenuV2 then ListNode else ListNodeV2, Dash.join(t1.node, {
			initialValue = v23,
			isSubmitting = t1.isSubmitting,
			onNext = function(_: string, p1) -- line: 56
				-- upvalues: t1 (copy)
				if t1.onNext then
					t1.onNext({
						store = if not t1.node.storeAs then {} else {
							[t1.node.storeAs] = p1
						}
					})
				end
			end
		}))
	end

	if t1.node.type == "comment" then
		local v24 = if not t1.store then nil else t1.store[t1.node.storeAs]

		return React.createElement(CommentNode, Dash.join(t1.node, {
			initialValue = v24,
			isSubmitting = t1.isSubmitting,
			onNext = function(s2: string) -- line: 74
				-- upvalues: t1 (copy)
				if t1.onNext then
					t1.onNext({
						store = if not t1.node.storeAs then {} else {
							[t1.node.storeAs] = s2
						}
					})
				end
			end
		}))
	end

	if t1.node.type == "confirmation" then
		return React.createElement(ConfirmationNode, Dash.join(t1.node, {
			isSubmitting = if not FFlagSupportSubmissionOnAllReportNodes then nil else t1.isSubmitting,
			onNext = t1.onNext and function() -- line: 88
				-- upvalues: t1 (copy)
				t1.onNext({})
			end or nil
		}))
	end

	if t1.node.type == "paragraph" then
		return React.createElement(ParagraphNode, Dash.join(t1.node, {
			isSubmitting = if not FFlagSupportSubmissionOnAllReportNodes then nil else t1.isSubmitting,
			onNext = t1.onNext and function() -- line: 98
				-- upvalues: t1 (copy)
				t1.onNext({})
			end or nil
		}))
	end

	if FFlagAbuseReportMenuV2 and t1.node.type == "review" then
		return React.createElement(ReviewNode, Dash.join(t1.node, {
			isSubmitting = if not FFlagSupportSubmissionOnAllReportNodes then nil else t1.isSubmitting,
			onNext = t1.onNext and function() -- line: 108
				-- upvalues: t1 (copy)
				t1.onNext({})
			end or nil
		}))
	end

	if FFlagAbuseReportMenuV2 and t1.node.type == "inExpChatSelection" then
		local InExpChatSelectionNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.InExpChatSelectionNode)
		local v26 = if not t1.store then nil else t1.store[t1.node.storeAs]
		local v27 = if type(v26) ~= "table" then nil else v26.id

		return React.createElement(InExpChatSelectionNode, Dash.join(t1.node, {
			initialValue = v27,
			isSubmitting = t1.isSubmitting,
			goBack = t1.goBack,
			onNext = function(_: string?, p2) -- line: 123
				-- upvalues: t1 (copy)
				if t1.onNext then
					t1.onNext({
						store = if not t1.node.storeAs then {} else {
							[t1.node.storeAs] = p2
						}
					})
				end
			end
		}))
	end

	if FFlagAbuseReportMenuV2 and t1.node.type == "inExpConfirmation" then
		local InExpConfirmationNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.InExpConfirmationNode)

		return React.createElement(InExpConfirmationNode, Dash.join(t1.node, {
			isSubmitting = t1.isSubmitting,
			onNext = t1.onNext and function(t2: {[any]: any}) -- line: 140
				-- upvalues: t1 (copy)
				t1.onNext({
					store = if not t1.node.storeAs then {} else {
						[t1.node.storeAs.didBlockUser] = t2.didBlockUser,
						[t1.node.storeAs.didMuteUser] = t2.didMuteUser
					}
				})
			end or nil
		}))
	end

	if FFlagAbuseReportMenuV2 and t1.node.type == "inExpSceneSelection" then
		local InExpSceneSelectionNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.InExpSceneSelectionNode)

		return React.createElement(InExpSceneSelectionNode, Dash.join(t1.node, {
			onNext = if not t1.onNext then nil else function() -- line: 158
				-- upvalues: t1 (copy)
				t1.onNext({})
			end,
			goBack = t1.goBack,
			onExternalSubmit = if not FFlagAbuseReportSceneSelectionSubmitTracking then nil else t1.onExternalSubmit
		}))
	end

	if FFlagAbuseReportInExpPlayerListV3 and t1.node.type == "inExpUserSelection" then
		local InExpUserSelectionNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.InExpUserSelectionNode)
		local v31 = if not t1.store then nil else t1.store[t1.node.storeAs]
		local v32 = if type(v31) ~= "table" then nil else v31.id

		return React.createElement(InExpUserSelectionNode, Dash.join(t1.node, {
			initialValue = v32,
			isSubmitting = t1.isSubmitting,
			onNext = if not t1.onNext then nil else function(_: string?, p3) -- line: 176
				-- upvalues: t1 (copy)
				if t1.onNext then
					t1.onNext({
						store = if not t1.node.storeAs then {} else {
							[t1.node.storeAs] = p3
						}
					})
				end
			end,
			goBack = t1.goBack
		}))
	end

	sendEvent({
		sub_event_type = TelemetryEventType.Error,
		error_detail = {
			error_message = `Unknown node type: { t1.node.type }`
		}
	})

	return React.createElement(React.Fragment)
end

return React.memo(ContentNode)
