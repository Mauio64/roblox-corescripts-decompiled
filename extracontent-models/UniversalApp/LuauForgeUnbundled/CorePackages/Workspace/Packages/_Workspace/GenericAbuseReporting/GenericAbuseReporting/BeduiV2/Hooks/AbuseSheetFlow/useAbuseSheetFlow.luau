local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/LuauPolyfill")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Promise")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RoactServiceTags").RoactNetworking
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RobloxAppHooks").useRoactService

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/AbuseReportAnalyticsContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")
local analyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService")
local ContentNode = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/ContentNode")
local getInitialState = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/reducer").getInitialState
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/reducer")
local resolveArConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Resolver/configResolvers").resolveArConfig
local resolveStartNode = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Resolver/resolveStartNode").resolveStartNode
local sendReport = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Api/sendReport")
local useOpenLink = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/useOpenLink")

local getNewRunId = module7.getNewRunId
local reducer = module7.reducer
local selectStore = module7.selectStore
local sendAnalyticsEvent = analyticsService.sendAnalyticsEvent
local telemetryEventType = analyticsService.TelemetryEventType
local linkOpenedSource = analyticsService.LinkOpenedSource
local submitSource = analyticsService.SubmitSource
local formatErrorDetailForAnalytics = analyticsService.formatErrorDetailForAnalytics
local fFlagAbuseReportSubmissionTargetV4 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagAbuseReportSubmissionTargetV4
local FFlagAbuseReportImproveErrorEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportImproveErrorEvents")

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

	local v6 = if type(target.name) == "string" then target.name else nil
	return { target_type = "clientAction", client_action_name = v6 }
end

local function useAbuseSheetAnalytics(data, p2, p3, p4)
	return (React.useCallback(function(p5)
		local unixTimestampMillis = DateTime.now().UnixTimestampMillis
		local v5 = not data.openTime and 0 or unixTimestampMillis - data.openTime
		local mapped = Dash.map(data.stack, function(p6)
			return p6.nodeId
		end)

		sendAnalyticsEvent({
			run_id = data.runId,
			user_id = data.userId,
			abuse_vector = p2,
			target_id = p3,
			total_duration = v5,
			path = mapped,
			config_name = p4
		}, p5)
	end, { data.stack, data.openTime, data.runId, p2, p3, p4 }))
end

local function useAbuseSheetFlow(props, props2)
	local v5 = React.useMemo(function()
		if props then
			return (resolveStartNode(props))
		end

		return "root"
	end, { props })
	local v6, v7 = React.useReducer(reducer, nil, function()
		return getInitialState(getNewRunId(), DateTime.now().UnixTimestampMillis, v5)
	end)

	local v8 = useOpenLink()

	local v9 = useRoactService(roactNetworking)

	local abuseVector = props2.abuseVector
	local analyticsTargetId = props2.analyticsTargetId
	local v11 = if props then props.name else nil
	local v12 = useAbuseSheetAnalytics(v6, abuseVector, analyticsTargetId, v11)

	local v13 = React.useMemo(function()
		return selectStore(v6)
	end, { v6 })

	local v14 = React.useMemo(function()
		if props then
			return resolveArConfig(props, {
				attribute = props.attributes,
				resources = props.resources or {},
				store = v13
			})
		end

		return nil
	end, { props, v13 })

	local ref = React.useRef(true)
	local ref2 = React.useRef(false)

	local v15 = props2.attemptTrigger == "onFirstAction"

	local ref3 = React.useRef("none")
	local ref4 = React.useRef(v12)
	ref4.current = v12

	local ref5 = React.useRef(v6.submissionState)
	ref5.current = v6.submissionState

	local function setPendingInlineAlert(p2)
		if props2.inlineAlertController then
			props2.inlineAlertController.setInlineAlert(p2)
		end
	end

	React.useEffect(function()
		return function()
			if ref3.current ~= "started" then
				return
			end

			ref3.current = "completed"
			local current = ref4.current
			local v16 = if ref5.current == "completed" then {
				sub_event_type = telemetryEventType.ReportCompleted
			} else { sub_event_type = telemetryEventType.ReportAbandoned }
			current(v16)
		end
	end, {})

	React.useEffect(function()
		if props2.open and not ref.current then
			v7({
				type = "reset",
				payload = {
					runId = getNewRunId(),
					initialEnterTime = DateTime.now().UnixTimestampMillis,
					startNodeId = v5
				}
			})

			if props2.inlineAlertController then
				props2.inlineAlertController.setInlineAlert(nil)
			end

			ref2.current = false
		end

		ref.current = false

		if props2.open and not v15 then
			v12({ sub_event_type = telemetryEventType.ReportStarted })
			ref3.current = "started"
		end
	end, { props2.open })

	React.useLayoutEffect(function()
		if not props or #v6.stack > 1 then
			return
		end

		local v16 = v6.stack[1]

		if v16 and v16.nodeId == v5 then
			return
		end

		local unixTimestampMillis = DateTime.now().UnixTimestampMillis
		v7({
			type = "reset",
			payload = {
				runId = v6.runId,
				initialEnterTime = v6.openTime or unixTimestampMillis,
				startNodeId = v5
			}
		})
	end, { props, v5 })

	local last = Dash.last(v6.stack)
	local v16 = v14 and v14.nodes and last and v14.nodes[last.nodeId]

	React.useEffect(function()
		if not props2.open or ref2.current or not props then
			return
		end

		if last then
			if last.nodeId then
				if v14 and v14.nodes then
					if not v16 then
						local v18 = {
							sub_event_type = telemetryEventType.Error,
							error_detail = 0
						}

						local v19 = if FFlagAbuseReportImproveErrorEvents then {
							error_message = "No config found for current nodeId",
							error_metadata = { node_id = last.nodeId }
						} else {
							error_message = `No config found for current nodeId: {last.nodeId}`
						}
						v18.error_detail = v19
						v12(v18)

						ref2.current = true
					end
				else
					v12({
						sub_event_type = telemetryEventType.Error,
						error_detail = {
							error_message = "Abuse sheet flow config or nodes is nil."
						}
					})

					ref2.current = true
				end
			else
				v12({
					sub_event_type = telemetryEventType.Error,
					error_detail = {
						error_message = "Current page has no nodeId in abuse sheet flow."
					}
				})

				ref2.current = true
			end
		else
			v12({
				sub_event_type = telemetryEventType.Error,
				error_detail = {
					error_message = "No current page found in abuse sheet flow."
				}
			})

			ref2.current = true
		end
	end, { props2.open, props, v14, last, v16, v12 })

	local function notifyFinish()
		if props2.onFinish then
			props2.onFinish({
				didSubmit = ref5.current == "completed"
			})
		end

		if ref3.current == "started" then
			ref3.current = "completed"
			local current = ref4.current
			local v17 = if ref5.current == "completed" then {
				sub_event_type = telemetryEventType.ReportCompleted
			} else { sub_event_type = telemetryEventType.ReportAbandoned }
			current(v17)
		end
	end

	local function handleClose()
		notifyFinish()
		props2.onClose()
	end

	local function reset(inlineAlert)
		v7({
			type = "reset",
			payload = {
				runId = getNewRunId(),
				initialEnterTime = DateTime.now().UnixTimestampMillis,
				startNodeId = v5
			}
		})

		if props2.inlineAlertController then
			props2.inlineAlertController.setInlineAlert(inlineAlert)
		end

		ref3.current = "none"
	end

	React.useEffect(function()
		if
			not (v14 and v16)
			or v6.navigationState ~= "gotoNext" and v6.navigationState ~= "gotoFailure"
		then
			return
		end

		local last2 = Dash.last(v6.stack)

		if not (last2 and last2.nodeId) then
			warn("Navigation triggered but current page or nodeId is invalid")
			return
		end

		local node = v14.nodes[last2.nodeId]

		if not node then
			warn(`Navigation triggered but no config found for nodeId: {last2.nodeId}`)
			return
		end

		local function handleNextSimple(value)
			if value then
				local unixTimestampMillis = DateTime.now().UnixTimestampMillis
				local inlineAlert = if type(value) == "table" then value.inlineAlert else nil

				if type(value) == "string" then
					v7({
						type = "gotoNode",
						payload = { nodeId = value, enterTime = unixTimestampMillis }
					})

					if props2.inlineAlertController then
						props2.inlineAlertController.setInlineAlert(nil)
					end
				elseif type(value) == "table" and value.type == "goto" then
					if value.replace then
						v7({
							type = "replaceAndGotoNode",
							payload = {
								nodeId = value.nodeId,
								enterTime = unixTimestampMillis
							}
						})

						if props2.inlineAlertController then
							props2.inlineAlertController.setInlineAlert(inlineAlert)
						end
					else
						v7({
							type = "gotoNode",
							payload = {
								nodeId = value.nodeId,
								enterTime = unixTimestampMillis
							}
						})

						if props2.inlineAlertController then
							props2.inlineAlertController.setInlineAlert(nil)
						end
					end
				elseif type(value) == "table" and value.type == "link" then
					ref4.current({
						sub_event_type = telemetryEventType.LinkOpened,
						link_detail = {
							href = value.href,
							source = linkOpenedSource.NextAction
						}
					})

					v8("", value.href)
					notifyFinish()
					props2.onClose()
				elseif type(value) == "table" and value.type == "close" then
					notifyFinish()
					props2.onClose()
				elseif type(value) == "table" and value.type == "reset" then
					notifyFinish()
					reset(inlineAlert)
				else
					warn(`Unknown next type: {typeof(value)}, value: {value}`)
					notifyFinish()
					props2.onClose()
				end
			else
				warn("handleNextSimple called with nil next value")
				props2.onClose()
			end
		end

		local submission = v14.submission
		local target = submission and submission.target

		local v17 = not fFlagAbuseReportSubmissionTargetV4 and {} or getSubmissionTargetTelemetry(target)
		local v18 = nil

		local function onSubmitForm()
			if fFlagAbuseReportSubmissionTargetV4 then
				if type(target) == "table" and target.type == "default" then
					return sendReport(v9, "abuse-reporting/v1/abuse-report", submission.data)
				end

				if type(target) ~= "table" or target.type ~= "clientAction" then
					v18 = "unsupported-submission-target"
					return Promise.reject("Unsupported submission target")
				end

				local name = target.name
				local v19 = props2.clientActionHandlers and props2.clientActionHandlers[name]

				if v19 then
					return v19(submission)
				end

				v18 = "missing-client-action-handler"
				return Promise.reject(`Missing client action handler: {name}`)
			end

			if props2.onCustomSubmit then
				if props2.abuseVector ~= AbuseVector.MomentsFeed then
					return props2.onCustomSubmit(submission)
				end

				local v19 = props2.onCustomSubmit(submission)

				if v19 ~= nil then
					return v19
				end
			end

			return sendReport(v9, submission.endpoint, submission.data)
		end

		local v19 = if v6.navigationState == "gotoFailure" then node.nextOnFailure else v16.next

		if v19 then
			if type(v19) == "table" and v19.type == "submitForm" then
				local unixTimestampMillis = DateTime.now().UnixTimestampMillis
				v12({
					sub_event_type = telemetryEventType.Submit,
					submit_detail = {
						submit_source = submitSource.Flow,
						target_type = v17.target_type,
						client_action_name = v17.client_action_name
					}
				})

				v7({ type = "startedSubmission" })
				local v20

				if fFlagAbuseReportSubmissionTargetV4 then
					v20 = Promise.try(function()
						return (onSubmitForm())
					end)
				else
					v20 = onSubmitForm()
				end

				v20:andThen(function(p2)
					v7({ type = "completedSubmission" })
					v12({
						sub_event_type = telemetryEventType.SubmitSuccess,
						submit_detail = {
							report_id = p2.responseBody and p2.responseBody.reportId,
							submit_api_duration = DateTime.now().UnixTimestampMillis - unixTimestampMillis,
							submit_source = submitSource.Flow,
							target_type = v17.target_type,
							client_action_name = v17.client_action_name
						}
					})

					ref5.current = "completed"
					handleNextSimple(v19.onSuccess)
				end):catch(function(p2)
					v7({ type = "submissionFailed" })
					v12({
						sub_event_type = telemetryEventType.SubmitFail,
						submit_detail = {
							submit_api_duration = DateTime.now().UnixTimestampMillis - unixTimestampMillis,
							submit_source = submitSource.Flow,
							target_type = v17.target_type,
							client_action_name = v17.client_action_name,
							target_failure_reason = v18
						}
					})

					local v22 = {
						sub_event_type = telemetryEventType.Error,
						error_detail = 0
					}

					local v23 = if FFlagAbuseReportImproveErrorEvents then formatErrorDetailForAnalytics("submitReport failed", p2) else {
						error_message = "submitReport: " .. Dash.pretty(p2, {
							depth = 10
						})
					}
					v22.error_detail = v23
					v12(v22)

					ref5.current = "failed"

					if v19.onFailure then
						handleNextSimple(v19.onFailure)
					end
				end)
			else
				handleNextSimple(v19)
			end
		else
			warn("Navigation target is nil, closing")
			props2.onClose()
		end
	end, { v6.navigationState })

	local v17 = #v6.stack > 1 and v6.submissionState ~= "completed"
	local function goBack()
		if not (v14 and v16 and last) then
			return
		end

		local unixTimestampMillis = DateTime.now().UnixTimestampMillis

		if v17 then
			v7({ type = "goBack" })

			if props2.inlineAlertController then
				props2.inlineAlertController.setInlineAlert(nil)
			end

			v12({
				sub_event_type = telemetryEventType.NodeDone,
				node_done_detail = {
					node_id = last.nodeId,
					node_type = v16.type,
					node_duration = unixTimestampMillis - last.enterTime,
					node_exit_reason = "back"
				}
			})
		end
	end

	local v18 = v16 and v16.next ~= nil
	local v19 = v16 and v16.nextOnFailure ~= nil
	local function onNext(p2)
		if not (v14 and v16 and last) then
			return
		end

		if ref3.current == "none" then
			ref3.current = "started"
			ref4.current({ sub_event_type = telemetryEventType.ReportStarted })
		end

		local unixTimestampMillis = DateTime.now().UnixTimestampMillis
		v7({
			type = "updateDataAndNavigateNext",
			payload = {
				store = not (p2 and p2.store) and {} or p2.store,
				expectedFromNodeId = last.nodeId
			}
		})

		v12({
			sub_event_type = telemetryEventType.NodeDone,
			node_done_detail = {
				node_id = last.nodeId,
				node_type = v16.type,
				node_duration = unixTimestampMillis - last.enterTime,
				node_exit_reason = "next"
			}
		})
	end

	local function onFailure()
		if not (v14 and v16 and last) then
			return
		end

		local unixTimestampMillis = DateTime.now().UnixTimestampMillis
		v7({
			type = "navigateFailure",
			payload = { expectedFromNodeId = last.nodeId }
		})

		v12({
			sub_event_type = telemetryEventType.NodeDone,
			node_done_detail = {
				node_id = last.nodeId,
				node_type = v16.type,
				node_duration = unixTimestampMillis - last.enterTime,
				node_exit_reason = "failure"
			}
		})
	end

	local v20 = React.useCallback(function()
		if props2.inlineAlertController then
			props2.inlineAlertController.setInlineAlert(nil)
		end
	end, {})

	local v21 = React.useMemo(function()
		return { sendEvent = v12 }
	end, { v12 })

	if not (v14 and v16 and last) then
		return nil
	end

	local v22 = {
		config = v14,
		canGoBack = v17,
		goBack = goBack,
		reset = reset,
		isSubmitting = v6.submissionState == "submitting",
		display = v14.display,
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
	local v24 = {
		key = last.nodeId,
		node = v16,
		onNext = 0,
		onFailure = 0,
		goBack = 0,
		onExternalSubmit = 0,
		store = 0,
		isSubmitting = 0
	}

	if not v18 then
		onNext = nil
	end

	v24.onNext = onNext

	if not v19 then
		onFailure = nil
	end

	v24.onFailure = onFailure
	v24.goBack = goBack

	function v24.onExternalSubmit(p2)
		ref4.current({
			sub_event_type = telemetryEventType.Submit,
			submit_detail = { submit_source = p2 }
		})

		v7({ type = "completedSubmission" })
		ref5.current = "completed"
		ref4.current({
			sub_event_type = telemetryEventType.SubmitSuccess,
			submit_detail = { submit_source = p2 }
		})
	end
	v24.store = v13
	v24.isSubmitting = v6.submissionState == "submitting"
	v22.currentPageElement = createElement(ContentNode, v24)

	v22.currentNodeId = last.nodeId
	v22.currentNodeType = v16.type
	v22.navigationDirection = v6.lastNavigationDirection
	v22.analytics = v21
	local v25 = if props2.inlineAlertController then props2.inlineAlertController.pendingInlineAlert else nil
	v22.pendingInlineAlert = v25

	v22.dismissInlineAlert = v20
	return v22
end

return useAbuseSheetFlow
