local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)

require(GenericAbuseReportingParent.LuauPolyfill)

local React = require(GenericAbuseReportingParent.React)
local RoactNetworking = require(GenericAbuseReportingParent.RoactServiceTags).RoactNetworking
local useRoactService = require(GenericAbuseReportingParent.RobloxAppHooks).useRoactService

require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
require(script.Parent.AbuseSheetFlowTypes)
require(GenericAbuseReporting.Enums.AbuseVector)

local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local ContentNode = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.ContentNode)
local getInitialState = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.reducer).getInitialState
local reducer = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.reducer)
local resolveArConfig = require(GenericAbuseReporting.BeduiV2.Utils.Resolver.configResolvers).resolveArConfig
local resolveStartNode = require(GenericAbuseReporting.BeduiV2.Utils.Resolver.resolveStartNode).resolveStartNode
local sendReport = require(GenericAbuseReporting.BeduiV2.Api.sendReport)
local useOpenLink = require(GenericAbuseReporting.BeduiV2.Hooks.useOpenLink)
local getNewRunId = reducer.getNewRunId
local reducer2 = reducer.reducer
local selectStore = reducer.selectStore
local sendAnalyticsEvent = analyticsService.sendAnalyticsEvent
local TelemetryEventType = analyticsService.TelemetryEventType
local FFlagAbuseReportMenuV2 = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportMenuV2
local FFlagFixAnalyticsForDynamicReportV2 = require(GenericAbuseReportingParent.SharedFlags).FFlagFixAnalyticsForDynamicReportV2
local FFlagAbuseReportInlineAlertStateOutsideReducer = require(GenericAbuseReporting.Flags.FFlagAbuseReportInlineAlertStateOutsideReducer)

local function useAbuseSheetAnalytics(p1, p2, s1: string, s2: string?) -- line: 50
	-- upvalues: React (copy), Dash (copy), FFlagAbuseReportMenuV2 (copy), sendAnalyticsEvent (copy)
	return (React.useCallback(function(p3) -- line: 52
		-- upvalues: p1 (copy), Dash (copy), p2 (copy), s1 (copy), FFlagAbuseReportMenuV2 (copy), s2 (copy), sendAnalyticsEvent (copy)
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
		local v64 = not p1.openTime and 0 or UnixTimestampMillis - p1.openTime
		local v65 = Dash.map(p1.stack, function(p4) -- line: 55
			return p4.nodeId
		end)
		local t1 = {
			run_id = p1.runId,
			user_id = p1.userId,
			abuse_vector = p2,
			target_id = s1,
			total_duration = v64,
			path = v65,
			config_name = if not FFlagAbuseReportMenuV2 then nil else s2
		}

		sendAnalyticsEvent(t1, p3)
	end, {
		p1.stack,
		p1.openTime,
		p1.runId,
		p2,
		s1,
		if not FFlagAbuseReportMenuV2 then nil else s2
	}))
end
local function useAbuseSheetFlow(p5, t2: {[any]: any}) -- line: 115
	-- upvalues: React (copy), FFlagAbuseReportMenuV2 (copy), resolveStartNode (copy), reducer2 (copy), getInitialState (copy), getNewRunId (copy), useOpenLink (copy), useRoactService (copy), RoactNetworking (copy), useAbuseSheetAnalytics (copy), selectStore (copy), resolveArConfig (copy), TelemetryEventType (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), sendReport (copy), ContentNode (copy)
	local v31 = React.useMemo(function() -- line: 134
		-- upvalues: FFlagAbuseReportMenuV2 (copy), p5 (copy), resolveStartNode (copy)
		if FFlagAbuseReportMenuV2 and p5 then
			return (resolveStartNode(p5))
		end

		return "root"
	end, { p5 })
	local u34, u35

	if FFlagAbuseReportMenuV2 then
		local v32, v33 = React.useReducer(reducer2, nil, function() -- line: 139
			-- upvalues: getInitialState (copy), getNewRunId (copy), v31 (copy)
			return getInitialState(getNewRunId(), DateTime.now().UnixTimestampMillis, v31)
		end)

		u34 = v32
		u35 = v33
	else
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
		local v37, v38 = React.useReducer(reducer2, getInitialState(getNewRunId(), UnixTimestampMillis, v31))

		u34 = v37
		u35 = v38
	end

	local v39 = useOpenLink()
	local v40 = useRoactService(RoactNetworking)
	local v41 = useAbuseSheetAnalytics(u34, t2.abuseVector, t2.targetId, if not FFlagAbuseReportMenuV2 or not p5 then nil else p5.name)
	local v42 = React.useMemo(function() -- line: 157
		-- upvalues: selectStore (copy), u34 (ref)
		return selectStore(u34)
	end, { u34 })
	local v43 = React.useMemo(function() -- line: 162
		-- upvalues: p5 (copy), resolveArConfig (copy), v42 (copy)
		if not p5 then
			return nil
		end

		return resolveArConfig(p5, {
			attribute = p5.attributes,
			resources = p5.resources or {},
			store = v42
		})
	end, {
		p5,
		v42
	})
	local v44 = React.useRef(true)
	local v45 = React.useRef(false)
	local v46 = FFlagAbuseReportMenuV2 and t2.attemptTrigger == "onFirstAction"
	local v47 = React.useRef("none")
	local v48 = React.useRef(v41)

	v48.current = v41

	local v49 = React.useRef(u34.submissionState)

	v49.current = u34.submissionState

	local function setNonReducerPendingInlineAlert(p6) -- line: 193
		-- upvalues: t2 (copy)
		if t2.inlineAlertController then
			t2.inlineAlertController.setInlineAlert(p6)
		end
	end

	React.useEffect(function() -- line: 201
		-- upvalues: FFlagAbuseReportMenuV2 (copy), v47 (copy), v48 (copy), v49 (copy), TelemetryEventType (copy)
		if not FFlagAbuseReportMenuV2 then
			return
		end

		return function() -- line: 205
			-- upvalues: v47 (copy), v48 (copy), v49 (copy), TelemetryEventType (copy)
			if v47.current ~= "started" then
				return
			end

			v47.current = "completed"
			v48.current(if v49.current ~= "completed" then {
				sub_event_type = TelemetryEventType.ReportAbandoned
			} else {
				sub_event_type = TelemetryEventType.ReportCompleted
			})
		end
	end, {})
	React.useEffect(function() -- line: 223
		-- upvalues: t2 (copy), v44 (copy), getNewRunId (copy), u35 (ref), v31 (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), v45 (copy), FFlagAbuseReportMenuV2 (copy), v46 (copy), v41 (copy), TelemetryEventType (copy), v47 (copy)
		if t2.open and not v44.current then
			local v68 = getNewRunId()
			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

			u35({
				type = "reset",
				payload = {
					runId = v68,
					initialEnterTime = UnixTimestampMillis,
					startNodeId = v31
				}
			})

			if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
				t2.inlineAlertController.setInlineAlert(nil)
			end

			if FFlagFixAnalyticsForDynamicReportV2 then
				v45.current = false
			end
		end

		v44.current = false

		if t2.open and not FFlagAbuseReportMenuV2 or FFlagAbuseReportMenuV2 and t2.open and not v46 then
			v41({
				sub_event_type = TelemetryEventType.ReportStarted
			})

			if FFlagAbuseReportMenuV2 then
				v47.current = "started"
			end
		end
	end, { t2.open })
	React.useLayoutEffect(function() -- line: 270
		-- upvalues: FFlagAbuseReportMenuV2 (copy), p5 (copy), u34 (ref), v31 (copy), u35 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy)
		if not FFlagAbuseReportMenuV2 then
			return
		end

		if not p5 then
			return
		end

		if #u34.stack > 1 then
			return
		end

		local v70 = u34.stack[1]

		if v70 and v70.nodeId == v31 then
			return
		end

		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		u35({
			type = "reset",
			payload = {
				runId = u34.runId,
				initialEnterTime = u34.openTime or UnixTimestampMillis,
				startNodeId = v31,
				inlineAlert = if FFlagAbuseReportInlineAlertStateOutsideReducer then nil else u34.pendingInlineAlert
			}
		})
	end, {
		p5,
		v31
	})

	local v51 = Dash.last(u34.stack)
	local v52 = v43 and (v43.nodes and (v51 and v43.nodes[v51.nodeId]))

	if not FFlagFixAnalyticsForDynamicReportV2 then
		if not v51 then
			v41({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "No current page found in abuse sheet flow."
				}
			})
		elseif not v51.nodeId then
			v41({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Current page has no nodeId in abuse sheet flow."
				}
			})
		end

		if not v43 or not v43.nodes then
			v41({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Abuse sheet flow config or nodes is nil."
				}
			})
		end

		if not v52 then
			v41({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = `No config found for current nodeId: { v51 and v51.nodeId }`
				}
			})
		end
	end

	React.useEffect(function() -- line: 337
		-- upvalues: FFlagFixAnalyticsForDynamicReportV2 (copy), t2 (copy), v45 (copy), p5 (copy), v51 (copy), v41 (copy), TelemetryEventType (copy), v43 (copy), v52 (copy)
		if not FFlagFixAnalyticsForDynamicReportV2 or (not t2.open or v45.current) then
			return
		end

		if not p5 then
			return
		end

		if not v51 then
			v41({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "No current page found in abuse sheet flow."
				}
			})
			v45.current = true

			return
		end

		if not v51.nodeId then
			v41({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Current page has no nodeId in abuse sheet flow."
				}
			})
			v45.current = true

			return
		end

		if not v43 or not v43.nodes then
			v41({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Abuse sheet flow config or nodes is nil."
				}
			})
			v45.current = true

			return
		end

		if not v52 then
			v41({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = `No config found for current nodeId: { v51.nodeId }`
				}
			})
			v45.current = true
		end
	end, {
		t2.open,
		p5,
		v43,
		v51,
		v52,
		v41
	})

	local function notifyFinish() -- line: 374
		-- upvalues: FFlagAbuseReportMenuV2 (copy), t2 (copy), v49 (copy), v47 (copy), v48 (copy), TelemetryEventType (copy)
		if FFlagAbuseReportMenuV2 and t2.onFinish then
			t2.onFinish({
				didSubmit = v49.current == "completed"
			})
		end

		if FFlagAbuseReportMenuV2 and v47.current == "started" then
			v47.current = "completed"
			v48.current(if v49.current ~= "completed" then {
				sub_event_type = TelemetryEventType.ReportAbandoned
			} else {
				sub_event_type = TelemetryEventType.ReportCompleted
			})
		end
	end
	local function handleClose() -- line: 389
		-- upvalues: notifyFinish (copy), t2 (copy), FFlagAbuseReportMenuV2 (copy), u34 (ref), v41 (copy), TelemetryEventType (copy)
		notifyFinish()
		t2.onClose()

		if not FFlagAbuseReportMenuV2 then
			if u34.submissionState ~= "completed" and u34.openTime ~= nil then
				v41({
					sub_event_type = TelemetryEventType.ReportAbandoned
				})

				return
			end

			v41({
				sub_event_type = TelemetryEventType.ReportCompleted
			})
		end
	end
	local function reset(p7) -- line: 405
		-- upvalues: getNewRunId (copy), u35 (ref), v31 (copy), FFlagAbuseReportMenuV2 (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), t2 (copy), v47 (copy)
		local v73 = getNewRunId()
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		u35({
			type = "reset",
			payload = {
				runId = v73,
				initialEnterTime = UnixTimestampMillis,
				startNodeId = v31,
				inlineAlert = if not FFlagAbuseReportMenuV2 or FFlagAbuseReportInlineAlertStateOutsideReducer then nil else p7
			}
		})

		if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
			t2.inlineAlertController.setInlineAlert(p7)
		end

		v47.current = "none"
	end

	React.useEffect(function() -- line: 436
		-- upvalues: v43 (copy), v52 (copy), u34 (ref), Dash (copy), t2 (copy), FFlagAbuseReportMenuV2 (copy), u35 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), v39 (copy), handleClose (copy), notifyFinish (copy), reset (copy), sendReport (copy), v40 (copy), v41 (copy), TelemetryEventType (copy), v49 (copy)
		if not v43 or not v52 then
			return
		end

		if u34.navigationState ~= "gotoNext" then
			return
		end

		local v75 = Dash.last(u34.stack)

		if not v75 or not v75.nodeId then
			warn("Navigation triggered but current page or nodeId is invalid")

			return
		end

		if not v43.nodes[v75.nodeId] then
			warn(`Navigation triggered but no config found for nodeId: { v75.nodeId }`)

			return
		end

		local function handleNextSimple(p8) -- line: 458
			-- upvalues: t2 (copy), FFlagAbuseReportMenuV2 (copy), u35 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), v39 (copy), handleClose (copy), notifyFinish (copy), reset (copy)
			if not p8 then
				warn("handleNextSimple called with nil next value")
				t2.onClose()

				return
			end

			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
			local v87 = if not FFlagAbuseReportMenuV2 or type(p8) ~= "table" then nil else p8.inlineAlert

			if type(p8) == "string" then
				u35({
					type = "gotoNode",
					payload = {
						nodeId = p8,
						enterTime = UnixTimestampMillis
					}
				})

				if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
					t2.inlineAlertController.setInlineAlert(nil)

					return
				end
			elseif type(p8) == "table" and p8.type == "goto" then
				if FFlagAbuseReportMenuV2 and p8.replace then
					u35({
						type = "replaceAndGotoNode",
						payload = {
							nodeId = p8.nodeId,
							enterTime = UnixTimestampMillis,
							inlineAlert = if FFlagAbuseReportInlineAlertStateOutsideReducer then nil else v87
						}
					})

					if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
						t2.inlineAlertController.setInlineAlert(v87)

						return
					end
				else
					u35({
						type = "gotoNode",
						payload = {
							nodeId = p8.nodeId,
							enterTime = UnixTimestampMillis
						}
					})

					if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
						t2.inlineAlertController.setInlineAlert(nil)

						return
					end
				end
			else
				if type(p8) == "table" and p8.type == "link" then
					v39("", p8.href)
					handleClose()

					return
				end

				if type(p8) == "table" and p8.type == "close" then
					handleClose()

					return
				end

				if FFlagAbuseReportMenuV2 and type(p8) == "table" and p8.type == "reset" then
					notifyFinish()
					reset(v87)

					return
				end

				warn(`Unknown next type: { typeof(p8) }, value: { p8 }`)
				handleClose()
			end
		end
		local function onSubmitForm() -- line: 522
			-- upvalues: v43 (copy), FFlagAbuseReportMenuV2 (copy), t2 (copy), sendReport (copy), v40 (copy)
			local submission = v43.submission

			if FFlagAbuseReportMenuV2 and t2.onCustomSubmit then
				return t2.onCustomSubmit(submission)
			end

			return sendReport(v40, submission.endpoint, submission.data)
		end

		local next = v52.next

		if not next then
			warn("currentNode.next is nil, closing")
			t2.onClose()

			return
		end

		if type(next) == "table" and next.type == "submitForm" then
			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

			v41({
				sub_event_type = TelemetryEventType.Submit
			})
			u35({
				type = "startedSubmission"
			})

			local submission = v43.submission;

			((if not FFlagAbuseReportMenuV2 or not t2.onCustomSubmit then sendReport(v40, submission.endpoint, submission.data) else t2.onCustomSubmit(submission))):andThen(function(p9) -- line: 540
				-- upvalues: u35 (ref), v41 (copy), TelemetryEventType (copy), UnixTimestampMillis (copy), FFlagAbuseReportMenuV2 (copy), v49 (copy), handleNextSimple (copy), next (copy)
				u35({
					type = "completedSubmission"
				})
				v41({
					sub_event_type = TelemetryEventType.SubmitSuccess,
					submit_detail = {
						report_id = p9.responseBody and p9.responseBody.reportId,
						submit_api_duration = DateTime.now().UnixTimestampMillis - UnixTimestampMillis
					}
				})

				if FFlagAbuseReportMenuV2 then
					v49.current = "completed"
				end

				handleNextSimple(next.onSuccess)
			end):catch(function(p10) -- line: 556
				-- upvalues: u35 (ref), v41 (copy), TelemetryEventType (copy), UnixTimestampMillis (copy), Dash (copy), FFlagAbuseReportMenuV2 (copy), v49 (copy), next (copy), handleNextSimple (copy)
				u35({
					type = "submissionFailed"
				})
				v41({
					sub_event_type = TelemetryEventType.SubmitFail,
					submit_detail = {
						submit_api_duration = DateTime.now().UnixTimestampMillis - UnixTimestampMillis
					}
				})
				v41({
					sub_event_type = TelemetryEventType.Error,
					error_detail = {
						error_message = "submitReport: " .. Dash.pretty(p10, {
							depth = 10
						})
					}
				})

				if FFlagAbuseReportMenuV2 then
					v49.current = "failed"
				end

				if next.onFailure then
					handleNextSimple(next.onFailure)
				end
			end)

			return
		end

		handleNextSimple(next)
	end, { u34.navigationState })

	local v56 = #u34.stack > 1 and u34.submissionState ~= "completed"

	local function goBack() -- line: 581
		-- upvalues: v43 (copy), v52 (copy), v51 (copy), v56 (copy), u35 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), t2 (copy), v41 (copy), TelemetryEventType (copy)
		if not v43 or (not v52 or not v51) then
			return
		end

		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		if v56 then
			u35({
				type = "goBack"
			})

			if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
				t2.inlineAlertController.setInlineAlert(nil)
			end

			v41({
				sub_event_type = TelemetryEventType.NodeDone,
				node_done_detail = {
					node_exit_reason = "back",
					node_id = v51.nodeId,
					node_type = v52.type,
					node_duration = UnixTimestampMillis - v51.enterTime
				}
			})
		end
	end

	local v58 = v52 and v52.next ~= nil

	local function onNext(t3: {[any]: any}?) -- line: 604
		-- upvalues: v43 (copy), v52 (copy), v51 (copy), FFlagAbuseReportMenuV2 (copy), v47 (copy), v48 (copy), TelemetryEventType (copy), u35 (ref), v41 (copy)
		if not v43 or (not v52 or not v51) then
			return
		end

		if FFlagAbuseReportMenuV2 and v47.current == "none" then
			v47.current = "started"
			v48.current({
				sub_event_type = TelemetryEventType.ReportStarted
			})
		end

		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		u35({
			type = "updateDataAndNavigateNext",
			payload = {
				store = if not t3 or not t3.store then {} else t3.store,
				expectedFromNodeId = if not FFlagAbuseReportMenuV2 then nil else v51.nodeId
			}
		})
		v41({
			sub_event_type = TelemetryEventType.NodeDone,
			node_done_detail = {
				node_exit_reason = "next",
				node_id = v51.nodeId,
				node_type = v52.type,
				node_duration = UnixTimestampMillis - v51.enterTime
			}
		})
	end

	local v60 = React.useCallback(function() -- line: 635
		-- upvalues: u35 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), t2 (copy)
		u35({
			type = "clearInlineAlert"
		})

		if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
			t2.inlineAlertController.setInlineAlert(nil)
		end
	end, {})
	local v61 = React.useMemo(function() -- line: 642
		-- upvalues: v41 (copy)
		return {
			sendEvent = v41
		}
	end, { v41 })

	return if not not v43 and (not not v52 and v51) then {
		config = v43,
		canGoBack = v56,
		goBack = goBack,
		reset = reset,
		isSubmitting = u34.submissionState == "submitting",
		display = v43.display,
		onClose = handleClose,
		currentPageElement = React.createElement(ContentNode, {
			key = v51.nodeId,
			node = v52,
			onNext = if not v58 then nil else onNext,
			goBack = if not FFlagAbuseReportMenuV2 then nil else goBack,
			store = v42,
			isSubmitting = u34.submissionState == "submitting"
		}),
		currentNodeId = if not FFlagAbuseReportMenuV2 then nil else v51.nodeId,
		currentNodeType = if not FFlagAbuseReportMenuV2 then nil else v52.type,
		navigationDirection = if not FFlagAbuseReportMenuV2 then nil else u34.lastNavigationDirection,
		analytics = v61,
		pendingInlineAlert = if not FFlagAbuseReportMenuV2 then nil else if not FFlagAbuseReportInlineAlertStateOutsideReducer then u34.pendingInlineAlert else if not t2.inlineAlertController then nil else t2.inlineAlertController.pendingInlineAlert,
		dismissInlineAlert = v60
	} else nil
end

return useAbuseSheetFlow
