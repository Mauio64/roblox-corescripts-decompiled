local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local CoreGui = game:GetService("CoreGui")

local Dash = require(parent.Dash)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local RoactServiceTags = require(parent.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService

local InlineEventType = require(parent.OnPlatformSurveys.InlineEventType)
local InlineSurvey = require(parent.OnPlatformSurveys.InlineSurvey)
local SurveyEventPublisher = require(parent.OnPlatformSurveys.SurveyEventPublisher)
local WebViewEventType = require(parent.OnPlatformSurveys.WebViewEventType)

local DialogSize = Foundation.Enums.DialogSize
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local OverlayProvider = Foundation.OverlayProvider
local Sheet = Foundation.Sheet
local useIsSpatial = Responsive.useIsSpatial

local AbuseReportErrorBoundary = require(GenericAbuseReporting.BeduiV2.Components.AbuseReportErrorBoundary)
require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local AbuseVector = require(GenericAbuseReporting.Enums.AbuseVector)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local DynamicReportV2Error = require(script.Parent.DynamicReportV2Error)
local DynamicReportV2Loading = require(script.Parent.DynamicReportV2Loading)
local fetchConfigWithAttributes = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.fetchConfigWithAttributes)
local reducer = require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.reducer)
local getNewRunId = reducer.getNewRunId
local AbuseReportContent = require(script.Parent.AbuseReportContent)
local sendBoundaryErrorTelemetry = require(GenericAbuseReporting.BeduiV2.Analytics.sendBoundaryErrorTelemetry)
local useFocusNavigationRefs = require(GenericAbuseReporting.BeduiV2.Hooks.FocusNavigation.useFocusNavigationRefs)
local useVrOverlay = require(GenericAbuseReporting.BeduiV2.Hooks.useVrOverlay)

local formatErrorDetailForAnalytics = analyticsService.formatErrorDetailForAnalytics
local sendAnalyticsEvent = analyticsService.sendAnalyticsEvent
local telemetryEventType = analyticsService.TelemetryEventType

local defineFastFlag = game:DefineFastFlag("FixDynamicReportV2VRAsync", false)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableInlineSurveyOnUserReport = SharedFlags.FFlagEnableInlineSurveyOnUserReport
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSurvBloxEventTypeEnabled = SharedFlags2.FFlagSurvBloxEventTypeEnabled
local SharedFlags3 = require(parent.SharedFlags)
local FFlagAbuseReportAttributes = SharedFlags3.FFlagAbuseReportAttributes
local FFlagAbuseReportImproveErrorEvents = require(GenericAbuseReporting.Flags.FFlagAbuseReportImproveErrorEvents)

local function DynamicReportV2Container(props)
	local v = useRoactService(RoactNetworking)
	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(true)
	local v2

	if FFlagAbuseReportAttributes then
		v2 = props.analyticsTargetId
	else
		v2 = props.targetId
	end

	local ref

	if FFlagAbuseReportAttributes then
		ref = React.useRef(v2)
		ref.current = v2
	else
		ref = nil
	end

	local state4, setState4, ref2

	if FFlagEnableInlineSurveyOnUserReport then
		state4, setState4 = React.useState(false)

		ref2 = React.useRef(false)
	else
		ref2 = nil
		setState4 = nil
	end

	local v3

	if FFlagAbuseReportAttributes then
		v3 = props.attributes
	else
		v3 = props.targetId
	end

	if FFlagAbuseReportAttributes then
		local ref3 = React.useRef(props.attributes)

		if not Dash.shallowEqual(ref3.current, props.attributes) then
			ref3.current = props.attributes
		end

		v3 = ref3.current or false
	end

	React.useEffect(function()
		local flag = false
		local unixTimestampMillis = DateTime.now().UnixTimestampMillis

		local abuseVector = props.abuseVector
		local v4

		if FFlagAbuseReportAttributes then
			v4 = props.attributes
		else
			v4 = { targetId = props.targetId }
		end

		fetchConfigWithAttributes(v, abuseVector, v4):andThen(function(p)
			if flag then
				return
			end

			local responseBody = p.responseBody
			local load_duration_ms = DateTime.now().UnixTimestampMillis - unixTimestampMillis
			setState(responseBody)
			local v5 = {
				abuse_vector = props.abuseVector,
				target_id = 0,
				run_id = "unknown",
				total_duration = 0,
				path = 0,
				config_name = 0
			}
			local target_id

			if FFlagAbuseReportAttributes then
				target_id = ref.current
			else
				target_id = props.targetId
			end

			v5.target_id = target_id

			v5.path = {}
			v5.config_name = responseBody.name
			sendAnalyticsEvent(v5, {
				sub_event_type = telemetryEventType.ConfigLoaded,
				config_load_detail = {
					load_duration_ms = load_duration_ms,
					cache_hit = false,
					retry_count = 0
				}
			})
		end):catch(function(p)
			if flag then
				return
			end

			warn("Failed to fetch Dynamic Report V2 config:", p)
			setState2(true)
			local v5 = {
				abuse_vector = props.abuseVector,
				target_id = 0,
				run_id = 0,
				total_duration = 0,
				path = 0
			}
			local target_id

			if FFlagAbuseReportAttributes then
				target_id = ref.current
			else
				target_id = props.targetId
			end

			v5.target_id = target_id
			v5.run_id = getNewRunId()

			v5.path = {}
			local v6 = { sub_event_type = telemetryEventType.Error, error_detail = 0 }
			local error_detail

			if FFlagAbuseReportImproveErrorEvents then
				error_detail = formatErrorDetailForAnalytics("Failed to fetch config", p)
			else
				error_detail = {
					error_message = "Failed to fetch config: " .. Dash.pretty(p, {
						depth = 10,
						multiline = true
					})
				}
			end

			v6.error_detail = error_detail
			sendAnalyticsEvent(v5, v6)
		end)
		return function()
			flag = true
		end
	end, { v, props.abuseVector, v3 })

	local ref3 = React.useRef(nil)

	local ref4 = React.useRef(false)
	local ref5, onFinish, v4, onEligible, onClose

	if FFlagEnableInlineSurveyOnUserReport then
		ref5 = React.useRef(false)

		onFinish = React.useCallback(function(p)
			if p.didSubmit then
				ref5.current = true

				if props.onSubmit then
					props.onSubmit()
				end
			end
		end, { props.onSubmit })

		v4 = React.useCallback(function()
			if FFlagSurvBloxEventTypeEnabled then
				SurveyEventPublisher.publishSurveyEvent(WebViewEventType.ReportSubmitted)
			end
		end, {})

		onEligible = React.useCallback(function()
			ref2.current = true
		end, {})

		onClose = React.useCallback(function()
			if not ref2.current then
				v4()
			end

			props.onClose()
		end, { v4, props.onClose })
	else
		ref5 = nil
		v4 = nil
	end

	local onClose2 = React.useCallback(function()
		ref4.current = true
		setState3(false)
	end, {})

	local onClose3 = React.useCallback(function()
		if not ref4.current and ref3.current then
			ref3.current.requestClose()
		end

		setState3(false)

		if FFlagEnableInlineSurveyOnUserReport then
			if not ref5.current then
				props.onClose()
				return
			end

			if props.abuseVector == AbuseVector.UserProfile then
				setState4(true)
				return
			end

			v4()
		end

		props.onClose()
	end, { props.onClose, props.abuseVector, v4 })

	local onResolveError = React.useCallback(function()
		setState2(true)
	end, {})

	local onError = React.useCallback(function(p)
		warn("AbuseReportErrorBoundary caught:", p)
		sendBoundaryErrorTelemetry(p, { abuse_vector = props.abuseVector, target_id = v2 })

		setState2(true)
	end, { props.abuseVector, v2 })

	local v5 = useFocusNavigationRefs(FocusNavigableSurfaceIdentifierEnum.CentralOverlay, function()
		setState3(false)
	end)
	local state5, setState5 = React.useState(true)
	local takeoverFocus = React.useCallback(function(flag: boolean)
		setState5(not flag)
	end, {})
	local ref6 = React.useCallback(function(current)
		if not state5 then
			current = nil
		end

		if typeof(v5) == "function" then
			v5(current)
		elseif v5 and typeof(v5) == "table" then
			v5.current = current
		end
	end, { state5, v5 })

	local vrCentralOverlay = CoreGui:FindFirstChild("VRCentralOverlay")
	local gui

	if vrCentralOverlay then
		gui = vrCentralOverlay:FindFirstChild("CentralOverlay_SurfaceGui")
	end

	local v6 = useIsSpatial()

	if defineFastFlag then
		gui = useVrOverlay()
	end

	local createElement = React.createElement
	local root = Sheet.Root
	local v7 = {
		centerSheetHeight = 1,
		isOpen = state3,
		onClose = onClose3,
		preferCenterSheet = true,
		snapPoints = { 0.9 },
		size = DialogSize.Medium,
		ref = ref6
	}
	local abuseReportDialog

	if state and not state2 then
		abuseReportDialog = React.createElement(AbuseReportErrorBoundary, { onError = onError }, {
			AbuseReportContent = React.createElement(AbuseReportContent, {
				ref = ref3,
				rawConfig = state,
				abuseVector = props.abuseVector,
				analyticsTargetId = v2,
				onClose = onClose2,
				open = state3,
				takeoverFocus = takeoverFocus,
				onResolveError = onResolveError,
				onCustomSubmit = props.onCustomSubmit,
				clientActionHandlers = props.clientActionHandlers,
				onFinish = onFinish
			})
		})
	end

	local loadingDialog

	if not (state or state2) then
		loadingDialog = React.createElement(DynamicReportV2Loading, nil)
	end

	local errorDialog

	if state2 then
		errorDialog = React.createElement(DynamicReportV2Error, nil)
	end

	local element = createElement(root, v7, {
		AbuseReportDialog = abuseReportDialog,
		LoadingDialog = loadingDialog,
		ErrorDialog = errorDialog
	})

	if defineFastFlag and v6 and not gui then
		return nil
	end

	if FFlagEnableInlineSurveyOnUserReport and state4 then
		return React.createElement(OverlayProvider, { gui = gui }, {
			Survey = React.createElement(InlineSurvey, {
				eventType = InlineEventType.UserReportButtonClicked,
				onEligible = onEligible,
				onClose = onClose
			})
		})
	end

	return React.createElement(OverlayProvider, { gui = gui }, { Sheet = element })
end

return React.memo(DynamicReportV2Container)
