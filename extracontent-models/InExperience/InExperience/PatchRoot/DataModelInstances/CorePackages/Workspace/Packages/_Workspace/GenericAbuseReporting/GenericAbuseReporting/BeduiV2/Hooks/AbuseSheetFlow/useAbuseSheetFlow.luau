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
local SubmitSource = analyticsService.SubmitSource
local FFlagAbuseReportMenuV2 = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportMenuV2
local FFlagFixAnalyticsForDynamicReportV2 = require(GenericAbuseReportingParent.SharedFlags).FFlagFixAnalyticsForDynamicReportV2
local FFlagAbuseReportLinkOpenedAnalytics = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportLinkOpenedAnalytics
local FFlagAbuseReportInlineAlertStateOutsideReducer = require(GenericAbuseReporting.Flags.FFlagAbuseReportInlineAlertStateOutsideReducer)
local FFlagAbuseReportSceneSelectionSubmitTracking = require(GenericAbuseReporting.Flags.FFlagAbuseReportSceneSelectionSubmitTracking)

local function useAbuseSheetAnalytics(p1, p2, s1: string, s2: string?) -- line: 55
	-- upvalues: React (copy), Dash (copy), FFlagAbuseReportMenuV2 (copy), sendAnalyticsEvent (copy)
	return (React.useCallback(function(p3) -- line: 57
		-- upvalues: p1 (copy), Dash (copy), p2 (copy), s1 (copy), FFlagAbuseReportMenuV2 (copy), s2 (copy), sendAnalyticsEvent (copy)
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
		local v69 = not p1.openTime and 0 or UnixTimestampMillis - p1.openTime
		local v70 = Dash.map(p1.stack, function(p4) -- line: 60
			return p4.nodeId
		end)
		local t1 = {
			run_id = p1.runId,
			user_id = p1.userId,
			abuse_vector = p2,
			target_id = s1,
			total_duration = v69,
			path = v70,
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
local function useAbuseSheetFlow(p5, t2: {[any]: any}) -- line: 120
	-- upvalues: React (copy), FFlagAbuseReportMenuV2 (copy), resolveStartNode (copy), reducer2 (copy), getInitialState (copy), getNewRunId (copy), useOpenLink (copy), useRoactService (copy), RoactNetworking (copy), useAbuseSheetAnalytics (copy), selectStore (copy), resolveArConfig (copy), TelemetryEventType (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), FFlagAbuseReportLinkOpenedAnalytics (copy), LinkOpenedSource (copy), sendReport (copy), FFlagAbuseReportSceneSelectionSubmitTracking (copy), SubmitSource (copy), ContentNode (copy)
	local v35 = React.useMemo(function() -- line: 139
		-- upvalues: FFlagAbuseReportMenuV2 (copy), p5 (copy), resolveStartNode (copy)
		if FFlagAbuseReportMenuV2 and p5 then
			return (resolveStartNode(p5))
		end

		return "root"
	end, { p5 })
	local u38, u39

	if FFlagAbuseReportMenuV2 then
		local v36, v37 = React.useReducer(reducer2, nil, function() -- line: 144
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
	local v46 = React.useMemo(function() -- line: 162
		-- upvalues: selectStore (copy), u38 (ref)
		return selectStore(u38)
	end, { u38 })
	local v47 = React.useMemo(function() -- line: 167
		-- upvalues: p5 (copy), resolveArConfig (copy), v46 (copy)
		if not p5 then
			return nil
		end

		return resolveArConfig(p5, {
			attribute = p5.attributes,
			resources = p5.resources or {},
			store = v46
		})
	end, {
		p5,
		v46
	})
	local v48 = React.useRef(true)
	local v49 = React.useRef(false)
	local v50 = FFlagAbuseReportMenuV2 and t2.attemptTrigger == "onFirstAction"
	local v51 = React.useRef("none")
	local v52 = React.useRef(v45)

	v52.current = v45

	local v53 = React.useRef(u38.submissionState)

	v53.current = u38.submissionState

	local function setNonReducerPendingInlineAlert(p6) -- line: 198
		-- upvalues: t2 (copy)
		if t2.inlineAlertController then
			t2.inlineAlertController.setInlineAlert(p6)
		end
	end

	React.useEffect(function() -- line: 206
		-- upvalues: FFlagAbuseReportMenuV2 (copy), v51 (copy), v52 (copy), v53 (copy), TelemetryEventType (copy)
		if not FFlagAbuseReportMenuV2 then
			return
		end

		return function() -- line: 210
			-- upvalues: v51 (copy), v52 (copy), v53 (copy), TelemetryEventType (copy)
			if v51.current ~= "started" then
				return
			end

			v51.current = "completed"
			v52.current(if v53.current ~= "completed" then {
				sub_event_type = TelemetryEventType.ReportAbandoned
			} else {
				sub_event_type = TelemetryEventType.ReportCompleted
			})
		end
	end, {})
	React.useEffect(function() -- line: 228
		-- upvalues: t2 (copy), v48 (copy), getNewRunId (copy), u39 (ref), v35 (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), v49 (copy), FFlagAbuseReportMenuV2 (copy), v50 (copy), v45 (copy), TelemetryEventType (copy), v51 (copy)
		if t2.open and not v48.current then
			local v73 = getNewRunId()
			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

			u39({
				type = "reset",
				payload = {
					runId = v73,
					initialEnterTime = UnixTimestampMillis,
					startNodeId = v35
				}
			})

			if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
				t2.inlineAlertController.setInlineAlert(nil)
			end

			if FFlagFixAnalyticsForDynamicReportV2 then
				v49.current = false
			end
		end

		v48.current = false

		if t2.open and not FFlagAbuseReportMenuV2 or FFlagAbuseReportMenuV2 and t2.open and not v50 then
			v45({
				sub_event_type = TelemetryEventType.ReportStarted
			})

			if FFlagAbuseReportMenuV2 then
				v51.current = "started"
			end
		end
	end, { t2.open })
	React.useLayoutEffect(function() -- line: 275
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

		local v75 = u38.stack[1]

		if v75 and v75.nodeId == v35 then
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

	local v55 = Dash.last(u38.stack)
	local v56 = v47 and (v47.nodes and (v55 and v47.nodes[v55.nodeId]))

	if not FFlagFixAnalyticsForDynamicReportV2 then
		if not v55 then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "No current page found in abuse sheet flow."
				}
			})
		elseif not v55.nodeId then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Current page has no nodeId in abuse sheet flow."
				}
			})
		end

		if not v47 or not v47.nodes then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Abuse sheet flow config or nodes is nil."
				}
			})
		end

		if not v56 then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = `No config found for current nodeId: { v55 and v55.nodeId }`
				}
			})
		end
	end

	React.useEffect(function() -- line: 342
		-- upvalues: FFlagFixAnalyticsForDynamicReportV2 (copy), t2 (copy), v49 (copy), p5 (copy), v55 (copy), v45 (copy), TelemetryEventType (copy), v47 (copy), v56 (copy)
		if not FFlagFixAnalyticsForDynamicReportV2 or (not t2.open or v49.current) then
			return
		end

		if not p5 then
			return
		end

		if not v55 then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "No current page found in abuse sheet flow."
				}
			})
			v49.current = true

			return
		end

		if not v55.nodeId then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Current page has no nodeId in abuse sheet flow."
				}
			})
			v49.current = true

			return
		end

		if not v47 or not v47.nodes then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = "Abuse sheet flow config or nodes is nil."
				}
			})
			v49.current = true

			return
		end

		if not v56 then
			v45({
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = `No config found for current nodeId: { v55.nodeId }`
				}
			})
			v49.current = true
		end
	end, {
		t2.open,
		p5,
		v47,
		v55,
		v56,
		v45
	})

	local function onExternalSubmit(p7) -- line: 388
		-- upvalues: v52 (copy), TelemetryEventType (copy), u39 (ref), v53 (copy)
		v52.current({
			sub_event_type = TelemetryEventType.Submit,
			submit_detail = {
				submit_source = p7
			}
		})
		u39({
			type = "completedSubmission"
		})
		v53.current = "completed"
		v52.current({
			sub_event_type = TelemetryEventType.SubmitSuccess,
			submit_detail = {
				submit_source = p7
			}
		})
	end
	local function notifyFinish() -- line: 401
		-- upvalues: FFlagAbuseReportMenuV2 (copy), t2 (copy), v53 (copy), v51 (copy), v52 (copy), TelemetryEventType (copy)
		if FFlagAbuseReportMenuV2 and t2.onFinish then
			t2.onFinish({
				didSubmit = v53.current == "completed"
			})
		end

		if FFlagAbuseReportMenuV2 and v51.current == "started" then
			v51.current = "completed"
			v52.current(if v53.current ~= "completed" then {
				sub_event_type = TelemetryEventType.ReportAbandoned
			} else {
				sub_event_type = TelemetryEventType.ReportCompleted
			})
		end
	end
	local function handleClose() -- line: 416
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
	local function reset(p8) -- line: 432
		-- upvalues: getNewRunId (copy), u39 (ref), v35 (copy), FFlagAbuseReportMenuV2 (copy), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), t2 (copy), v51 (copy)
		local v79 = getNewRunId()
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		u39({
			type = "reset",
			payload = {
				runId = v79,
				initialEnterTime = UnixTimestampMillis,
				startNodeId = v35,
				inlineAlert = if not FFlagAbuseReportMenuV2 or FFlagAbuseReportInlineAlertStateOutsideReducer then nil else p8
			}
		})

		if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
			t2.inlineAlertController.setInlineAlert(p8)
		end

		v51.current = "none"
	end

	React.useEffect(function() -- line: 463
		-- upvalues: v47 (copy), v56 (copy), u38 (ref), Dash (copy), t2 (copy), FFlagAbuseReportMenuV2 (copy), u39 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), FFlagAbuseReportLinkOpenedAnalytics (copy), v52 (copy), TelemetryEventType (copy), LinkOpenedSource (copy), v43 (copy), handleClose (copy), notifyFinish (copy), reset (copy), sendReport (copy), v44 (copy), v45 (copy), FFlagAbuseReportSceneSelectionSubmitTracking (copy), SubmitSource (copy), v53 (copy)
		if not v47 or not v56 then
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

		if not v47.nodes[v81.nodeId] then
			warn(`Navigation triggered but no config found for nodeId: { v81.nodeId }`)

			return
		end

		local function handleNextSimple(p9) -- line: 485
			-- upvalues: t2 (copy), FFlagAbuseReportMenuV2 (copy), u39 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), FFlagAbuseReportLinkOpenedAnalytics (copy), v52 (copy), TelemetryEventType (copy), LinkOpenedSource (copy), v43 (copy), handleClose (copy), notifyFinish (copy), reset (copy)
			if not p9 then
				warn("handleNextSimple called with nil next value")
				t2.onClose()

				return
			end

			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
			local v93 = if not FFlagAbuseReportMenuV2 or type(p9) ~= "table" then nil else p9.inlineAlert

			if type(p9) == "string" then
				u39({
					type = "gotoNode",
					payload = {
						nodeId = p9,
						enterTime = UnixTimestampMillis
					}
				})

				if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
					t2.inlineAlertController.setInlineAlert(nil)

					return
				end
			elseif type(p9) == "table" and p9.type == "goto" then
				if FFlagAbuseReportMenuV2 and p9.replace then
					u39({
						type = "replaceAndGotoNode",
						payload = {
							nodeId = p9.nodeId,
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
							nodeId = p9.nodeId,
							enterTime = UnixTimestampMillis
						}
					})

					if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
						t2.inlineAlertController.setInlineAlert(nil)

						return
					end
				end
			else
				if type(p9) == "table" and p9.type == "link" then
					if FFlagAbuseReportLinkOpenedAnalytics then
						v52.current({
							sub_event_type = TelemetryEventType.LinkOpened,
							link_detail = {
								href = p9.href,
								source = LinkOpenedSource.NextAction
							}
						})
					end

					v43("", p9.href)
					handleClose()

					return
				end

				if type(p9) == "table" and p9.type == "close" then
					handleClose()

					return
				end

				if FFlagAbuseReportMenuV2 and type(p9) == "table" and p9.type == "reset" then
					notifyFinish()
					reset(v93)

					return
				end

				warn(`Unknown next type: { typeof(p9) }, value: { p9 }`)
				handleClose()
			end
		end
		local function onSubmitForm() -- line: 558
			-- upvalues: v47 (copy), FFlagAbuseReportMenuV2 (copy), t2 (copy), sendReport (copy), v44 (copy)
			local submission = v47.submission

			if FFlagAbuseReportMenuV2 and t2.onCustomSubmit then
				return t2.onCustomSubmit(submission)
			end

			return sendReport(v44, submission.endpoint, submission.data)
		end

		local next = v56.next

		if not next then
			warn("currentNode.next is nil, closing")
			t2.onClose()

			return
		end

		if type(next) == "table" and next.type == "submitForm" then
			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

			v45({
				sub_event_type = TelemetryEventType.Submit,
				submit_detail = if not FFlagAbuseReportSceneSelectionSubmitTracking then nil else {
					submit_source = SubmitSource.Flow
				}
			})
			u39({
				type = "startedSubmission"
			})

			local submission = v47.submission;

			((if not FFlagAbuseReportMenuV2 or not t2.onCustomSubmit then sendReport(v44, submission.endpoint, submission.data) else t2.onCustomSubmit(submission))):andThen(function(p10) -- line: 581
				-- upvalues: u39 (ref), v45 (copy), TelemetryEventType (copy), UnixTimestampMillis (copy), FFlagAbuseReportSceneSelectionSubmitTracking (copy), SubmitSource (copy), FFlagAbuseReportMenuV2 (copy), v53 (copy), handleNextSimple (copy), next (copy)
				u39({
					type = "completedSubmission"
				})
				v45({
					sub_event_type = TelemetryEventType.SubmitSuccess,
					submit_detail = {
						report_id = p10.responseBody and p10.responseBody.reportId,
						submit_api_duration = DateTime.now().UnixTimestampMillis - UnixTimestampMillis,
						submit_source = if not FFlagAbuseReportSceneSelectionSubmitTracking then nil else SubmitSource.Flow
					}
				})

				if FFlagAbuseReportMenuV2 then
					v53.current = "completed"
				end

				handleNextSimple(next.onSuccess)
			end):catch(function(p11) -- line: 600
				-- upvalues: u39 (ref), v45 (copy), TelemetryEventType (copy), UnixTimestampMillis (copy), FFlagAbuseReportSceneSelectionSubmitTracking (copy), SubmitSource (copy), Dash (copy), FFlagAbuseReportMenuV2 (copy), v53 (copy), next (copy), handleNextSimple (copy)
				u39({
					type = "submissionFailed"
				})
				v45({
					sub_event_type = TelemetryEventType.SubmitFail,
					submit_detail = {
						submit_api_duration = DateTime.now().UnixTimestampMillis - UnixTimestampMillis,
						submit_source = if not FFlagAbuseReportSceneSelectionSubmitTracking then nil else SubmitSource.Flow
					}
				})
				v45({
					sub_event_type = TelemetryEventType.Error,
					error_detail = {
						error_message = "submitReport: " .. Dash.pretty(p11, {
							depth = 10
						})
					}
				})

				if FFlagAbuseReportMenuV2 then
					v53.current = "failed"
				end

				if next.onFailure then
					handleNextSimple(next.onFailure)
				end
			end)

			return
		end

		handleNextSimple(next)
	end, { u38.navigationState })

	local v61 = #u38.stack > 1 and u38.submissionState ~= "completed"

	local function goBack() -- line: 630
		-- upvalues: v47 (copy), v56 (copy), v55 (copy), v61 (copy), u39 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), t2 (copy), v45 (copy), TelemetryEventType (copy)
		if not v47 or (not v56 or not v55) then
			return
		end

		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		if v61 then
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
					node_id = v55.nodeId,
					node_type = v56.type,
					node_duration = UnixTimestampMillis - v55.enterTime
				}
			})
		end
	end

	local v63 = v56 and v56.next ~= nil

	local function onNext(t3: {[any]: any}?) -- line: 653
		-- upvalues: v47 (copy), v56 (copy), v55 (copy), FFlagAbuseReportMenuV2 (copy), v51 (copy), v52 (copy), TelemetryEventType (copy), u39 (ref), v45 (copy)
		if not v47 or (not v56 or not v55) then
			return
		end

		if FFlagAbuseReportMenuV2 and v51.current == "none" then
			v51.current = "started"
			v52.current({
				sub_event_type = TelemetryEventType.ReportStarted
			})
		end

		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis

		u39({
			type = "updateDataAndNavigateNext",
			payload = {
				store = if not t3 or not t3.store then {} else t3.store,
				expectedFromNodeId = if not FFlagAbuseReportMenuV2 then nil else v55.nodeId
			}
		})
		v45({
			sub_event_type = TelemetryEventType.NodeDone,
			node_done_detail = {
				node_exit_reason = "next",
				node_id = v55.nodeId,
				node_type = v56.type,
				node_duration = UnixTimestampMillis - v55.enterTime
			}
		})
	end

	local v65 = React.useCallback(function() -- line: 684
		-- upvalues: u39 (ref), FFlagAbuseReportInlineAlertStateOutsideReducer (copy), t2 (copy)
		u39({
			type = "clearInlineAlert"
		})

		if FFlagAbuseReportInlineAlertStateOutsideReducer and t2.inlineAlertController then
			t2.inlineAlertController.setInlineAlert(nil)
		end
	end, {})
	local v66 = React.useMemo(function() -- line: 691
		-- upvalues: v45 (copy)
		return {
			sendEvent = v45
		}
	end, { v45 })

	return if not not v47 and (not not v56 and v55) then {
		config = v47,
		canGoBack = v61,
		goBack = goBack,
		reset = reset,
		isSubmitting = u38.submissionState == "submitting",
		display = v47.display,
		onClose = handleClose,
		currentPageElement = React.createElement(ContentNode, {
			key = v55.nodeId,
			node = v56,
			onNext = if not v63 then nil else onNext,
			goBack = if not FFlagAbuseReportMenuV2 then nil else goBack,
			onExternalSubmit = if not FFlagAbuseReportSceneSelectionSubmitTracking then nil else onExternalSubmit,
			store = v46,
			isSubmitting = u38.submissionState == "submitting"
		}),
		currentNodeId = if not FFlagAbuseReportMenuV2 then nil else v55.nodeId,
		currentNodeType = if not FFlagAbuseReportMenuV2 then nil else v56.type,
		navigationDirection = if not FFlagAbuseReportMenuV2 then nil else u38.lastNavigationDirection,
		analytics = v66,
		pendingInlineAlert = if not FFlagAbuseReportMenuV2 then nil else if not FFlagAbuseReportInlineAlertStateOutsideReducer then u38.pendingInlineAlert else if not t2.inlineAlertController then nil else t2.inlineAlertController.pendingInlineAlert,
		dismissInlineAlert = v65
	} else nil
end

return useAbuseSheetFlow
