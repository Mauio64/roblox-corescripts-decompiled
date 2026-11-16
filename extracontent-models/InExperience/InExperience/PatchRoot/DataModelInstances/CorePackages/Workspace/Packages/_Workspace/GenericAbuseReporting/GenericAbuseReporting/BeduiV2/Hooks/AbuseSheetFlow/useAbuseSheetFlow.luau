local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Dash = require(parent.Dash)
require(parent.LuauPolyfill)
local Promise = require(parent.Promise)
local React = require(parent.React)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
require(script.Parent.AbuseSheetFlowTypes)
local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local ContentNode = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.ContentNode)
local reducer = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.reducer)
local getInitialState = reducer.getInitialState
local reducer2 = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.reducer)
local configResolvers = require(GenericAbuseReporting.BeduiV2.Utils.Resolver.configResolvers)
local resolveArConfig = configResolvers.resolveArConfig
local resolveStartNode = require(GenericAbuseReporting.BeduiV2.Utils.Resolver.resolveStartNode)
local resolveStartNode2 = resolveStartNode.resolveStartNode
local sendReport = require(GenericAbuseReporting.BeduiV2.Api.sendReport)
local useOpenLink = require(GenericAbuseReporting.BeduiV2.Hooks.useOpenLink)

local getNewRunId = reducer2.getNewRunId
local reducer3 = reducer2.reducer
local selectStore = reducer2.selectStore
local sendAnalyticsEvent = analyticsService.sendAnalyticsEvent
local telemetryEventType = analyticsService.TelemetryEventType
local linkOpenedSource = analyticsService.LinkOpenedSource
local submitSource = analyticsService.SubmitSource
local formatErrorDetailForAnalytics = analyticsService.formatErrorDetailForAnalytics
local SharedFlags = require(parent.SharedFlags)
local FFlagAbuseReportSubmissionTargetV4 = SharedFlags.FFlagAbuseReportSubmissionTargetV4
local FFlagAbuseReportImproveErrorEvents = require(GenericAbuseReporting.Flags.FFlagAbuseReportImproveErrorEvents)

local function getSubmissionTargetTelemetry(target)
	if type(target) ~= "table" then
		return {}
	end

	if target.type == "default" then
		return { target_type = "default" }
	end

	if target.type ~= "clientAction" then
		return {}
	end

	local client_action_name

	if type(target.name) == "string" then
		client_action_name = target.name
	end

	return { target_type = "clientAction", client_action_name = client_action_name }
end

local function useAbuseSheetAnalytics(data, abuseVector, analyticsTargetId: string?, config_name: string?)
	return (React.useCallback(function(p)
		local unixTimestampMillis = DateTime.now().UnixTimestampMillis
		local total_duration = not data.openTime and 0 or unixTimestampMillis - data.openTime
		local mapped = Dash.map(data.stack, function(p2)
			return p2.nodeId
		end)

		sendAnalyticsEvent({
			run_id = data.runId,
			user_id = data.userId,
			abuse_vector = abuseVector,
			target_id = analyticsTargetId,
			total_duration = total_duration,
			path = mapped,
			config_name = config_name
		}, p)
	end, { data.stack, data.openTime, data.runId, abuseVector, analyticsTargetId, config_name }))
end

local function useAbuseSheetFlow(props, props2)
	local startNodeId = React.useMemo(function()
		if props then
			return (resolveStartNode2(props))
		end

		return "root"
	end, { props })
	local v, v2 = React.useReducer(reducer3, nil, function()
		return getInitialState(getNewRunId(), DateTime.now().UnixTimestampMillis, startNodeId)
	end)

	local v3 = useOpenLink()

	local v4 = useRoactService(RoactNetworking)

	local abuseVector = props2.abuseVector
	local analyticsTargetId = props2.analyticsTargetId
	local v5

	if props then
		v5 = props.name
	end

	local v6 = useAbuseSheetAnalytics(v, abuseVector, analyticsTargetId, v5)

	local store = React.useMemo(function()
		return selectStore(v)
	end, { v })

	local config = React.useMemo(function()
		if props then
			return resolveArConfig(props, {
				attribute = props.attributes,
				resources = props.resources or {},
				store = store
			})
		end

		return nil
	end, { props, store })

	local ref = React.useRef(true)
	local ref2 = React.useRef(false)

	local v7 = props2.attemptTrigger == "onFirstAction"

	local ref3 = React.useRef("none")
	local ref4 = React.useRef(v6)
	ref4.current = v6

	local ref5 = React.useRef(v.submissionState)
	ref5.current = v.submissionState

	local function setPendingInlineAlert(p) -- 7 equivalent calls inferred from this helper
		if props2.inlineAlertController then
			props2.inlineAlertController.setInlineAlert(p)
		end
	end

	React.useEffect(function()
		return function()
			if ref3.current ~= "started" then
				return
			end

			ref3.current = "completed"
			local current = ref4.current
			local v8

			if ref5.current == "completed" then
				v8 = { sub_event_type = telemetryEventType.ReportCompleted }
			else
				v8 = { sub_event_type = telemetryEventType.ReportAbandoned }
			end

			current(v8)
		end
	end, {})

	React.useEffect(function()
		if props2.open and not ref.current then
			v2({
				type = "reset",
				payload = {
					runId = getNewRunId(),
					initialEnterTime = DateTime.now().UnixTimestampMillis,
					startNodeId = startNodeId
				}
			})
			setPendingInlineAlert(nil) -- inferred equivalent call
			ref2.current = false
		end

		ref.current = false

		if props2.open and not v7 then
			v6({ sub_event_type = telemetryEventType.ReportStarted })
			ref3.current = "started"
		end
	end, { props2.open })

	React.useLayoutEffect(function()
		if not props or #v.stack > 1 then
			return
		end

		local v8 = v.stack[1]

		if v8 and v8.nodeId == startNodeId then
			return
		end

		local unixTimestampMillis = DateTime.now().UnixTimestampMillis
		v2({
			type = "reset",
			payload = {
				runId = v.runId,
				initialEnterTime = v.openTime or unixTimestampMillis,
				startNodeId = startNodeId
			}
		})
	end, { props, startNodeId })

	local last = Dash.last(v.stack)
	local node2 = config and config.nodes and last and config.nodes[last.nodeId]

	React.useEffect(function()
		if not props2.open or ref2.current or not props then
			return
		end

		if last then
			if last.nodeId then
				if config and config.nodes then
					if not node2 then
						local v8 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }
						local error_detail

						if FFlagAbuseReportImproveErrorEvents then
							error_detail = {
								error_message = "No config found for current nodeId",
								error_metadata = { node_id = last.nodeId }
							}
						else
							error_detail = {
								error_message = `No config found for current nodeId: {last.nodeId}`
							}
						end

						v8.error_detail = error_detail
						v6(v8)

						ref2.current = true
					end
				else
					v6({
						sub_event_type = telemetryEventType.Error,
						error_detail = {
							error_message = "Abuse sheet flow config or nodes is nil."
						}
					})

					ref2.current = true
				end
			else
				v6({
					sub_event_type = telemetryEventType.Error,
					error_detail = {
						error_message = "Current page has no nodeId in abuse sheet flow."
					}
				})

				ref2.current = true
			end
		else
			v6({
				sub_event_type = telemetryEventType.Error,
				error_detail = { error_message = "No current page found in abuse sheet flow." }
			})

			ref2.current = true
		end
	end, { props2.open, props, config, last, node2, v6 })

	local function notifyFinish()
		if props2.onFinish then
			props2.onFinish({
				didSubmit = ref5.current == "completed"
			})
		end

		if ref3.current == "started" then
			ref3.current = "completed"
			local current = ref4.current
			local v8

			if ref5.current == "completed" then
				v8 = { sub_event_type = telemetryEventType.ReportCompleted }
			else
				v8 = { sub_event_type = telemetryEventType.ReportAbandoned }
			end

			current(v8)
		end
	end

	local function handleClose() -- 3 equivalent calls inferred from this helper
		notifyFinish()
		props2.onClose()
	end

	local function reset(inlineAlert)
		v2({
			type = "reset",
			payload = {
				runId = getNewRunId(),
				initialEnterTime = DateTime.now().UnixTimestampMillis,
				startNodeId = startNodeId
			}
		})
		setPendingInlineAlert(inlineAlert) -- inferred equivalent call
		ref3.current = "none"
	end

	React.useEffect(function()
		if not (config and node2) or v.navigationState ~= "gotoNext" and v.navigationState ~= "gotoFailure" then
			return
		end

		local last2 = Dash.last(v.stack)

		if not (last2 and last2.nodeId) then
			warn("Navigation triggered but current page or nodeId is invalid")
			return
		end

		local node = config.nodes[last2.nodeId]

		if not node then
			warn(`Navigation triggered but no config found for nodeId: {last2.nodeId}`)
			return
		end

		local function handleNextSimple(nodeId)
			if nodeId then
				local unixTimestampMillis = DateTime.now().UnixTimestampMillis
				local inlineAlert

				if type(nodeId) == "table" then
					inlineAlert = nodeId.inlineAlert
				end

				if type(nodeId) == "string" then
					v2({
						type = "gotoNode",
						payload = { nodeId = nodeId, enterTime = unixTimestampMillis }
					})
					setPendingInlineAlert(nil) -- inferred equivalent call
				elseif type(nodeId) == "table" and nodeId.type == "goto" then
					if nodeId.replace then
						v2({
							type = "replaceAndGotoNode",
							payload = { nodeId = nodeId.nodeId, enterTime = unixTimestampMillis }
						})
						setPendingInlineAlert(inlineAlert) -- inferred equivalent call
					else
						v2({
							type = "gotoNode",
							payload = { nodeId = nodeId.nodeId, enterTime = unixTimestampMillis }
						})
						setPendingInlineAlert(nil) -- inferred equivalent call
					end
				elseif type(nodeId) == "table" and nodeId.type == "link" then
					ref4.current({
						sub_event_type = telemetryEventType.LinkOpened,
						link_detail = { href = nodeId.href, source = linkOpenedSource.NextAction }
					})

					v3("", nodeId.href)
					handleClose() -- inferred equivalent call
				elseif type(nodeId) == "table" and nodeId.type == "close" then
					handleClose() -- inferred equivalent call
				elseif type(nodeId) == "table" and nodeId.type == "reset" then
					notifyFinish()
					reset(inlineAlert)
				else
					warn(`Unknown next type: {typeof(nodeId)}, value: {nodeId}`)
					handleClose() -- inferred equivalent call
				end
			else
				warn("handleNextSimple called with nil next value")
				props2.onClose()
			end
		end

		local submission = config.submission
		local target = submission and submission.target

		local v8 = not FFlagAbuseReportSubmissionTargetV4 and {} or getSubmissionTargetTelemetry(target)
		local target_failure_reason = nil

		local function onSubmitForm()
			if FFlagAbuseReportSubmissionTargetV4 then
				if type(target) == "table" and target.type == "default" then
					return sendReport(v4, "abuse-reporting/v1/abuse-report", submission.data)
				end

				if type(target) ~= "table" or target.type ~= "clientAction" then
					target_failure_reason = "unsupported-submission-target"
					return Promise.reject("Unsupported submission target")
				end

				local name = target.name
				local v9 = props2.clientActionHandlers and props2.clientActionHandlers[name]

				if v9 then
					return (v9(submission))
				end

				target_failure_reason = "missing-client-action-handler"
				return Promise.reject(`Missing client action handler: {name}`)
			end

			if props2.onCustomSubmit then
				if props2.abuseVector ~= AbuseVector.MomentsFeed then
					return (props2.onCustomSubmit(submission))
				end

				local v9 = props2.onCustomSubmit(submission)

				if v9 ~= nil then
					return v9
				end
			end

			return sendReport(v4, submission.endpoint, submission.data)
		end

		local v9

		if v.navigationState == "gotoFailure" then
			v9 = node.nextOnFailure
		else
			v9 = node2.next
		end

		if v9 then
			if type(v9) == "table" and v9.type == "submitForm" then
				local unixTimestampMillis = DateTime.now().UnixTimestampMillis
				v6({
					sub_event_type = telemetryEventType.Submit,
					submit_detail = {
						submit_source = submitSource.Flow,
						target_type = v8.target_type,
						client_action_name = v8.client_action_name
					}
				})

				v2({ type = "startedSubmission" })
				local v10

				if FFlagAbuseReportSubmissionTargetV4 then
					v10 = Promise.try(function()
						return (onSubmitForm())
					end)
				else
					v10 = onSubmitForm()
				end

				v10:andThen(function(p)
					v2({ type = "completedSubmission" })
					v6({
						sub_event_type = telemetryEventType.SubmitSuccess,
						submit_detail = {
							report_id = p.responseBody and p.responseBody.reportId,
							submit_api_duration = DateTime.now().UnixTimestampMillis - unixTimestampMillis,
							submit_source = submitSource.Flow,
							target_type = v8.target_type,
							client_action_name = v8.client_action_name
						}
					})

					ref5.current = "completed"
					handleNextSimple(v9.onSuccess)
				end):catch(function(p)
					v2({ type = "submissionFailed" })
					v6({
						sub_event_type = telemetryEventType.SubmitFail,
						submit_detail = {
							submit_api_duration = DateTime.now().UnixTimestampMillis - unixTimestampMillis,
							submit_source = submitSource.Flow,
							target_type = v8.target_type,
							client_action_name = v8.client_action_name,
							target_failure_reason = target_failure_reason
						}
					})

					local v11 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }
					local error_detail

					if FFlagAbuseReportImproveErrorEvents then
						error_detail = formatErrorDetailForAnalytics("submitReport failed", p)
					else
						error_detail = {
							error_message = "submitReport: " .. Dash.pretty(p, { depth = 10 })
						}
					end

					v11.error_detail = error_detail
					v6(v11)

					ref5.current = "failed"

					if v9.onFailure then
						handleNextSimple(v9.onFailure)
					end
				end)
			else
				handleNextSimple(v9)
			end
		else
			warn("Navigation target is nil, closing")
			props2.onClose()
		end
	end, { v.navigationState })
	local canGoBack

	if #v.stack > 1 then
		canGoBack = v.submissionState ~= "completed"
	else
		canGoBack = false
	end

	local function goBack()
		if not (config and node2 and last) then
			return
		end

		local unixTimestampMillis = DateTime.now().UnixTimestampMillis

		if canGoBack then
			v2({ type = "goBack" })
			setPendingInlineAlert(nil) -- inferred equivalent call
			v6({
				sub_event_type = telemetryEventType.NodeDone,
				node_done_detail = {
					node_id = last.nodeId,
					node_type = node2.type,
					node_duration = unixTimestampMillis - last.enterTime,
					node_exit_reason = "back"
				}
			})
		end
	end

	local v8 = node2 and node2.next ~= nil
	local v9 = node2 and node2.nextOnFailure ~= nil
	local function onNext(p)
		if not (config and node2 and last) then
			return
		end

		if ref3.current == "none" then
			ref3.current = "started"
			ref4.current({ sub_event_type = telemetryEventType.ReportStarted })
		end

		local unixTimestampMillis = DateTime.now().UnixTimestampMillis
		v2({
			type = "updateDataAndNavigateNext",
			payload = {
				store = not (p and p.store) and {} or p.store,
				expectedFromNodeId = last.nodeId
			}
		})

		v6({
			sub_event_type = telemetryEventType.NodeDone,
			node_done_detail = {
				node_id = last.nodeId,
				node_type = node2.type,
				node_duration = unixTimestampMillis - last.enterTime,
				node_exit_reason = "next"
			}
		})
	end

	local function onFailure()
		if not (config and node2 and last) then
			return
		end

		local unixTimestampMillis = DateTime.now().UnixTimestampMillis
		v2({
			type = "navigateFailure",
			payload = { expectedFromNodeId = last.nodeId }
		})

		v6({
			sub_event_type = telemetryEventType.NodeDone,
			node_done_detail = {
				node_id = last.nodeId,
				node_type = node2.type,
				node_duration = unixTimestampMillis - last.enterTime,
				node_exit_reason = "failure"
			}
		})
	end

	local dismissInlineAlert = React.useCallback(function()
		setPendingInlineAlert(nil) -- inferred equivalent call
	end, {})

	local analytics = React.useMemo(function()
		return { sendEvent = v6 }
	end, { v6 })

	if not (config and node2 and last) then
		return nil
	end

	local v10 = {
		config = config,
		canGoBack = canGoBack,
		goBack = goBack,
		reset = reset,
		isSubmitting = v.submissionState == "submitting",
		display = config.display,
		onClose = handleClose,
		currentPageElement = 0,
		currentNodeId = 0,
		currentNodeType = 0,
		navigationDirection = 0,
		analytics = 0,
		pendingInlineAlert = 0,
		dismissInlineAlert = 0
	}

	local createElement = React.createElement
	local v11 = {
		key = last.nodeId,
		node = node2,
		onNext = 0,
		onFailure = 0,
		goBack = 0,
		onExternalSubmit = 0,
		store = 0,
		isSubmitting = 0
	}

	if not v8 then
		onNext = nil
	end

	v11.onNext = onNext

	if not v9 then
		onFailure = nil
	end

	v11.onFailure = onFailure
	v11.goBack = goBack

	function v11.onExternalSubmit(submit_source)
		ref4.current({
			sub_event_type = telemetryEventType.Submit,
			submit_detail = { submit_source = submit_source }
		})

		v2({ type = "completedSubmission" })
		ref5.current = "completed"
		ref4.current({
			sub_event_type = telemetryEventType.SubmitSuccess,
			submit_detail = { submit_source = submit_source }
		})
	end
	v11.store = store
	v11.isSubmitting = v.submissionState == "submitting"
	v10.currentPageElement = createElement(ContentNode, v11)

	v10.currentNodeId = last.nodeId
	v10.currentNodeType = node2.type
	v10.navigationDirection = v.lastNavigationDirection
	v10.analytics = analytics
	local pendingInlineAlert

	if props2.inlineAlertController then
		pendingInlineAlert = props2.inlineAlertController.pendingInlineAlert
	end

	v10.pendingInlineAlert = pendingInlineAlert

	v10.dismissInlineAlert = dismissInlineAlert
	return v10
end

return useAbuseSheetFlow
