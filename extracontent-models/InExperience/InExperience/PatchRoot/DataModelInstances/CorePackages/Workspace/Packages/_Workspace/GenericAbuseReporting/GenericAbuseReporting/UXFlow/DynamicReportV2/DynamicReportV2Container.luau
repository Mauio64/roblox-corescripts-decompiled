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
local FFlagEnableReportingFlowForMomentsFeed = require(GenericAbuseReportingParent.SharedFlags).FFlagEnableReportingFlowForMomentsFeed

local function DynamicReportV2Container(t1: {[any]: any}) -- line: 76
	-- upvalues: useRoactService (copy), RoactNetworking (copy), React (copy), FFlagAbuseReportConfigProfileUseAttributesPayload (copy), fetchConfigWithAttributes (copy), fetchConfig (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), sendAnalyticsEvent (copy), getNewRunId (copy), TelemetryEventType (copy), useAbuseSheetFlow (copy), FFlagEnableReportingFlowForMomentsFeed (copy), useFocusNavigationRefs (copy), FocusNavigableSurfaceIdentifierEnum (copy), CoreGui (copy), useIsSpatial (copy), v41 (copy), useVrOverlay (copy), Sheet (copy), DialogSize (copy), ArTranslationProvider (copy), AbuseReportAnalyticsProvider (copy), LayoutSlotsProvider (copy), sheetSlots (copy), AbuseReportDialog (copy), DynamicReportV2Loading (copy), DynamicReportV2Error (copy), OverlayProvider (copy)
	local v51 = useRoactService(RoactNetworking)
	local v52, v53 = React.useState(nil)
	local v54, v55 = React.useState(false)
	local v56, v57 = React.useState(true)

	React.useEffect(function() -- line: 82
		-- upvalues: FFlagAbuseReportConfigProfileUseAttributesPayload (copy), fetchConfigWithAttributes (copy), v51 (copy), t1 (copy), fetchConfig (copy), v53 (copy), v55 (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), sendAnalyticsEvent (copy), getNewRunId (copy), TelemetryEventType (copy);
		((if not FFlagAbuseReportConfigProfileUseAttributesPayload then fetchConfig(v51, t1.abuseVector, t1.targetId) else fetchConfigWithAttributes(v51, t1.abuseVector, {
			targetId = t1.targetId
		}))):andThen(function(p1) -- line: 87
			-- upvalues: v53 (copy)
			v53(p1.responseBody)
		end):catch(function(p2) -- line: 90
			-- upvalues: v55 (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), sendAnalyticsEvent (copy), t1 (copy), getNewRunId (copy), TelemetryEventType (copy)
			warn("Failed to fetch Dynamic Report V2 config:", p2)
			v55(true)

			local v117 = nil

			if FFlagFixAnalyticsForDynamicReportV2 then
				v117 = Dash.pretty(p2, {
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
					error_message = if not FFlagFixAnalyticsForDynamicReportV2 then `Failed to fetch config: ${ tostring(p2) }` else `Failed to fetch config: ${ v117 }`
				}
			})
		end)
	end, {
		v51,
		t1.abuseVector,
		t1.targetId
	})

	local v58 = React.useCallback(function(t2: {[any]: any}) -- line: 114
		-- upvalues: t1 (copy)
		if t2.didSubmit and t1.onSubmit then
			t1.onSubmit()
		end
	end, { t1.onSubmit })
	local v59 = useAbuseSheetFlow(v52, {
		abuseVector = t1.abuseVector,
		targetId = t1.targetId,
		onClose = t1.onClose,
		onFinish = if not FFlagEnableReportingFlowForMomentsFeed or not t1.onSubmit then nil else v58,
		open = v56
	})

	if not v59 and v52 then
		v54 = true
	end

	local v60 = React.useCallback(function() -- line: 132
		-- upvalues: v59 (copy), v57 (copy), t1 (copy)
		if v59 then
			v59.onClose()
		end

		v57(false)
		t1.onClose()
	end, {
		v59,
		t1.onClose
	})
	local v61 = useFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, function() -- line: 146
		-- upvalues: v60 (copy)
		v60()
	end)
	local v62, v63 = React.useState(true)
	local v64 = React.useCallback(function(b1: boolean) -- line: 151
		-- upvalues: v63 (copy)
		v63(not b1)
	end, {})
	local v65 = React.useCallback(function(p3) -- line: 155
		-- upvalues: v62 (copy), v61 (copy)
		local v107 = if not v62 then nil else p3

		if typeof(v61) == "function" then
			v61(v107)

			return
		end

		if v61 and typeof(v61) == "table" then
			v61.current = v107
		end
	end, {
		v62,
		v61
	})
	local VRCentralOverlay = CoreGui:FindFirstChild("VRCentralOverlay")
	local v67 = if not VRCentralOverlay then nil else VRCentralOverlay:FindFirstChild("CentralOverlay_SurfaceGui")
	local v68 = useIsSpatial()
	local v69 = if not v41 then v67 else useVrOverlay()
	local v70 = React.createElement(Sheet.Root, {
		centerSheetHeight = 1,
		preferCenterSheet = true,
		isOpen = v56,
		onClose = v60,
		snapPoints = { 0.9 },
		size = DialogSize.Medium,
		ref = v65
	}, {
		AbuseReportDialog = if not v52 or (v54 or not v59) then nil else React.createElement(ArTranslationProvider, {
			translations = v59.config.translations
		}, React.createElement(AbuseReportAnalyticsProvider, {
			analytics = v59.analytics
		}, React.createElement(LayoutSlotsProvider, {
			slots = sheetSlots
		}, React.createElement(AbuseReportDialog, {
			abuseVector = t1.abuseVector,
			targetId = t1.targetId,
			onClose = v60,
			abuseReportFlow = v59,
			takeoverFocus = v64
		})))),
		LoadingDialog = if v52 or v54 then nil else React.createElement(DynamicReportV2Loading, nil),
		ErrorDialog = if not v54 then nil else React.createElement(DynamicReportV2Error, nil)
	})

	if v41 and v68 and not v69 then
		return nil
	end

	return React.createElement(OverlayProvider, {
		gui = v69
	}, {
		Sheet = v70
	})
end
local function DynamicReportV2ContainerV2(t3: {[any]: any}) -- line: 233
	-- upvalues: useRoactService (copy), RoactNetworking (copy), React (copy), FFlagEnableInlineSurveyOnUserReport (copy), FFlagAbuseReportConfigProfileUseAttributesPayload (copy), fetchConfigWithAttributes (copy), fetchConfig (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), getNewRunId (copy), FFlagEnableReportingFlowForMomentsFeed (copy), FFlagSurvBloxEventTypeEnabled (copy), SurveyEventPublisher (copy), WebViewEventType (copy), AbuseVector (copy), sendBoundaryErrorTelemetry (copy), useFocusNavigationRefs (copy), FocusNavigableSurfaceIdentifierEnum (copy), CoreGui (copy), useIsSpatial (copy), v41 (copy), useVrOverlay (copy), Sheet (copy), DialogSize (copy), AbuseReportErrorBoundary (copy), AbuseReportContent (copy), DynamicReportV2Loading (copy), DynamicReportV2Error (copy), OverlayProvider (copy), InlineSurvey (copy), InlineEventType (copy)
	local v72 = useRoactService(RoactNetworking)
	local v73, v74 = React.useState(nil)
	local v75, v76 = React.useState(false)
	local v77, v78 = React.useState(true)
	local v79 = nil
	local u80 = nil
	local u81 = nil

	if FFlagEnableInlineSurveyOnUserReport then
		local v82

		v79, v82 = React.useState(false)
		u80 = v82
		u81 = React.useRef(false)
	end

	React.useEffect(function() -- line: 247
		-- upvalues: FFlagAbuseReportConfigProfileUseAttributesPayload (copy), fetchConfigWithAttributes (copy), v72 (copy), t3 (copy), fetchConfig (copy), v74 (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), v76 (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), getNewRunId (copy)
		local u108 = false
		local UnixTimestampMillis = DateTime.now().UnixTimestampMillis;

		((if not FFlagAbuseReportConfigProfileUseAttributesPayload then fetchConfig(v72, t3.abuseVector, t3.targetId) else fetchConfigWithAttributes(v72, t3.abuseVector, {
			targetId = t3.targetId
		}))):andThen(function(p4) -- line: 255
			-- upvalues: u108 (ref), UnixTimestampMillis (copy), v74 (copy), sendAnalyticsEvent (copy), t3 (copy), TelemetryEventType (copy)
			if u108 then
				return
			end

			local responseBody = p4.responseBody
			local v120 = DateTime.now().UnixTimestampMillis - UnixTimestampMillis

			v74(responseBody)
			sendAnalyticsEvent({
				run_id = "unknown",
				total_duration = 0,
				abuse_vector = t3.abuseVector,
				target_id = t3.targetId,
				path = {},
				config_name = responseBody.name
			}, {
				sub_event_type = TelemetryEventType.ConfigLoaded,
				config_load_detail = {
					cache_hit = false,
					retry_count = 0,
					load_duration_ms = v120
				}
			})
		end):catch(function(p5) -- line: 280
			-- upvalues: u108 (ref), v76 (copy), FFlagFixAnalyticsForDynamicReportV2 (copy), Dash (copy), sendAnalyticsEvent (copy), t3 (copy), getNewRunId (copy), TelemetryEventType (copy)
			if u108 then
				return
			end

			warn("Failed to fetch Dynamic Report V2 config:", p5)
			v76(true)

			local v122 = nil

			if FFlagFixAnalyticsForDynamicReportV2 then
				v122 = Dash.pretty(p5, {
					depth = 10,
					multiline = true
				})
			end

			sendAnalyticsEvent({
				total_duration = 0,
				abuse_vector = t3.abuseVector,
				target_id = t3.targetId,
				run_id = getNewRunId(),
				path = {}
			}, {
				sub_event_type = TelemetryEventType.Error,
				error_detail = {
					error_message = if not FFlagFixAnalyticsForDynamicReportV2 then `Failed to fetch config: { tostring(p5) }` else `Failed to fetch config: { v122 }`
				}
			})
		end)

		return function() -- line: 305
			-- upvalues: u108 (ref)
			u108 = true
		end
	end, {
		v72,
		t3.abuseVector,
		t3.targetId
	})

	local v83 = React.useRef(nil)
	local v84 = React.useRef(false)
	local u85 = nil
	local v86 = nil
	local u87 = nil
	local v88 = nil
	local v89 = nil

	if FFlagEnableInlineSurveyOnUserReport then
		u85 = React.useRef(false)
		v86 = React.useCallback(function(t4: {[any]: any}) -- line: 329
			-- upvalues: u85 (ref), FFlagEnableReportingFlowForMomentsFeed (copy), t3 (copy)
			if t4.didSubmit then
				u85.current = true

				if FFlagEnableReportingFlowForMomentsFeed and t3.onSubmit then
					t3.onSubmit()
				end
			end
		end, { t3.onSubmit })
		u87 = React.useCallback(function() -- line: 338
			-- upvalues: FFlagSurvBloxEventTypeEnabled (copy), SurveyEventPublisher (copy), WebViewEventType (copy)
			if FFlagSurvBloxEventTypeEnabled then
				SurveyEventPublisher.publishSurveyEvent(WebViewEventType.ReportSubmitted)
			end
		end, {})
		v88 = React.useCallback(function() -- line: 344
			-- upvalues: u81 (ref)
			u81.current = true
		end, {})
		v89 = React.useCallback(function() -- line: 348
			-- upvalues: u81 (ref), u87 (ref), t3 (copy)
			if not u81.current then
				u87()
			end

			t3.onClose()
		end, {
			u87,
			t3.onClose
		})
	end

	local v90 = React.useCallback(function() -- line: 356
		-- upvalues: v84 (copy), v78 (copy)
		v84.current = true
		v78(false)
	end, {})
	local v91 = React.useCallback(function() -- line: 364
		-- upvalues: v84 (copy), v83 (copy), v78 (copy), FFlagEnableInlineSurveyOnUserReport (copy), u85 (ref), t3 (copy), AbuseVector (copy), u80 (ref), u87 (ref)
		if not v84.current and v83.current then
			v83.current.requestClose()
		end

		v78(false)

		if FFlagEnableInlineSurveyOnUserReport then
			if not u85.current then
				t3.onClose()

				return
			end

			if t3.abuseVector == AbuseVector.UserProfile then
				u80(true)

				return
			end

			u87()
		end

		t3.onClose()
	end, {
		t3.onClose,
		t3.abuseVector,
		u87
	})
	local v92 = React.useCallback(function() -- line: 388
		-- upvalues: v76 (copy)
		v76(true)
	end, {})
	local v93 = React.useCallback(function(p6) -- line: 392
		-- upvalues: sendBoundaryErrorTelemetry (copy), t3 (copy), v76 (copy)
		warn("AbuseReportErrorBoundary caught:", p6)
		sendBoundaryErrorTelemetry(p6, {
			abuse_vector = t3.abuseVector,
			target_id = t3.targetId
		})
		v76(true)
	end, {
		t3.abuseVector,
		t3.targetId
	})
	local v94 = useFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, function() -- line: 401
		-- upvalues: v78 (copy)
		v78(false)
	end)
	local v95, v96 = React.useState(true)
	local v97 = React.useCallback(function(b2: boolean) -- line: 405
		-- upvalues: v96 (copy)
		v96(not b2)
	end, {})
	local v98 = React.useCallback(function(p7) -- line: 408
		-- upvalues: v95 (copy), v94 (copy)
		local v114 = if not v95 then nil else p7

		if typeof(v94) == "function" then
			v94(v114)

			return
		end

		if v94 and typeof(v94) == "table" then
			v94.current = v114
		end
	end, {
		v95,
		v94
	})
	local VRCentralOverlay = CoreGui:FindFirstChild("VRCentralOverlay")
	local v100 = if not VRCentralOverlay then nil else VRCentralOverlay:FindFirstChild("CentralOverlay_SurfaceGui")
	local v101 = useIsSpatial()
	local v102 = if not v41 then v100 else useVrOverlay()
	local v103 = React.createElement(Sheet.Root, {
		centerSheetHeight = 1,
		preferCenterSheet = true,
		isOpen = v77,
		onClose = v91,
		snapPoints = { 0.9 },
		size = DialogSize.Medium,
		ref = v98
	}, {
		AbuseReportDialog = if not v73 or v75 then nil else React.createElement(AbuseReportErrorBoundary, {
			onError = v93
		}, {
			AbuseReportContent = React.createElement(AbuseReportContent, {
				ref = v83,
				rawConfig = v73,
				abuseVector = t3.abuseVector,
				targetId = t3.targetId,
				onClose = v90,
				open = v77,
				takeoverFocus = v97,
				onResolveError = v92,
				onFinish = v86
			})
		}),
		LoadingDialog = if v73 or v75 then nil else React.createElement(DynamicReportV2Loading, nil),
		ErrorDialog = if not v75 then nil else React.createElement(DynamicReportV2Error, nil)
	})

	if v41 and v101 and not v102 then
		return nil
	end

	if FFlagEnableInlineSurveyOnUserReport and v79 then
		return React.createElement(OverlayProvider, {
			gui = v102
		}, {
			Survey = React.createElement(InlineSurvey, {
				eventType = InlineEventType.UserReportButtonClicked,
				onEligible = v88,
				onClose = v89
			})
		})
	end

	return React.createElement(OverlayProvider, {
		gui = v102
	}, {
		Sheet = v103
	})
end

return React.memo(if not FFlagAbuseReportMenuV2 then DynamicReportV2Container else DynamicReportV2ContainerV2)
