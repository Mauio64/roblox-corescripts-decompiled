local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local controlState = Foundation.Enums.ControlState
local text = Foundation.Text

local AbuseReportAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/AbuseReportAnalyticsContext")
local analyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService")
local useOpenLink = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/useOpenLink")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")
local useArTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/arTranslation").useArTranslation

local telemetryEventType = analyticsService.TelemetryEventType
local useOptionalAbuseReportAnalytics = AbuseReportAnalyticsContext.useOptionalAbuseReportAnalytics

local FFlagAbuseReportTranslateColorWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Flags/FFlagAbuseReportTranslateColorWrapper")
local defineFastFlag = game:DefineFastFlag("AddFontStyleToTextWithTranslation", false)

local function TextWithTranslation(props)
	local translateIntoString = useArTranslation().translateIntoString
	local translateIntoRichTextString = useArTranslation().translateIntoRichTextString
	local v5 = useOpenLink()
	local state, setState = React.useState(false)

	local v6 = useOptionalAbuseReportAnalytics()
	local sendEvent = if v6 then v6.sendEvent else nil

	local v7 = FFlagAbuseReportTranslateColorWrapper and state
	local v8, v9 = React.useMemo(function()
		return translateIntoRichTextString(props.input, v7)
	end, { props.input, translateIntoRichTextString, v7 })

	local v10 = React.useCallback(function()
		local href = if v9 ~= nil then v9.href else nil

		if sendEvent and href then
			sendEvent({
				sub_event_type = telemetryEventType.LinkOpened,
				link_detail = {
					href = href,
					link_id = props.linkId,
					source = props.linkSource
				}
			})
		end

		v5(translateIntoString(props.input), href)
	end, {
		v9,
		props.input,
		v5,
		translateIntoString,
		sendEvent,
		props.linkId,
		props.linkSource
	})

	local v11 = React.useCallback(function(p2)
		if p2 == controlState.Hover then
			setState(true)
		else
			setState(false)
		end
	end, {})

	local createElement = React.createElement

	if state and not FFlagAbuseReportTranslateColorWrapper then
		v8 = `<u>{v8}</u>`
	end

	local v13 = {
		Text = v8,
		RichText = true,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		fontStyle = 0,
		tag = 0,
		LayoutOrder = 0,
		onActivated = 0,
		onStateChanged = 0
	}
	local v14 = if defineFastFlag then props.fontStyle else nil
	v13.fontStyle = v14
	v13.tag = props.tag
	v13.LayoutOrder = props.layoutOrder

	if v9 == nil then
		v10 = nil
	end

	v13.onActivated = v10

	if v9 == nil then
		v11 = nil
	end

	v13.onStateChanged = v11
	return createElement(text, v13)
end

return React.memo(TextWithTranslation)
