local CoreGui = game:GetService("CoreGui")

local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/FocusNavigationUtils")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Responsive")
local roactNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RoactServiceTags").RoactNetworking
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/RobloxAppHooks").useRoactService

local InlineEventType = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/OnPlatformSurveys/InlineEventType")
local InlineSurvey = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/OnPlatformSurveys/InlineSurvey")
local SurveyEventPublisher = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/OnPlatformSurveys/SurveyEventPublisher")
local WebViewEventType = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/OnPlatformSurveys/WebViewEventType")

local dialogSize = Foundation.Enums.DialogSize
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local overlayProvider = Foundation.OverlayProvider
local sheet = Foundation.Sheet
local useIsSpatial = Responsive.useIsSpatial

local AbuseReportErrorBoundary = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/AbuseReportErrorBoundary")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")
local analyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService")
local DynamicReportV2Error = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DynamicReportV2/DynamicReportV2Error")
local DynamicReportV2Loading = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DynamicReportV2/DynamicReportV2Loading")
local fetchConfigWithAttributes = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/fetchConfigWithAttributes")
local getNewRunId = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/reducer").getNewRunId
local module16 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/UXFlow/DynamicReportV2/AbuseReportContent")
local sendBoundaryErrorTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/sendBoundaryErrorTelemetry")
local useFocusNavigationRefs = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/FocusNavigation/useFocusNavigationRefs")
local useVrOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/useVrOverlay")

local formatErrorDetailForAnalytics = analyticsService.formatErrorDetailForAnalytics
local sendAnalyticsEvent = analyticsService.sendAnalyticsEvent
local telemetryEventType = analyticsService.TelemetryEventType

local defineFastFlag = game:DefineFastFlag("FixDynamicReportV2VRAsync", false)
local fFlagEnableInlineSurveyOnUserReport = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagEnableInlineSurveyOnUserReport
local fFlagSurvBloxEventTypeEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagSurvBloxEventTypeEnabled
local fFlagAbuseReportAttributes = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagAbuseReportAttributes
local FFlagAbuseReportImproveErrorEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportImproveErrorEvents")

local function DynamicReportV2Container(props)
	local v5 = useRoactService(roactNetworking)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(true)
	local v6 = if fFlagAbuseReportAttributes then props.analyticsTargetId else props.targetId
	local ref

	if fFlagAbuseReportAttributes then
		ref = React.useRef(v6)
		ref.current = v6
	else
		ref = nil
	end

	local state4, setState4, ref2

	if fFlagEnableInlineSurveyOnUserReport then
		state4, setState4 = React.useState(false)

		ref2 = React.useRef(false)
	else
		ref2 = nil
		setState4 = nil
	end

	local v7 = if fFlagAbuseReportAttributes then props.attributes else props.targetId

	if fFlagAbuseReportAttributes then
		local ref3 = React.useRef(props.attributes)

		if not Dash.shallowEqual(ref3.current, props.attributes) then
			ref3.current = props.attributes
		end

		v7 = ref3.current or false
	end

	React.useEffect(function()
		local flag = false
		local unixTimestampMillis = DateTime.now().UnixTimestampMillis

		local abuseVector = props.abuseVector
		local v10

		if fFlagAbuseReportAttributes then
			v10 = props.attributes
		else
			v10 = { targetId = props.targetId }
		end

		fetchConfigWithAttributes(v5, abuseVector, v10):andThen(function(p2)
			if flag then
				return
			end

			local responseBody = p2.responseBody
			local v11 = DateTime.now().UnixTimestampMillis - unixTimestampMillis
			setState(responseBody)
			local v13 = {
				abuse_vector = props.abuseVector,
				target_id = 0,
				run_id = "unknown",
				total_duration = 0,
				path = 0,
				config_name = 0
			}
			local v14 = if fFlagAbuseReportAttributes then ref.current else props.targetId
			v13.target_id = v14

			v13.path = {}
			v13.config_name = responseBody.name
			sendAnalyticsEvent(v13, {
				sub_event_type = telemetryEventType.ConfigLoaded,
				config_load_detail = {
					load_duration_ms = v11,
					cache_hit = false,
					retry_count = 0
				}
			})
		end):catch(function(p2)
			if flag then
				return
			end

			warn("Failed to fetch Dynamic Report V2 config:", p2)
			setState2(true)
			local v12 = {
				abuse_vector = props.abuseVector,
				target_id = 0,
				run_id = 0,
				total_duration = 0,
				path = 0
			}
			local v13 = if fFlagAbuseReportAttributes then ref.current else props.targetId
			v12.target_id = v13
			v12.run_id = getNewRunId()

			v12.path = {}
			local v14 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }

			local v15 = if FFlagAbuseReportImproveErrorEvents then formatErrorDetailForAnalytics("Failed to fetch config", p2) else {
				error_message = "Failed to fetch config: " .. Dash.pretty(p2, {
					depth = 10,
					multiline = true
				})
			}
			v14.error_detail = v15
			sendAnalyticsEvent(v12, v14)
		end)
		return function()
			flag = true
		end
	end, { v5, props.abuseVector, v7 })

	local ref3 = React.useRef(nil)

	local ref4 = React.useRef(false)
	local ref5, v8, v9, v10, v11

	if fFlagEnableInlineSurveyOnUserReport then
		ref5 = React.useRef(false)

		v8 = React.useCallback(function(p2)
			if p2.didSubmit then
				ref5.current = true

				if props.onSubmit then
					props.onSubmit()
				end
			end
		end, { props.onSubmit })

		v9 = React.useCallback(function()
			if fFlagSurvBloxEventTypeEnabled then
				SurveyEventPublisher.publishSurveyEvent(WebViewEventType.ReportSubmitted)
			end
		end, {})

		v10 = React.useCallback(function()
			ref2.current = true
		end, {})

		v11 = React.useCallback(function()
			if not ref2.current then
				v9()
			end

			props.onClose()
		end, { v9, props.onClose })
	else
		ref5 = nil
		v9 = nil
	end

	local v12 = React.useCallback(function()
		ref4.current = true
		setState3(false)
	end, {})

	local v13 = React.useCallback(function()
		if not ref4.current and ref3.current then
			ref3.current.requestClose()
		end

		setState3(false)

		if fFlagEnableInlineSurveyOnUserReport then
			if not ref5.current then
				props.onClose()
				return
			end

			if props.abuseVector == AbuseVector.UserProfile then
				setState4(true)
				return
			end

			v9()
		end

		props.onClose()
	end, { props.onClose, props.abuseVector, v9 })

	local v14 = React.useCallback(function()
		setState2(true)
	end, {})

	local v15 = React.useCallback(function(p2)
		warn("AbuseReportErrorBoundary caught:", p2)
		sendBoundaryErrorTelemetry(p2, { abuse_vector = props.abuseVector, target_id = v6 })

		setState2(true)
	end, { props.abuseVector, v6 })

	local v16 = useFocusNavigationRefs(focusNavigableSurfaceIdentifierEnum.CentralOverlay, function()
		setState3(false)
	end)
	local state5, setState5 = React.useState(true)
	local v17 = React.useCallback(function(p2)
		setState5(not p2)
	end, {})
	local v18 = React.useCallback(function(current)
		if not state5 then
			current = nil
		end

		if typeof(v16) == "function" then
			v16(current)
		elseif v16 and typeof(v16) == "table" then
			v16.current = current
		end
	end, { state5, v16 })

	local vrCentralOverlay = CoreGui:FindFirstChild("VRCentralOverlay")
	local v19

	if vrCentralOverlay then
		v19 = vrCentralOverlay:FindFirstChild("CentralOverlay_SurfaceGui")
	end

	local v20 = useIsSpatial()

	if defineFastFlag then
		v19 = useVrOverlay()
	end

	local createElement = React.createElement
	local root = sheet.Root
	local v21 = {
		centerSheetHeight = 1,
		isOpen = state3,
		onClose = v13,
		preferCenterSheet = true,
		snapPoints = { 0.9 },
		size = dialogSize.Medium,
		ref = v18
	}

	local v23 = if state and not state2 then React.createElement(AbuseReportErrorBoundary, {
		onError = v15
	}, {
		AbuseReportContent = React.createElement(module16, {
			ref = ref3,
			rawConfig = state,
			abuseVector = props.abuseVector,
			analyticsTargetId = v6,
			onClose = v12,
			open = state3,
			takeoverFocus = v17,
			onResolveError = v14,
			onCustomSubmit = props.onCustomSubmit,
			clientActionHandlers = props.clientActionHandlers,
			onFinish = v8
		})
	}) else nil

	local v24 = if not (state or state2) then React.createElement(DynamicReportV2Loading, nil) else nil

	local v25 = if state2 then React.createElement(DynamicReportV2Error, nil) else nil
	local element = createElement(root, v21, {
		AbuseReportDialog = v23,
		LoadingDialog = v24,
		ErrorDialog = v25
	})

	if defineFastFlag and v20 and not v19 then
		return nil
	end

	if fFlagEnableInlineSurveyOnUserReport and state4 then
		return React.createElement(overlayProvider, { gui = v19 }, {
			Survey = React.createElement(InlineSurvey, {
				eventType = InlineEventType.UserReportButtonClicked,
				onEligible = v10,
				onClose = v11
			})
		})
	end

	return React.createElement(overlayProvider, { gui = v19 }, { Sheet = element })
end

return React.memo(DynamicReportV2Container)
