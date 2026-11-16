local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
require(script.Parent.AbuseSheetFlowTypes)
local CommentNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.CommentNode)
local ConfirmationNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.ConfirmationNode)
local ListNodeV2 = require(GenericAbuseReporting.BeduiV2.Components.Nodes.ListNodeV2)
local ParagraphNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.ParagraphNode)
local ReviewNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.ReviewNode)

local telemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics

local SharedFlags = require(parent.SharedFlags)
local FFlagSupportSubmissionOnAllReportNodes = SharedFlags.FFlagSupportSubmissionOnAllReportNodes
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAbuseReportInExpPlayerListV3 = SharedFlags2.FFlagAbuseReportInExpPlayerListV3
local FFlagAbuseReportImproveErrorEvents = require(GenericAbuseReporting.Flags.FFlagAbuseReportImproveErrorEvents)

local function ContentNode(props)
	local sendEvent = useAbuseReportAnalytics().sendEvent

	if props.node.type == "list" then
		local v

		if props.store then
			v = props.store[props.node.storeAs]
		end

		local initialValue

		if type(v) == "table" then
			initialValue = v.id
		end

		return React.createElement(ListNodeV2, Dash.join(props.node, {
			initialValue = initialValue,
			isSubmitting = props.isSubmitting,
			onNext = function(_: string, p)
				if props.onNext then
					local onNext = props.onNext
					local store

					if props.node.storeAs then
						store = {}
						store[props.node.storeAs] = p
					else
						store = {}
					end

					onNext({ store = store })
				end
			end
		}))
	elseif props.node.type == "comment" then
		local initialValue

		if props.store then
			initialValue = props.store[props.node.storeAs]
		end

		return React.createElement(CommentNode, Dash.join(props.node, {
			initialValue = initialValue,
			isSubmitting = props.isSubmitting,
			onNext = function(p: string)
				if props.onNext then
					local onNext = props.onNext
					local store

					if props.node.storeAs then
						store = {}
						store[props.node.storeAs] = p
					else
						store = {}
					end

					onNext({ store = store })
				end
			end
		}))
	elseif props.node.type == "confirmation" then
		local createElement = React.createElement

		local join = Dash.join
		local node = props.node
		local isSubmitting

		if FFlagSupportSubmissionOnAllReportNodes then
			isSubmitting = props.isSubmitting
		end

		return createElement(ConfirmationNode, join(node, {
			isSubmitting = isSubmitting,
			onNext = props.onNext and function()
				props.onNext({})
			end or nil
		}))
	elseif props.node.type == "paragraph" then
		local createElement = React.createElement

		local join = Dash.join
		local node = props.node
		local isSubmitting

		if FFlagSupportSubmissionOnAllReportNodes then
			isSubmitting = props.isSubmitting
		end

		return createElement(ParagraphNode, join(node, {
			isSubmitting = isSubmitting,
			onNext = props.onNext and function()
				props.onNext({})
			end or nil
		}))
	elseif props.node.type == "review" then
		local createElement = React.createElement

		local join = Dash.join
		local node = props.node
		local isSubmitting

		if FFlagSupportSubmissionOnAllReportNodes then
			isSubmitting = props.isSubmitting
		end

		return createElement(ReviewNode, join(node, {
			isSubmitting = isSubmitting,
			onNext = props.onNext and function()
				props.onNext({})
			end or nil
		}))
	elseif props.node.type == "inExpChatSelection" then
		local InExpChatSelectionNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.InExpChatSelectionNode)
		local v

		if props.store then
			v = props.store[props.node.storeAs]
		end

		local initialValue

		if type(v) == "table" then
			initialValue = v.id
		end

		return React.createElement(InExpChatSelectionNode, Dash.join(props.node, {
			initialValue = initialValue,
			isSubmitting = props.isSubmitting,
			goBack = props.goBack,
			onNext = function(_: string?, p)
				if props.onNext then
					local onNext = props.onNext
					local store

					if props.node.storeAs then
						store = {}
						store[props.node.storeAs] = p
					else
						store = {}
					end

					onNext({ store = store })
				end
			end
		}))
	else
		if props.node.type == "inExpConfirmation" then
			local InExpConfirmationNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.InExpConfirmationNode)
			return React.createElement(InExpConfirmationNode, Dash.join(props.node, {
				isSubmitting = props.isSubmitting,
				onNext = props.onNext and function(p)
					local onNext = props.onNext
					local store

					if props.node.storeAs then
						store = {}
						store[props.node.storeAs.didBlockUser] = p.didBlockUser
						store[props.node.storeAs.didMuteUser] = p.didMuteUser
					else
						store = {}
					end

					onNext({ store = store })
				end or nil
			}))
		end

		if props.node.type == "inExpSceneSelection" then
			local InExpSceneSelectionNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.InExpSceneSelectionNode)
			return React.createElement(InExpSceneSelectionNode, Dash.join(props.node, {
				onNext = props.onNext and function()
					props.onNext({})
				end or nil,
				onFailure = props.onFailure,
				goBack = props.goBack,
				onExternalSubmit = props.onExternalSubmit
			}))
		end

		if FFlagAbuseReportInExpPlayerListV3 and props.node.type == "inExpUserSelection" then
			local InExpUserSelectionNode = require(GenericAbuseReporting.BeduiV2.Components.Nodes.InExpUserSelectionNode)
			local v

			if props.store then
				v = props.store[props.node.storeAs]
			end

			local initialValue

			if type(v) == "table" then
				initialValue = v.id
			end

			return React.createElement(InExpUserSelectionNode, Dash.join(props.node, {
				initialValue = initialValue,
				isSubmitting = props.isSubmitting,
				onNext = props.onNext and function(_: string?, p)
					if props.onNext then
						local onNext = props.onNext
						local store

						if props.node.storeAs then
							store = {}
							store[props.node.storeAs] = p
						else
							store = {}
						end

						onNext({ store = store })
					end
				end or nil,
				goBack = props.goBack
			}))
		else
			local v = { sub_event_type = telemetryEventType.Error, error_detail = 0 }
			local error_detail

			if FFlagAbuseReportImproveErrorEvents then
				error_detail = {
					error_message = "Unknown node type",
					error_metadata = { node_type = tostring(props.node.type) }
				}
			else
				error_detail = {
					error_message = `Unknown node type: {props.node.type}`
				}
			end

			v.error_detail = error_detail
			sendEvent(v)

			return React.createElement(React.Fragment)
		end
	end
end

return React.memo(ContentNode)
