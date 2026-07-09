local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local CoreGui = game:GetService("CoreGui")
local Dash = require(GenericAbuseReportingParent.Dash)
local FocusNavigationUtils = require(GenericAbuseReportingParent.FocusNavigationUtils)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local Responsive = require(GenericAbuseReportingParent.Responsive)
local RoactNetworking = require(GenericAbuseReportingParent.RoactServiceTags).RoactNetworking
local useRoactService = require(GenericAbuseReportingParent.RobloxAppHooks).useRoactService
local InlineEventType = require(GenericAbuseReportingParent.OnPlatformSurveys.InlineEventType)
local InlineSurvey = require(GenericAbuseReportingParent.OnPlatformSurveys.InlineSurvey)
local SurveyEventPublisher = require(GenericAbuseReportingParent.OnPlatformSurveys.SurveyEventPublisher)
local WebViewEventType = require(GenericAbuseReportingParent.OnPlatformSurveys.WebViewEventType)
local DialogSize = Foundation.Enums.DialogSize
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local OverlayProvider = Foundation.OverlayProvider
local Sheet = Foundation.Sheet
local useIsSpatial = Responsive.useIsSpatial
local AbuseReportAnalyticsProvider = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext).AbuseReportAnalyticsProvider
local AbuseReportErrorBoundary = require(GenericAbuseReporting.BeduiV2.Components.AbuseReportErrorBoundary)

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local AbuseReportDialog = require(GenericAbuseReporting.BeduiV2.Components.AbuseReportDialog)
local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local ArTranslationProvider = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).ArTranslationProvider
local DynamicReportV2Error = require(script.Parent.DynamicReportV2Error)
local DynamicReportV2Loading = require(script.Parent.DynamicReportV2Loading)
local fetchConfig = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.fetchConfig)
local fetchConfigWithAttributes = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.fetchConfigWithAttributes)
local getNewRunId = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.reducer).getNewRunId
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local AbuseReportContent = require(script.Parent.AbuseReportContent)
local sendBoundaryErrorTelemetry = require(GenericAbuseReporting.BeduiV2.Analytics.sendBoundaryErrorTelemetry)
local useAbuseSheetFlow = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.useAbuseSheetFlow)
local useFocusNavigationRefs = require(GenericAbuseReporting.BeduiV2.Hooks.FocusNavigation.useFocusNavigationRefs)
local useVrOverlay = require(GenericAbuseReporting.BeduiV2.Hooks.useVrOverlay)
local LayoutSlotsProvider = LayoutSlots.LayoutSlotsProvider
local sheetSlots = LayoutSlots.sheetSlots
local sendAnalyticsEvent = analyticsService.sendAnalyticsEvent
local TelemetryEventType = analyticsService.TelemetryEventType
local v41 = game:DefineFastFlag("FixDynamicReportV2VRAsync", false)
local FFlagFixAnalyticsForDynamicReportV2 = require(GenericAbuseReportingParent.SharedFlags).FFlagFixAnalyticsForDynamicReportV2
local FFlagAbuseReportMenuV2 = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportMenuV2
local FFlagAbuseReportConfigProfileUseAttributesPayload = require(GenericAbuseReportingParent.SharedFlags).FFlagAbuseReportConfigProfileUseAttributesPayload
local FFlagEnableInlineSurveyOnUserReport = require(GenericAbuseReportingParent.SharedFlags).FFlagEnableInlineSurveyOnUserReport
local FFlagSurvBloxEventTypeEnabled = require(GenericAbuseReportingParent.SharedFlags).FFlagSurvBloxEventTypeEnabled

local function DynamicReportV2Container(t1: {[any]: any}) -- line: 73
	-- upvalues: useRoactService (copy), RoactNetworking (copy), React (copy), FFlagAbuseReportConfigProfileUseAttributesPayload (copy), fetchConfigWithAttributes (copy), fetchConfig (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), sendAnalyticsEvent (copy), getNewRunId (copy), TelemetryEventType (copy), useAbuseSheetFlow (copy), useFocusNavigationRefs (copy), FocusNavigableSurfaceIdentifierEnum (copy), CoreGui (copy), useIsSpatial (copy), v41 (copy), useVrOverlay (copy), Sheet (copy), DialogSize (copy), ArTranslationProvider (copy), AbuseReportAnalyticsProvider (copy), LayoutSlotsProvider (copy), sheetSlots (copy), AbuseReportDialog (copy), DynamicReportV2Loading (copy), DynamicReportV2Error (copy), OverlayProvider (copy)
	local v50 = useRoactService(RoactNetworking)
	local v51, v52 = React.useState(nil)
	local v53, v54 = React.useState(false)
	local v55, v56 = React.useState(true)

	React.useEffect(function() -- line: 79
		-- upvalues: FFlagAbuseReportConfigProfileUseAttributesPayload (copy), fetchConfigWithAttributes (copy), v50 (copy), t1 (copy), fetchConfig (copy), v52 (copy), v54 (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), sendAnalyticsEvent (copy), getNewRunId (copy), TelemetryEventType (copy);
		((if not FFlagAbuseReportConfigProfileUseAttributesPayload then fetchConfig(v50, t1.abuseVector, t1.targetId) else fetchConfigWithAttributes(v50, t1.abuseVector, {
			targetId = t1.targetId
		}))):andThen(function(p1) -- line: 84
			-- upvalues: v52 (copy)
			v52(p1.responseBody)
		end):catch(function(p2) -- line: 87
			-- upvalues: v54 (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), sendAnalyticsEvent (copy), t1 (copy), getNewRunId (copy), TelemetryEventType (copy)
			warn("Failed to fetch Dynamic Report V2 config:", p2)
			v54(true)

			local v114 = nil

			if FFlagFixAnalyticsForDynamicReportV2 then
				v114 = Dash.pretty(p2, {
					depth = 10,
					multiline = true
				})
			end

			sendAnalyticsEvent({
				total_duration = 0,
				abuse_vector = t1.abuseVector,
				target_id = t1.targetId,
				run_id = getNewRunId(),
				path = {}
			}, {
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = if not FFlagFixAnalyticsForDynamicReportV2 then `Failed to fetch config: ${ tostring(p2) }` else `Failed to fetch config: ${ v114 }`
				}
			})
		end)
	end, {
		v50,
		t1.abuseVector,
		t1.targetId
	})

	local v57 = useAbuseSheetFlow(v51, {
		abuseVector = t1.abuseVector,
		targetId = t1.targetId,
		onClose = t1.onClose,
		open = v55
	})

	if not v57 and v51 then
		v53 = true
	end

	local v58 = React.useCallback(function() -- line: 120
		-- upvalues: v57 (copy), v56 (copy), t1 (copy)
		if v57 then
			v57.onClose()
		end

		v56(false)
		t1.onClose()
	end, {
		v57,
		t1.onClose
	})
	local v59 = useFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, function() -- line: 134
		-- upvalues: v58 (copy)
		v58()
	end)
	local v60, v61 = React.useState(true)
	local v62 = React.useCallback(function(b1: boolean) -- line: 139
		-- upvalues: v61 (copy)
		v61(not b1)
	end, {})
	local v63 = React.useCallback(function(p3) -- line: 143
		-- upvalues: v60 (copy), v59 (copy)
		local v104 = if not v60 then nil else p3

		if typeof(v59) == "function" then
			v59(v104)

			return
		end

		if v59 and typeof(v59) == "table" then
			v59.current = v104
		end
	end, {
		v60,
		v59
	})
	local VRCentralOverlay = CoreGui:FindFirstChild("VRCentralOverlay")
	local v65 = if not VRCentralOverlay then nil else VRCentralOverlay:FindFirstChild("CentralOverlay_SurfaceGui")
	local v66 = useIsSpatial()
	local v67 = if not v41 then v65 else useVrOverlay()
	local v68 = React.createElement(Sheet.Root, {
		centerSheetHeight = 1,
		preferCenterSheet = true,
		isOpen = v55,
		onClose = v58,
		snapPoints = { 0.9 },
		size = DialogSize.Medium,
		ref = v63
	}, {
		AbuseReportDialog = if not v51 or (v53 or not v57) then nil else React.createElement(ArTranslationProvider, {
			translations = v57.config.translations
		}, React.createElement(AbuseReportAnalyticsProvider, {
			analytics = v57.analytics
		}, React.createElement(LayoutSlotsProvider, {
			slots = sheetSlots
		}, React.createElement(AbuseReportDialog, {
			abuseVector = t1.abuseVector,
			targetId = t1.targetId,
			onClose = v58,
			abuseReportFlow = v57,
			takeoverFocus = v62
		})))),
		LoadingDialog = if v51 or v53 then nil else React.createElement(DynamicReportV2Loading, nil),
		ErrorDialog = if not v53 then nil else React.createElement(DynamicReportV2Error, nil)
	})

	if v41 and v66 and not v67 then
		return nil
	end

	return React.createElement(OverlayProvider, {
		gui = v67
	}, {
		Sheet = v68
	})
end
local function DynamicReportV2ContainerV2(t2: {[any]: any}) -- line: 221
	-- upvalues: useRoactService (copy), RoactNetworking (copy), React (copy), FFlagEnableInlineSurveyOnUserReport (copy), FFlagAbuseReportConfigProfileUseAttributesPayload (copy), fetchConfigWithAttributes (copy), fetchConfig (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), getNewRunId (copy), FFlagSurvBloxEventTypeEnabled (copy), SurveyEventPublisher (copy), WebViewEventType (copy), AbuseVector (copy), sendBoundaryErrorTelemetry (copy), useFocusNavigationRefs (copy), FocusNavigableSurfaceIdentifierEnum (copy), CoreGui (copy), useIsSpatial (copy), v41 (copy), useVrOverlay (copy), Sheet (copy), DialogSize (copy), AbuseReportErrorBoundary (copy), AbuseReportContent (copy), DynamicReportV2Loading (copy), DynamicReportV2Error (copy), OverlayProvider (copy), InlineSurvey (copy), InlineEventType (copy)
	local v70 = useRoactService(RoactNetworking)
	local v71, v72 = React.useState(nil)
	local v73, v74 = React.useState(false)
	local v75, v76 = React.useState(true)
	local v77 = nil
	local u78 = nil
	local u79 = nil

	if FFlagEnableInlineSurveyOnUserReport then
		local v80

		v77, v80 = React.useState(false)
		u78 = v80
		u79 = React.useRef(false)
	end

	React.useEffect(function() -- line: 235
		-- upvalues: FFlagAbuseReportConfigProfileUseAttributesPayload (copy), fetchConfigWithAttributes (copy), v70 (copy), t2 (copy), fetchConfig (copy), v72 (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v74 (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), getNewRunId (copy)
		local u105 = false
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis;

		((if not FFlagAbuseReportConfigProfileUseAttributesPayload then fetchConfig(v70, t2.abuseVector, t2.targetId) else fetchConfigWithAttributes(v70, t2.abuseVector, {
			targetId = t2.targetId
		}))):andThen(function(p4) -- line: 243
			-- upvalues: u105 (ref), UnixTimestampMillis (copy), v72 (copy), sendAnalyticsEvent (copy), t2 (copy), TelemetryEventType (copy)
			if u105 then
				return
			end

			local responseBody = p4.responseBody
			local v117 = DateTime.now().UnixTimestampMillis - UnixTimestampMillis

			v72(responseBody)
			sendAnalyticsEvent({
				run_id = "unknown",
				total_duration = 0,
				abuse_vector = t2.abuseVector,
				target_id = t2.targetId,
				path = {},
				config_name = responseBody.name
			}, {
				sub_event_type = TelemetryEventType.ConfigLoaded,
				config_load_detail = {
					cache_hit = false,
					retry_count = 0,
					load_duration_ms = v117
				}
			})
		end):catch(function(p5) -- line: 268
			-- upvalues: u105 (ref), v74 (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), sendAnalyticsEvent (copy), t2 (copy), getNewRunId (copy), TelemetryEventType (copy)
			if u105 then
				return
			end

			warn("Failed to fetch Dynamic Report V2 config:", p5)
			v74(true)

			local v119 = nil

			if FFlagFixAnalyticsForDynamicReportV2 then
				v119 = Dash.pretty(p5, {
					depth = 10,
					multiline = true
				})
			end

			sendAnalyticsEvent({
				total_duration = 0,
				abuse_vector = t2.abuseVector,
				target_id = t2.targetId,
				run_id = getNewRunId(),
				path = {}
			}, {
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = if not FFlagFixAnalyticsForDynamicReportV2 then `Failed to fetch config: { tostring(p5) }` else `Failed to fetch config: { v119 }`
				}
			})
		end)

		return function() -- line: 293
			-- upvalues: u105 (ref)
			u105 = true
		end
	end, {
		v70,
		t2.abuseVector,
		t2.targetId
	})

	local v81 = React.useRef(nil)
	local v82 = React.useRef(false)
	local u83 = nil
	local v84 = nil
	local u85 = nil
	local v86 = nil
	local v87 = nil

	if FFlagEnableInlineSurveyOnUserReport then
		u83 = React.useRef(false)
		v84 = React.useCallback(function(t3: {[any]: any}) -- line: 317
			-- upvalues: u83 (ref)
			if t3.didSubmit then
				u83.current = true
			end
		end, {})
		u85 = React.useCallback(function() -- line: 323
			-- upvalues: FFlagSurvBloxEventTypeEnabled (copy), SurveyEventPublisher (copy), WebViewEventType (copy)
			if FFlagSurvBloxEventTypeEnabled then
				SurveyEventPublisher.publishSurveyEvent(WebViewEventType.ReportSubmitted)
			end
		end, {})
		v86 = React.useCallback(function() -- line: 329
			-- upvalues: u79 (ref)
			u79.current = true
		end, {})
		v87 = React.useCallback(function() -- line: 333
			-- upvalues: u79 (ref), u85 (ref), t2 (copy)
			if not u79.current then
				u85()
			end

			t2.onClose()
		end, {
			u85,
			t2.onClose
		})
	end

	local v88 = React.useCallback(function() -- line: 341
		-- upvalues: v82 (copy), v76 (copy)
		v82.current = true
		v76(false)
	end, {})
	local v89 = React.useCallback(function() -- line: 349
		-- upvalues: v82 (copy), v81 (copy), v76 (copy), FFlagEnableInlineSurveyOnUserReport (copy), u83 (ref), t2 (copy), AbuseVector (copy), u78 (ref), u85 (ref)
		if not v82.current and v81.current then
			v81.current.requestClose()
		end

		v76(false)

		if FFlagEnableInlineSurveyOnUserReport then
			if not u83.current then
				t2.onClose()

				return
			end

			if t2.abuseVector == AbuseVector.UserProfile then
				u78(true)

				return
			end

			u85()
		end

		t2.onClose()
	end, {
		t2.onClose,
		t2.abuseVector,
		u85
	})
	local v90 = React.useCallback(function() -- line: 373
		-- upvalues: v74 (copy)
		v74(true)
	end, {})
	local v91 = React.useCallback(function(p6) -- line: 377
		-- upvalues: sendBoundaryErrorTelemetry (copy), t2 (copy), v74 (copy)
		warn("AbuseReportErrorBoundary caught:", p6)
		sendBoundaryErrorTelemetry(p6, {
			abuse_vector = t2.abuseVector,
			target_id = t2.targetId
		})
		v74(true)
	end, {
		t2.abuseVector,
		t2.targetId
	})
	local v92 = useFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, function() -- line: 386
		-- upvalues: v76 (copy)
		v76(false)
	end)
	local v93, v94 = React.useState(true)
	local v95 = React.useCallback(function(b2: boolean) -- line: 390
		-- upvalues: v94 (copy)
		v94(not b2)
	end, {})
	local v96 = React.useCallback(function(p7) -- line: 393
		-- upvalues: v93 (copy), v92 (copy)
		local v111 = if not v93 then nil else p7

		if typeof(v92) == "function" then
			v92(v111)

			return
		end

		if v92 and typeof(v92) == "table" then
			v92.current = v111
		end
	end, {
		v93,
		v92
	})
	local VRCentralOverlay = CoreGui:FindFirstChild("VRCentralOverlay")
	local v98 = if not VRCentralOverlay then nil else VRCentralOverlay:FindFirstChild("CentralOverlay_SurfaceGui")
	local v99 = useIsSpatial()
	local v100 = if not v41 then v98 else useVrOverlay()
	local v101 = React.createElement(Sheet.Root, {
		centerSheetHeight = 1,
		preferCenterSheet = true,
		isOpen = v75,
		onClose = v89,
		snapPoints = { 0.9 },
		size = DialogSize.Medium,
		ref = v96
	}, {
		AbuseReportDialog = if not v71 or v73 then nil else React.createElement(AbuseReportErrorBoundary, {
			onError = v91
		}, {
			AbuseReportContent = React.createElement(AbuseReportContent, {
				ref = v81,
				rawConfig = v71,
				abuseVector = t2.abuseVector,
				targetId = t2.targetId,
				onClose = v88,
				open = v75,
				takeoverFocus = v95,
				onResolveError = v90,
				onFinish = v84
			})
		}),
		LoadingDialog = if v71 or v73 then nil else React.createElement(DynamicReportV2Loading, nil),
		ErrorDialog = if not v73 then nil else React.createElement(DynamicReportV2Error, nil)
	})

	if v41 and v99 and not v100 then
		return nil
	end

	if FFlagEnableInlineSurveyOnUserReport and v77 then
		return React.createElement(OverlayProvider, {
			gui = v100
		}, {
			Survey = React.createElement(InlineSurvey, {
				eventType = InlineEventType.UserReportButtonClicked,
				onEligible = v86,
				onClose = v87
			})
		})
	end

	return React.createElement(OverlayProvider, {
		gui = v100
	}, {
		Sheet = v101
	})
end

return React.memo(if not FFlagAbuseReportMenuV2 then DynamicReportV2Container else DynamicReportV2ContainerV2)
