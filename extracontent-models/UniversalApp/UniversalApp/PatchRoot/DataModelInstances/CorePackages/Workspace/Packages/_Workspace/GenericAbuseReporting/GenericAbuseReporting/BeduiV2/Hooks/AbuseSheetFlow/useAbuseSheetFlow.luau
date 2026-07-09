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

require(GenericAbuseReporting.BeduiV2.Types)

local useOpenLink = require(GenericAbuseReporting.BeduiV2.Hooks.useOpenLink)
local getNewRunId = reducer.getNewRunId
local reducer2 = reducer.reducer
local selectContext = reducer.selectContext
local selectFormData = reducer.selectFormData
local selectStore = reducer.selectStore
local sendAnalyticsEvent = analyticsService.sendAnalyticsEvent
local TelemetryEventType = analyticsService.TelemetryEventType
local FFlagAbuseReportMenuV2 = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportMenuV2
local FFlagAbuseReportConfigStoreResolver = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportConfigStoreResolver
local v24 = game:DefineFastFlag("DynamicReportV2SubmitFailErrorEvent", false)
local FFlagFixAnalyticsForDynamicReportV2 = require(GenericAbuseReportingParent.SharedFlags).FFlagFixAnalyticsForDynamicReportV2
local FFlagAbuseReportInlineAlertStateOutsideReducer = require(GenericAbuseReporting.Flags.FFlagAbuseReportInlineAlertStateOutsideReducer)

local function useAbuseSheetAnalytics(p1, p2, s1: string, s2: string?) -- line: 60
	-- upvalues: React (copy), Dash (copy), FFlagAbuseReportMenuV2 (copy), sendAnalyticsEvent (copy)
	return (React.useCallback(function(p3) -- line: 62
		-- upvalues: p1 (copy), Dash (copy), p2 (copy), s1 (copy), FFlagAbuseReportMenuV2 (copy), s2 (copy), sendAnalyticsEvent (copy)
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
		local v70 = not p1.openTime and 0 or UnixTimestampMillis - p1.openTime
		local v71 = Dash.map(p1.stack, function(p4) -- line: 65
			return p4.nodeId
		end)
		local t1 = {
			run_id = p1.runId,
			user_id = p1.userId,
			abuse_vector = p2,
			target_id = s1,
			total_duration = v70,
			path = v71,
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
local function useAbuseSheetFlow(p5, t2: {[any]: any}) -- line: 125
	-- upvalues: React (copy), FFlagAbuseReportMenuV2 (copy), resolveStartNode (copy), reducer2 (copy), getInitialState (copy), getNewRunId (copy), useOpenLink (copy), useRoactService (copy), RoactNetworking (copy), useAbuseSheetAnalytics (copy), FFlagAbuseReportConfigStoreResolver (copy), selectContext (copy), selectFormData (copy), selectStore (copy), resolveArConfig (copy), TelemetryEventType (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), sendReport (copy), v24 (copy), ContentNode (copy)
	local v35 = React.useMemo(function() -- line: 144
		-- upvalues: FFlagAbuseReportMenuV2 (copy), p5 (copy), resolveStartNode (copy)
		if FFlagAbuseReportMenuV2 and p5 then
			return (resolveStartNode(p5))
		end

		return "root"
	end, { p5 })
	local u38, u39

	if FFlagAbuseReportMenuV2 then
		local v36, v37 = React.useReducer(reducer2, nil, function() -- line: 149
			-- upvalues: getInitialState (copy), getNewRunId (copy), v35 (copy)
			return getInitialState(getNewRunId(), DateTime.now().UnixTimestampMillis, v35)
		end)

		u38 = v36
		u39 = v37
	else
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
		local v41, v42 = React.useReducer(reducer2, getInitialState(getNewRunId(), UnixTimestampMillis, v35))

		u38 = v41
		u39 = v42
	end

	local v43 = useOpenLink()
	local v44 = useRoactService(RoactNetworking)
	local v45 = useAbuseSheetAnalytics(u38, t2.abuseVector, t2.targetId, if not FFlagAbuseReportMenuV2 or not p5 then nil else p5.name)
	local v46 = React.useMemo(function() -- line: 167
		-- upvalues: FFlagAbuseReportConfigStoreResolver (copy), selectContext (copy), u38 (ref)
		if not FFlagAbuseReportConfigStoreResolver then
			return (selectContext(u38))
		end

		return {}
	end, { u38 })
	local v47 = React.useMemo(function() -- line: 171
		-- upvalues: FFlagAbuseReportConfigStoreResolver (copy), selectFormData (copy), u38 (ref)
		if not FFlagAbuseReportConfigStoreResolver then
			return (selectFormData(u38))
		end

		return {}
	end, { u38 })
	local v48 = React.useMemo(function() -- line: 175
		-- upvalues: FFlagAbuseReportConfigStoreResolver (copy), selectStore (copy), u38 (ref)
		if FFlagAbuseReportConfigStoreResolver then
			return (selectStore(u38))
		end

		return {}
	end, { u38 })
	local v49 = React.useMemo(function() -- line: 180
		-- upvalues: p5 (copy), resolveArConfig (copy), FFlagAbuseReportConfigStoreResolver (copy), v46 (copy), v47 (copy), v48 (copy)
		if not p5 then
			return nil
		end

		return resolveArConfig(p5, {
			attribute = p5.attributes,
			resources = p5.resources or {},
			context = if FFlagAbuseReportConfigStoreResolver then {} else v46,
			formData = if FFlagAbuseReportConfigStoreResolver then {} else v47,
			store = if not FFlagAbuseReportConfigStoreResolver then {} else v48
		})
	end, {
		p5,
		if FFlagAbuseReportConfigStoreResolver then nil else v46,
		if FFlagAbuseReportConfigStoreResolver then nil else v47,
		if not FFlagAbuseReportConfigStoreResolver then nil else v48
	})
	local v50 = React.useRef(true)
	local v51 = React.useRef(false)
	local v52 = FFlagAbuseReportMenuV2 and t2.attemptTrigger == "onFirstAction"
	local v53 = React.useRef("none")
	local v54 = React.useRef(v45)

	v54.current = v45

	local v55 = React.useRef(u38.submissionState)

	v55.current = u38.submissionState

	local function setNonReducerPendingInlineAlert(p6) -- line: 215
		-- upvalues: t2 (copy)
		if t2.inlineAlertController then
			t2.inlineAlertController.setInlineAlert(p6)
		end
	end

	React.useEffect(function() -- line: 223
		-- upvalues: FFlagAbuseReportMenuV2 (copy), v53 (copy), v54 (copy), v55 (copy), TelemetryEventType (copy)
		if not FFlagAbuseReportMenuV2 then
			return
		end

		return function() -- line: 227
			-- upvalues: v53 (copy), v54 (copy), v55 (copy), TelemetryEventType (copy)
			if v53.current ~= "started" then
				return
			end

			v53.current = "completed"
			v54.current(if v55.current ~= "completed" then {
				sub_event_type = TelemetryEventType.ReportAbandoned
			} else {
				sub_event_type = TelemetryEventType.ReportCompleted
			})
		end
	end, {})
	React.useEffect(function() -- line: 245
		-- upvalues: t2 (copy), v50 (copy), getNewRunId (copy), u39 (ref), v35 (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), v51 (copy), FFlagAbuseReportMenuV2 (copy), v52 (copy), v45 (copy), TelemetryEventType (copy), v53 (copy)
		if t2.open and not v50.current then
			local v74 = getNewRunId()
			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

			u39({
				type = "reset",
				payload = {
					runId = v74,
					initialEnterTime = UnixTimestampMillis,
					startNodeId = v35
				}
			})

			if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
				t2.inlineAlertController.setInlineAlert(nil)
			end

			if FFlagFixAnalyticsForDynamicReportV2 then
				v51.current = false
			end
		end

		v50.current = false

		if t2.open and not FFlagAbuseReportMenuV2 or FFlagAbuseReportMenuV2 and t2.open and not v52 then
			v45({
				sub_event_type = TelemetryEventType.ReportStarted
			})

			if FFlagAbuseReportMenuV2 then
				v53.current = "started"
			end
		end
	end, { t2.open })
	React.useLayoutEffect(function() -- line: 292
		-- upvalues: FFlagAbuseReportMenuV2 (copy), p5 (copy), u38 (ref), v35 (copy), u39 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy)
		if not FFlagAbuseReportMenuV2 then
			return
		end

		if not p5 then
			return
		end

		if #u38.stack > 1 then
			return
		end

		local v76 = u38.stack[1]

		if v76 and v76.nodeId == v35 then
			return
		end

		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		u39({
			type = "reset",
			payload = {
				runId = u38.runId,
				initialEnterTime = u38.openTime or UnixTimestampMillis,
				startNodeId = v35,
				inlineAlert = if FFlagAbuseReportInlineAlertStateOutsideReducer then nil else u38.pendingInlineAlert
			}
		})
	end, {
		p5,
		v35
	})

	local v57 = Dash.last(u38.stack)
	local v58 = v49 and (v49.nodes and (v57 and v49.nodes[v57.nodeId]))

	if not FFlagFixAnalyticsForDynamicReportV2 then
		if not v57 then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "No current page found in abuse sheet flow."
				}
			})
		elseif not v57.nodeId then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Current page has no nodeId in abuse sheet flow."
				}
			})
		end

		if not v49 or not v49.nodes then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Abuse sheet flow config or nodes is nil."
				}
			})
		end

		if not v58 then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = `No config found for current nodeId: { v57 and v57.nodeId }`
				}
			})
		end
	end

	React.useEffect(function() -- line: 359
		-- upvalues: FFlagFixAnalyticsForDynamicReportV2 (copy), t2 (copy), v51 (copy), p5 (copy), v57 (copy), v45 (copy), TelemetryEventType (copy), v49 (copy), v58 (copy)
		if not FFlagFixAnalyticsForDynamicReportV2 or (not t2.open or v51.current) then
			return
		end

		if not p5 then
			return
		end

		if not v57 then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "No current page found in abuse sheet flow."
				}
			})
			v51.current = true

			return
		end

		if not v57.nodeId then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Current page has no nodeId in abuse sheet flow."
				}
			})
			v51.current = true

			return
		end

		if not v49 or not v49.nodes then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Abuse sheet flow config or nodes is nil."
				}
			})
			v51.current = true

			return
		end

		if not v58 then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = `No config found for current nodeId: { v57.nodeId }`
				}
			})
			v51.current = true
		end
	end, {
		t2.open,
		p5,
		v49,
		v57,
		v58,
		v45
	})

	local function notifyFinish() -- line: 396
		-- upvalues: FFlagAbuseReportMenuV2 (copy), t2 (copy), v55 (copy), v53 (copy), v54 (copy), TelemetryEventType (copy)
		if FFlagAbuseReportMenuV2 and t2.onFinish then
			t2.onFinish({
				didSubmit = v55.current == "completed"
			})
		end

		if FFlagAbuseReportMenuV2 and v53.current == "started" then
			v53.current = "completed"
			v54.current(if v55.current ~= "completed" then {
				sub_event_type = TelemetryEventType.ReportAbandoned
			} else {
				sub_event_type = TelemetryEventType.ReportCompleted
			})
		end
	end
	local function handleClose() -- line: 411
		-- upvalues: notifyFinish (copy), t2 (copy), FFlagAbuseReportMenuV2 (copy), u38 (ref), v45 (copy), TelemetryEventType (copy)
		notifyFinish()
		t2.onClose()

		if not FFlagAbuseReportMenuV2 then
			if u38.submissionState ~= "completed" and u38.openTime ~= nil then
				v45({
					sub_event_type = TelemetryEventType.ReportAbandoned
				})

				return
			end

			v45({
				sub_event_type = TelemetryEventType.ReportCompleted
			})
		end
	end
	local function reset(p7) -- line: 427
		-- upvalues: getNewRunId (copy), u39 (ref), v35 (copy), FFlagAbuseReportMenuV2 (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), t2 (copy), v53 (copy)
		local v79 = getNewRunId()
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		u39({
			type = "reset",
			payload = {
				runId = v79,
				initialEnterTime = UnixTimestampMillis,
				startNodeId = v35,
				inlineAlert = if not FFlagAbuseReportMenuV2 or FFlagAbuseReportInlineAlertStateOutsideReducer then nil else p7
			}
		})

		if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
			t2.inlineAlertController.setInlineAlert(p7)
		end

		v53.current = "none"
	end

	React.useEffect(function() -- line: 458
		-- upvalues: v49 (copy), v58 (copy), u38 (ref), Dash (copy), t2 (copy), FFlagAbuseReportMenuV2 (copy), u39 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), v43 (copy), handleClose (copy), notifyFinish (copy), reset (copy), sendReport (copy), v44 (copy), v45 (copy), TelemetryEventType (copy), v55 (copy), v24 (copy)
		if not v49 or not v58 then
			return
		end

		if u38.navigationState ~= "gotoNext" then
			return
		end

		local v81 = Dash.last(u38.stack)

		if not v81 or not v81.nodeId then
			warn("Navigation triggered but current page or nodeId is invalid")

			return
		end

		if not v49.nodes[v81.nodeId] then
			warn(`Navigation triggered but no config found for nodeId: { v81.nodeId }`)

			return
		end

		local function handleNextSimple(p8) -- line: 480
			-- upvalues: t2 (copy), FFlagAbuseReportMenuV2 (copy), u39 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), v43 (copy), handleClose (copy), notifyFinish (copy), reset (copy)
			if not p8 then
				warn("handleNextSimple called with nil next value")
				t2.onClose()

				return
			end

			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
			local v93 = if not FFlagAbuseReportMenuV2 or type(p8) ~= "table" then nil else p8.inlineAlert

			if type(p8) == "string" then
				u39({
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
					u39({
						type = "replaceAndGotoNode",
						payload = {
							nodeId = p8.nodeId,
							enterTime = UnixTimestampMillis,
							inlineAlert = if FFlagAbuseReportInlineAlertStateOutsideReducer then nil else v93
						}
					})

					if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
						t2.inlineAlertController.setInlineAlert(v93)

						return
					end
				else
					u39({
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
					v43("", p8.href)
					handleClose()

					return
				end

				if type(p8) == "table" and p8.type == "close" then
					handleClose()

					return
				end

				if FFlagAbuseReportMenuV2 and type(p8) == "table" and p8.type == "reset" then
					notifyFinish()
					reset(v93)

					return
				end

				warn(`Unknown next type: { typeof(p8) }, value: { p8 }`)
				handleClose()
			end
		end
		local function onSubmitForm() -- line: 544
			-- upvalues: v49 (copy), FFlagAbuseReportMenuV2 (copy), t2 (copy), sendReport (copy), v44 (copy)
			local submission = v49.submission

			if FFlagAbuseReportMenuV2 and t2.onCustomSubmit then
				return t2.onCustomSubmit(submission)
			end

			return sendReport(v44, submission.endpoint, submission.data)
		end

		local next = v58.next

		if not next then
			warn("currentNode.next is nil, closing")
			t2.onClose()

			return
		end

		if type(next) == "table" and next.type == "submitForm" then
			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

			v45({
				sub_event_type = TelemetryEventType.Submit
			})
			u39({
				type = "startedSubmission"
			})

			local submission = v49.submission;

			((if not FFlagAbuseReportMenuV2 or not t2.onCustomSubmit then sendReport(v44, submission.endpoint, submission.data) else t2.onCustomSubmit(submission))):andThen(function(p9) -- line: 562
				-- upvalues: u39 (ref), v45 (copy), TelemetryEventType (copy), UnixTimestampMillis (copy), FFlagAbuseReportMenuV2 (copy), v55 (copy), handleNextSimple (copy), next (copy)
				u39({
					type = "completedSubmission"
				})
				v45({
					sub_event_type = TelemetryEventType.SubmitSuccess,
					submit_detail = {
						report_id = p9.responseBody and p9.responseBody.reportId,
						submit_api_duration = DateTime.now().UnixTimestampMillis - UnixTimestampMillis
					}
				})

				if FFlagAbuseReportMenuV2 then
					v55.current = "completed"
				end

				handleNextSimple(next.onSuccess)
			end):catch(function(p10) -- line: 578
				-- upvalues: u39 (ref), v45 (copy), TelemetryEventType (copy), UnixTimestampMillis (copy), v24 (copy), Dash (copy), FFlagAbuseReportMenuV2 (copy), v55 (copy), next (copy), handleNextSimple (copy)
				u39({
					type = "submissionFailed"
				})
				v45({
					sub_event_type = TelemetryEventType.SubmitFail,
					submit_detail = {
						submit_api_duration = DateTime.now().UnixTimestampMillis - UnixTimestampMillis
					}
				})

				if v24 then
					v45({
						sub_event_type = TelemetryEventType.Error,
						error_detail = {
							error_message = "submitReport: " .. Dash.pretty(p10, {
								depth = 10
							})
						}
					})
				end

				if FFlagAbuseReportMenuV2 then
					v55.current = "failed"
				end

				if next.onFailure then
					handleNextSimple(next.onFailure)
				end
			end)

			return
		end

		handleNextSimple(next)
	end, { u38.navigationState })

	local v62 = #u38.stack > 1 and u38.submissionState ~= "completed"

	local function goBack() -- line: 605
		-- upvalues: v49 (copy), v58 (copy), v57 (copy), v62 (copy), u39 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), t2 (copy), v45 (copy), TelemetryEventType (copy)
		if not v49 or (not v58 or not v57) then
			return
		end

		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		if v62 then
			u39({
				type = "goBack"
			})

			if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
				t2.inlineAlertController.setInlineAlert(nil)
			end

			v45({
				sub_event_type = TelemetryEventType.NodeDone,
				node_done_detail = {
					node_exit_reason = "back",
					node_id = v57.nodeId,
					node_type = v58.type,
					node_duration = UnixTimestampMillis - v57.enterTime
				}
			})
		end
	end

	local v64 = v58 and v58.next ~= nil

	local function onNext(t3: {[any]: any}?) -- line: 628
		-- upvalues: v49 (copy), v58 (copy), v57 (copy), FFlagAbuseReportMenuV2 (copy), v53 (copy), v54 (copy), TelemetryEventType (copy), u39 (ref), FFlagAbuseReportConfigStoreResolver (copy), v45 (copy)
		if not v49 or (not v58 or not v57) then
			return
		end

		if FFlagAbuseReportMenuV2 and v53.current == "none" then
			v53.current = "started"
			v54.current({
				sub_event_type = TelemetryEventType.ReportStarted
			})
		end

		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		u39({
			type = "updateDataAndNavigateNext",
			payload = {
				data = if FFlagAbuseReportConfigStoreResolver or (not t3 or not t3.data) then {} else t3.data,
				context = if FFlagAbuseReportConfigStoreResolver or (not t3 or not t3.context) then {} else t3.context,
				store = if not FFlagAbuseReportConfigStoreResolver or (not t3 or not t3.store) then {} else t3.store,
				expectedFromNodeId = if not FFlagAbuseReportMenuV2 then nil else v57.nodeId
			}
		})
		v45({
			sub_event_type = TelemetryEventType.NodeDone,
			node_done_detail = {
				node_exit_reason = "next",
				node_id = v57.nodeId,
				node_type = v58.type,
				node_duration = UnixTimestampMillis - v57.enterTime
			}
		})
	end

	local v66 = React.useCallback(function() -- line: 665
		-- upvalues: u39 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), t2 (copy)
		u39({
			type = "clearInlineAlert"
		})

		if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
			t2.inlineAlertController.setInlineAlert(nil)
		end
	end, {})
	local v67 = React.useMemo(function() -- line: 672
		-- upvalues: v45 (copy)
		return {
			sendEvent = v45
		}
	end, { v45 })

	return if not not v49 and (not not v58 and v57) then {
		config = v49,
		canGoBack = v62,
		goBack = goBack,
		reset = reset,
		isSubmitting = u38.submissionState == "submitting",
		display = v49.display,
		onClose = handleClose,
		currentPageElement = React.createElement(ContentNode, {
			key = v57.nodeId,
			node = v58,
			onNext = if not v64 then nil else onNext,
			goBack = if not FFlagAbuseReportMenuV2 then nil else goBack,
			data = if FFlagAbuseReportConfigStoreResolver then {} else v47,
			store = if not FFlagAbuseReportConfigStoreResolver then {} else v48,
			isSubmitting = u38.submissionState == "submitting"
		}),
		currentNodeId = if not FFlagAbuseReportMenuV2 then nil else v57.nodeId,
		currentNodeType = if not FFlagAbuseReportMenuV2 then nil else v58.type,
		navigationDirection = if not FFlagAbuseReportMenuV2 then nil else u38.lastNavigationDirection,
		analytics = v67,
		pendingInlineAlert = if not FFlagAbuseReportMenuV2 then nil else if not FFlagAbuseReportInlineAlertStateOutsideReducer then u38.pendingInlineAlert else if not t2.inlineAlertController then nil else t2.inlineAlertController.pendingInlineAlert,
		dismissInlineAlert = v66
	} else nil
end

return useAbuseSheetFlow
