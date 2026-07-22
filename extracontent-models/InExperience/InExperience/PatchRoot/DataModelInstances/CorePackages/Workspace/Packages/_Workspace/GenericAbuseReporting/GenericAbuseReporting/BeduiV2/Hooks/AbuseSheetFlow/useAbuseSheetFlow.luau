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
local LinkOpenedSource = analyticsService.LinkOpenedSource
local FFlagAbuseReportMenuV2 = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportMenuV2
local FFlagFixAnalyticsForDynamicReportV2 = require(GenericAbuseReportingParent.SharedFlags).FFlagFixAnalyticsForDynamicReportV2
local FFlagAbuseReportLinkOpenedAnalytics = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportLinkOpenedAnalytics
local FFlagAbuseReportInlineAlertStateOutsideReducer = require(GenericAbuseReporting.Flags.FFlagAbuseReportInlineAlertStateOutsideReducer)

local function useAbuseSheetAnalytics(p1, p2, s1: string, s2: string?) -- line: 52
	-- upvalues: React (copy), Dash (copy), FFlagAbuseReportMenuV2 (copy), sendAnalyticsEvent (copy)
	return (React.useCallback(function(p3) -- line: 54
		-- upvalues: p1 (copy), Dash (copy), p2 (copy), s1 (copy), FFlagAbuseReportMenuV2 (copy), s2 (copy), sendAnalyticsEvent (copy)
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
		local v66 = not p1.openTime and 0 or UnixTimestampMillis - p1.openTime
		local v67 = Dash.map(p1.stack, function(p4) -- line: 57
			return p4.nodeId
		end)
		local t1 = {
			run_id = p1.runId,
			user_id = p1.userId,
			abuse_vector = p2,
			target_id = s1,
			total_duration = v66,
			path = v67,
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
local function useAbuseSheetFlow(p5, t2: {[any]: any}) -- line: 117
	-- upvalues: React (copy), FFlagAbuseReportMenuV2 (copy), resolveStartNode (copy), reducer2 (copy), getInitialState (copy), getNewRunId (copy), useOpenLink (copy), useRoactService (copy), RoactNetworking (copy), useAbuseSheetAnalytics (copy), selectStore (copy), resolveArConfig (copy), TelemetryEventType (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), FFlagAbuseReportLinkOpenedAnalytics (copy), LinkOpenedSource (copy), sendReport (copy), ContentNode (copy)
	local v33 = React.useMemo(function() -- line: 136
		-- upvalues: FFlagAbuseReportMenuV2 (copy), p5 (copy), resolveStartNode (copy)
		if FFlagAbuseReportMenuV2 and p5 then
			return (resolveStartNode(p5))
		end

		return "root"
	end, { p5 })
	local u36, u37

	if FFlagAbuseReportMenuV2 then
		local v34, v35 = React.useReducer(reducer2, nil, function() -- line: 141
			-- upvalues: getInitialState (copy), getNewRunId (copy), v33 (copy)
			return getInitialState(getNewRunId(), DateTime.now().UnixTimestampMillis, v33)
		end)

		u36 = v34
		u37 = v35
	else
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
		local v39, v40 = React.useReducer(reducer2, getInitialState(getNewRunId(), UnixTimestampMillis, v33))

		u36 = v39
		u37 = v40
	end

	local v41 = useOpenLink()
	local v42 = useRoactService(RoactNetworking)
	local v43 = useAbuseSheetAnalytics(u36, t2.abuseVector, t2.targetId, if not FFlagAbuseReportMenuV2 or not p5 then nil else p5.name)
	local v44 = React.useMemo(function() -- line: 159
		-- upvalues: selectStore (copy), u36 (ref)
		return selectStore(u36)
	end, { u36 })
	local v45 = React.useMemo(function() -- line: 164
		-- upvalues: p5 (copy), resolveArConfig (copy), v44 (copy)
		if not p5 then
			return nil
		end

		return resolveArConfig(p5, {
			attribute = p5.attributes,
			resources = p5.resources or {},
			store = v44
		})
	end, {
		p5,
		v44
	})
	local v46 = React.useRef(true)
	local v47 = React.useRef(false)
	local v48 = FFlagAbuseReportMenuV2 and t2.attemptTrigger == "onFirstAction"
	local v49 = React.useRef("none")
	local v50 = React.useRef(v43)

	v50.current = v43

	local v51 = React.useRef(u36.submissionState)

	v51.current = u36.submissionState

	local function setNonReducerPendingInlineAlert(p6) -- line: 195
		-- upvalues: t2 (copy)
		if t2.inlineAlertController then
			t2.inlineAlertController.setInlineAlert(p6)
		end
	end

	React.useEffect(function() -- line: 203
		-- upvalues: FFlagAbuseReportMenuV2 (copy), v49 (copy), v50 (copy), v51 (copy), TelemetryEventType (copy)
		if not FFlagAbuseReportMenuV2 then
			return
		end

		return function() -- line: 207
			-- upvalues: v49 (copy), v50 (copy), v51 (copy), TelemetryEventType (copy)
			if v49.current ~= "started" then
				return
			end

			v49.current = "completed"
			v50.current(if v51.current ~= "completed" then {
				sub_event_type = TelemetryEventType.ReportAbandoned
			} else {
				sub_event_type = TelemetryEventType.ReportCompleted
			})
		end
	end, {})
	React.useEffect(function() -- line: 225
		-- upvalues: t2 (copy), v46 (copy), getNewRunId (copy), u37 (ref), v33 (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), v47 (copy), FFlagAbuseReportMenuV2 (copy), v48 (copy), v43 (copy), TelemetryEventType (copy), v49 (copy)
		if t2.open and not v46.current then
			local v70 = getNewRunId()
			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

			u37({
				type = "reset",
				payload = {
					runId = v70,
					initialEnterTime = UnixTimestampMillis,
					startNodeId = v33
				}
			})

			if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
				t2.inlineAlertController.setInlineAlert(nil)
			end

			if FFlagFixAnalyticsForDynamicReportV2 then
				v47.current = false
			end
		end

		v46.current = false

		if t2.open and not FFlagAbuseReportMenuV2 or FFlagAbuseReportMenuV2 and t2.open and not v48 then
			v43({
				sub_event_type = TelemetryEventType.ReportStarted
			})

			if FFlagAbuseReportMenuV2 then
				v49.current = "started"
			end
		end
	end, { t2.open })
	React.useLayoutEffect(function() -- line: 272
		-- upvalues: FFlagAbuseReportMenuV2 (copy), p5 (copy), u36 (ref), v33 (copy), u37 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy)
		if not FFlagAbuseReportMenuV2 then
			return
		end

		if not p5 then
			return
		end

		if #u36.stack > 1 then
			return
		end

		local v72 = u36.stack[1]

		if v72 and v72.nodeId == v33 then
			return
		end

		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		u37({
			type = "reset",
			payload = {
				runId = u36.runId,
				initialEnterTime = u36.openTime or UnixTimestampMillis,
				startNodeId = v33,
				inlineAlert = if FFlagAbuseReportInlineAlertStateOutsideReducer then nil else u36.pendingInlineAlert
			}
		})
	end, {
		p5,
		v33
	})

	local v53 = Dash.last(u36.stack)
	local v54 = v45 and (v45.nodes and (v53 and v45.nodes[v53.nodeId]))

	if not FFlagFixAnalyticsForDynamicReportV2 then
		if not v53 then
			v43({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "No current page found in abuse sheet flow."
				}
			})
		elseif not v53.nodeId then
			v43({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Current page has no nodeId in abuse sheet flow."
				}
			})
		end

		if not v45 or not v45.nodes then
			v43({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Abuse sheet flow config or nodes is nil."
				}
			})
		end

		if not v54 then
			v43({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = `No config found for current nodeId: { v53 and v53.nodeId }`
				}
			})
		end
	end

	React.useEffect(function() -- line: 339
		-- upvalues: FFlagFixAnalyticsForDynamicReportV2 (copy), t2 (copy), v47 (copy), p5 (copy), v53 (copy), v43 (copy), TelemetryEventType (copy), v45 (copy), v54 (copy)
		if not FFlagFixAnalyticsForDynamicReportV2 or (not t2.open or v47.current) then
			return
		end

		if not p5 then
			return
		end

		if not v53 then
			v43({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "No current page found in abuse sheet flow."
				}
			})
			v47.current = true

			return
		end

		if not v53.nodeId then
			v43({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Current page has no nodeId in abuse sheet flow."
				}
			})
			v47.current = true

			return
		end

		if not v45 or not v45.nodes then
			v43({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Abuse sheet flow config or nodes is nil."
				}
			})
			v47.current = true

			return
		end

		if not v54 then
			v43({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = `No config found for current nodeId: { v53.nodeId }`
				}
			})
			v47.current = true
		end
	end, {
		t2.open,
		p5,
		v45,
		v53,
		v54,
		v43
	})

	local function notifyFinish() -- line: 376
		-- upvalues: FFlagAbuseReportMenuV2 (copy), t2 (copy), v51 (copy), v49 (copy), v50 (copy), TelemetryEventType (copy)
		if FFlagAbuseReportMenuV2 and t2.onFinish then
			t2.onFinish({
				didSubmit = v51.current == "completed"
			})
		end

		if FFlagAbuseReportMenuV2 and v49.current == "started" then
			v49.current = "completed"
			v50.current(if v51.current ~= "completed" then {
				sub_event_type = TelemetryEventType.ReportAbandoned
			} else {
				sub_event_type = TelemetryEventType.ReportCompleted
			})
		end
	end
	local function handleClose() -- line: 391
		-- upvalues: notifyFinish (copy), t2 (copy), FFlagAbuseReportMenuV2 (copy), u36 (ref), v43 (copy), TelemetryEventType (copy)
		notifyFinish()
		t2.onClose()

		if not FFlagAbuseReportMenuV2 then
			if u36.submissionState ~= "completed" and u36.openTime ~= nil then
				v43({
					sub_event_type = TelemetryEventType.ReportAbandoned
				})

				return
			end

			v43({
				sub_event_type = TelemetryEventType.ReportCompleted
			})
		end
	end
	local function reset(p7) -- line: 407
		-- upvalues: getNewRunId (copy), u37 (ref), v33 (copy), FFlagAbuseReportMenuV2 (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), t2 (copy), v49 (copy)
		local v75 = getNewRunId()
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		u37({
			type = "reset",
			payload = {
				runId = v75,
				initialEnterTime = UnixTimestampMillis,
				startNodeId = v33,
				inlineAlert = if not FFlagAbuseReportMenuV2 or FFlagAbuseReportInlineAlertStateOutsideReducer then nil else p7
			}
		})

		if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
			t2.inlineAlertController.setInlineAlert(p7)
		end

		v49.current = "none"
	end

	React.useEffect(function() -- line: 438
		-- upvalues: v45 (copy), v54 (copy), u36 (ref), Dash (copy), t2 (copy), FFlagAbuseReportMenuV2 (copy), u37 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), FFlagAbuseReportLinkOpenedAnalytics (copy), v50 (copy), TelemetryEventType (copy), LinkOpenedSource (copy), v41 (copy), handleClose (copy), notifyFinish (copy), reset (copy), sendReport (copy), v42 (copy), v43 (copy), v51 (copy)
		if not v45 or not v54 then
			return
		end

		if u36.navigationState ~= "gotoNext" then
			return
		end

		local v77 = Dash.last(u36.stack)

		if not v77 or not v77.nodeId then
			warn("Navigation triggered but current page or nodeId is invalid")

			return
		end

		if not v45.nodes[v77.nodeId] then
			warn(`Navigation triggered but no config found for nodeId: { v77.nodeId }`)

			return
		end

		local function handleNextSimple(p8) -- line: 460
			-- upvalues: t2 (copy), FFlagAbuseReportMenuV2 (copy), u37 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), FFlagAbuseReportLinkOpenedAnalytics (copy), v50 (copy), TelemetryEventType (copy), LinkOpenedSource (copy), v41 (copy), handleClose (copy), notifyFinish (copy), reset (copy)
			if not p8 then
				warn("handleNextSimple called with nil next value")
				t2.onClose()

				return
			end

			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
			local v89 = if not FFlagAbuseReportMenuV2 or type(p8) ~= "table" then nil else p8.inlineAlert

			if type(p8) == "string" then
				u37({
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
					u37({
						type = "replaceAndGotoNode",
						payload = {
							nodeId = p8.nodeId,
							enterTime = UnixTimestampMillis,
							inlineAlert = if FFlagAbuseReportInlineAlertStateOutsideReducer then nil else v89
						}
					})

					if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
						t2.inlineAlertController.setInlineAlert(v89)

						return
					end
				else
					u37({
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
					if FFlagAbuseReportLinkOpenedAnalytics then
						v50.current({
							sub_event_type = TelemetryEventType.LinkOpened,
							link_detail = {
								href = p8.href,
								source = LinkOpenedSource.NextAction
							}
						})
					end

					v41("", p8.href)
					handleClose()

					return
				end

				if type(p8) == "table" and p8.type == "close" then
					handleClose()

					return
				end

				if FFlagAbuseReportMenuV2 and type(p8) == "table" and p8.type == "reset" then
					notifyFinish()
					reset(v89)

					return
				end

				warn(`Unknown next type: { typeof(p8) }, value: { p8 }`)
				handleClose()
			end
		end
		local function onSubmitForm() -- line: 533
			-- upvalues: v45 (copy), FFlagAbuseReportMenuV2 (copy), t2 (copy), sendReport (copy), v42 (copy)
			local submission = v45.submission

			if FFlagAbuseReportMenuV2 and t2.onCustomSubmit then
				return t2.onCustomSubmit(submission)
			end

			return sendReport(v42, submission.endpoint, submission.data)
		end

		local next = v54.next

		if not next then
			warn("currentNode.next is nil, closing")
			t2.onClose()

			return
		end

		if type(next) == "table" and next.type == "submitForm" then
			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

			v43({
				sub_event_type = TelemetryEventType.Submit
			})
			u37({
				type = "startedSubmission"
			})

			local submission = v45.submission;

			((if not FFlagAbuseReportMenuV2 or not t2.onCustomSubmit then sendReport(v42, submission.endpoint, submission.data) else t2.onCustomSubmit(submission))):andThen(function(p9) -- line: 551
				-- upvalues: u37 (ref), v43 (copy), TelemetryEventType (copy), UnixTimestampMillis (copy), FFlagAbuseReportMenuV2 (copy), v51 (copy), handleNextSimple (copy), next (copy)
				u37({
					type = "completedSubmission"
				})
				v43({
					sub_event_type = TelemetryEventType.SubmitSuccess,
					submit_detail = {
						report_id = p9.responseBody and p9.responseBody.reportId,
						submit_api_duration = DateTime.now().UnixTimestampMillis - UnixTimestampMillis
					}
				})

				if FFlagAbuseReportMenuV2 then
					v51.current = "completed"
				end

				handleNextSimple(next.onSuccess)
			end):catch(function(p10) -- line: 567
				-- upvalues: u37 (ref), v43 (copy), TelemetryEventType (copy), UnixTimestampMillis (copy), Dash (copy), FFlagAbuseReportMenuV2 (copy), v51 (copy), next (copy), handleNextSimple (copy)
				u37({
					type = "submissionFailed"
				})
				v43({
					sub_event_type = TelemetryEventType.SubmitFail,
					submit_detail = {
						submit_api_duration = DateTime.now().UnixTimestampMillis - UnixTimestampMillis
					}
				})
				v43({
					sub_event_type = TelemetryEventType.Error,
					error_detail = {
						error_message = "submitReport: " .. Dash.pretty(p10, {
							depth = 10
						})
					}
				})

				if FFlagAbuseReportMenuV2 then
					v51.current = "failed"
				end

				if next.onFailure then
					handleNextSimple(next.onFailure)
				end
			end)

			return
		end

		handleNextSimple(next)
	end, { u36.navigationState })

	local v58 = #u36.stack > 1 and u36.submissionState ~= "completed"

	local function goBack() -- line: 592
		-- upvalues: v45 (copy), v54 (copy), v53 (copy), v58 (copy), u37 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), t2 (copy), v43 (copy), TelemetryEventType (copy)
		if not v45 or (not v54 or not v53) then
			return
		end

		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		if v58 then
			u37({
				type = "goBack"
			})

			if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
				t2.inlineAlertController.setInlineAlert(nil)
			end

			v43({
				sub_event_type = TelemetryEventType.NodeDone,
				node_done_detail = {
					node_exit_reason = "back",
					node_id = v53.nodeId,
					node_type = v54.type,
					node_duration = UnixTimestampMillis - v53.enterTime
				}
			})
		end
	end

	local v60 = v54 and v54.next ~= nil

	local function onNext(t3: {[any]: any}?) -- line: 615
		-- upvalues: v45 (copy), v54 (copy), v53 (copy), FFlagAbuseReportMenuV2 (copy), v49 (copy), v50 (copy), TelemetryEventType (copy), u37 (ref), v43 (copy)
		if not v45 or (not v54 or not v53) then
			return
		end

		if FFlagAbuseReportMenuV2 and v49.current == "none" then
			v49.current = "started"
			v50.current({
				sub_event_type = TelemetryEventType.ReportStarted
			})
		end

		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		u37({
			type = "updateDataAndNavigateNext",
			payload = {
				store = if not t3 or not t3.store then {} else t3.store,
				expectedFromNodeId = if not FFlagAbuseReportMenuV2 then nil else v53.nodeId
			}
		})
		v43({
			sub_event_type = TelemetryEventType.NodeDone,
			node_done_detail = {
				node_exit_reason = "next",
				node_id = v53.nodeId,
				node_type = v54.type,
				node_duration = UnixTimestampMillis - v53.enterTime
			}
		})
	end

	local v62 = React.useCallback(function() -- line: 646
		-- upvalues: u37 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), t2 (copy)
		u37({
			type = "clearInlineAlert"
		})

		if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
			t2.inlineAlertController.setInlineAlert(nil)
		end
	end, {})
	local v63 = React.useMemo(function() -- line: 653
		-- upvalues: v43 (copy)
		return {
			sendEvent = v43
		}
	end, { v43 })

	return if not not v45 and (not not v54 and v53) then {
		config = v45,
		canGoBack = v58,
		goBack = goBack,
		reset = reset,
		isSubmitting = u36.submissionState == "submitting",
		display = v45.display,
		onClose = handleClose,
		currentPageElement = React.createElement(ContentNode, {
			key = v53.nodeId,
			node = v54,
			onNext = if not v60 then nil else onNext,
			goBack = if not FFlagAbuseReportMenuV2 then nil else goBack,
			store = v44,
			isSubmitting = u36.submissionState == "submitting"
		}),
		currentNodeId = if not FFlagAbuseReportMenuV2 then nil else v53.nodeId,
		currentNodeType = if not FFlagAbuseReportMenuV2 then nil else v54.type,
		navigationDirection = if not FFlagAbuseReportMenuV2 then nil else u36.lastNavigationDirection,
		analytics = v63,
		pendingInlineAlert = if not FFlagAbuseReportMenuV2 then nil else if not FFlagAbuseReportInlineAlertStateOutsideReducer then u36.pendingInlineAlert else if not t2.inlineAlertController then nil else t2.inlineAlertController.pendingInlineAlert,
		dismissInlineAlert = v62
	} else nil
end

return useAbuseSheetFlow
