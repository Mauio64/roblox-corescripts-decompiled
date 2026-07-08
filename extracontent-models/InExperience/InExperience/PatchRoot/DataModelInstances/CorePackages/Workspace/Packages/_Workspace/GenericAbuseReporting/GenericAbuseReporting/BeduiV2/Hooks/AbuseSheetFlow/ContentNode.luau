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
local FFlagAbuseReportConfigStoreResolver = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportConfigStoreResolver

local function ContentNode(t1: {[any]: any}) -- line: 45
	-- upvalues: useAbuseReportAnalytics (copy), FFlagAbuseReportConfigStoreResolver (copy), React (copy), FFlagAbuseReportMenuV2 (copy), ListNodeV2 (copy), ListNode (copy), Dash (copy), CommentNode (copy), ConfirmationNode (copy), FFlagSupportSubmissionOnAllReportNodes (copy), ParagraphNode (copy), ReviewNode (copy), GenericAbuseReporting (copy), TelemetryEventType (copy)
	local sendEvent = useAbuseReportAnalytics().sendEvent

	if t1.node.type == "list" then
		local v22

		if FFlagAbuseReportConfigStoreResolver then
			local v21 = if not t1.store then nil else t1.store[t1.node.storeAs]

			v22 = if type(v21) ~= "table" then nil else v21.id
		else
			v22 = if not t1.data then nil else t1.data[t1.node.formKey]
		end

		return React.createElement(if not FFlagAbuseReportMenuV2 then ListNode else ListNodeV2, Dash.join(t1.node, {
			initialValue = v22,
			isSubmitting = t1.isSubmitting,
			onNext = function(s1: string, p1) -- line: 61
				-- upvalues: t1 (copy), FFlagAbuseReportConfigStoreResolver (copy)
				if t1.onNext then
					if FFlagAbuseReportConfigStoreResolver then
						t1.onNext({
							store = if not t1.node.storeAs then {} else {
								[t1.node.storeAs] = p1
							}
						})

						return
					end

					local t2 = {}
					local t3 = {}

					if t1.node.formKey and t1.node.formKey ~= "" then
						t2[t1.node.formKey] = s1
					end

					if t1.node.storeSelectionAsContext and t1.node.storeSelectionAsContext ~= "" then
						t3[t1.node.storeSelectionAsContext] = p1
					end

					t1.onNext({
						data = t2,
						context = t3
					})
				end
			end
		}))
	end

	if t1.node.type == "comment" then
		local v23 = if not FFlagAbuseReportConfigStoreResolver then if not t1.data then nil else t1.data[t1.node.formKey] else if not t1.store then nil else t1.store[t1.node.storeAs]

		return React.createElement(CommentNode, Dash.join(t1.node, {
			initialValue = v23,
			isSubmitting = t1.isSubmitting,
			onNext = function(s2: string) -- line: 99
				-- upvalues: t1 (copy), FFlagAbuseReportConfigStoreResolver (copy)
				if t1.onNext then
					if FFlagAbuseReportConfigStoreResolver then
						t1.onNext({
							store = if not t1.node.storeAs then {} else {
								[t1.node.storeAs] = s2
							}
						})

						return
					end

					local t4 = {}

					if t1.node.formKey and t1.node.formKey ~= "" then
						t4[t1.node.formKey] = s2
					end

					t1.onNext({
						data = t4
					})
				end
			end
		}))
	end

	if t1.node.type == "confirmation" then
		return React.createElement(ConfirmationNode, Dash.join(t1.node, {
			isSubmitting = if not FFlagSupportSubmissionOnAllReportNodes then nil else t1.isSubmitting,
			onNext = t1.onNext and function() -- line: 125
				-- upvalues: t1 (copy)
				t1.onNext({})
			end or nil
		}))
	end

	if t1.node.type == "paragraph" then
		return React.createElement(ParagraphNode, Dash.join(t1.node, {
			isSubmitting = if not FFlagSupportSubmissionOnAllReportNodes then nil else t1.isSubmitting,
			onNext = t1.onNext and function() -- line: 135
				-- upvalues: t1 (copy)
				t1.onNext({})
			end or nil
		}))
	end

	if FFlagAbuseReportMenuV2 and t1.node.type == "review" then
		return React.createElement(ReviewNode, Dash.join(t1.node, {
			isSubmitting = if not FFlagSupportSubmissionOnAllReportNodes then nil else t1.isSubmitting,
			onNext = t1.onNext and function() -- line: 145
				-- upvalues: t1 (copy)
				t1.onNext({})
			end or nil
		}))
	end

	if FFlagAbuseReportMenuV2 and t1.node.type == "inExpChatSelection" then
		local InExpChatSelectionNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.InExpChatSelectionNode)
		local v26

		if FFlagAbuseReportConfigStoreResolver then
			local v25 = if not t1.store then nil else t1.store[t1.node.storeAs]

			v26 = if type(v25) ~= "table" then nil else v25.id
		else
			v26 = if not t1.data then nil else t1.data[t1.node.formKey]
		end

		return React.createElement(InExpChatSelectionNode, Dash.join(t1.node, {
			initialValue = v26,
			isSubmitting = t1.isSubmitting,
			goBack = t1.goBack,
			onNext = function(s3: string?, p2) -- line: 165
				-- upvalues: t1 (copy), FFlagAbuseReportConfigStoreResolver (copy)
				if t1.onNext then
					if FFlagAbuseReportConfigStoreResolver then
						t1.onNext({
							store = if not t1.node.storeAs then {} else {
								[t1.node.storeAs] = p2
							}
						})

						return
					end

					local t5 = {}
					local t6 = {}

					if t1.node.formKey and t1.node.formKey ~= "" then
						t5[t1.node.formKey] = s3
					end

					if t1.node.storeSelectionAsContext and t1.node.storeSelectionAsContext ~= "" then
						t6[t1.node.storeSelectionAsContext] = p2
					end

					t1.onNext({
						data = t5,
						context = t6
					})
				end
			end
		}))
	end

	if FFlagAbuseReportMenuV2 and t1.node.type == "inExpConfirmation" then
		local InExpConfirmationNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.InExpConfirmationNode)

		return React.createElement(InExpConfirmationNode, Dash.join(t1.node, {
			isSubmitting = t1.isSubmitting,
			onNext = t1.onNext and function(t7: {[any]: any}) -- line: 197
				-- upvalues: t1 (copy)
				t1.onNext({
					store = if not t1.node.storeAs then {} else {
						[t1.node.storeAs.didBlockUser] = t7.didBlockUser,
						[t1.node.storeAs.didMuteUser] = t7.didMuteUser
					}
				})
			end or nil
		}))
	end

	if FFlagAbuseReportMenuV2 and t1.node.type == "inExpSceneSelection" then
		local InExpSceneSelectionNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.InExpSceneSelectionNode)

		return React.createElement(InExpSceneSelectionNode, Dash.join(t1.node, {
			onNext = if not t1.onNext then nil else function() -- line: 215
				-- upvalues: t1 (copy)
				t1.onNext({})
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
