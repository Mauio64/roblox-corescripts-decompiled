local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local ControlState = Foundation.Enums.ControlState
local Text = Foundation.Text

local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local useOpenLink = require(GenericAbuseReporting.BeduiV2.Hooks.useOpenLink)
require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)
local arTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation)
local useArTranslation = arTranslation.useArTranslation

local telemetryEventType = analyticsService.TelemetryEventType
local useOptionalAbuseReportAnalytics = AbuseReportAnalyticsContext.useOptionalAbuseReportAnalytics

local FFlagAbuseReportTranslateColorWrapper = require(GenericAbuseReporting.Flags.FFlagAbuseReportTranslateColorWrapper)
local defineFastFlag = game:DefineFastFlag("AddFontStyleToTextWithTranslation", false)

local function TextWithTranslation(props)
	local translateIntoString = useArTranslation().translateIntoString
	local translateIntoRichTextString = useArTranslation().translateIntoRichTextString
	local v = useOpenLink()
	local state, setState = React.useState(false)

	local v2 = useOptionalAbuseReportAnalytics()
	local sendEvent

	if v2 then
		sendEvent = v2.sendEvent
	else
		sendEvent = nil
	end

	local v3 = FFlagAbuseReportTranslateColorWrapper and state
	local text, v4 = React.useMemo(function()
		return translateIntoRichTextString(props.input, v3)
	end, { props.input, translateIntoRichTextString, v3 })

	local onActivated = React.useCallback(function()
		local href

		if v4 ~= nil then
			href = v4.href
		end

		if sendEvent and href then
			sendEvent({
				sub_event_type = telemetryEventType.LinkOpened,
				link_detail = { href = href, link_id = props.linkId, source = props.linkSource }
			})
		end

		v(translateIntoString(props.input), href)
	end, { v4, props.input, v, translateIntoString, sendEvent, props.linkId, props.linkSource })

	local onStateChanged = React.useCallback(function(p)
		if p == ControlState.Hover then
			setState(true)
		else
			setState(false)
		end
	end, {})

	local createElement = React.createElement

	if state and not FFlagAbuseReportTranslateColorWrapper then
		text = `<u>{text}</u>`
	end

	local v5 = {
		Text = text,
		RichText = true,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		fontStyle = 0,
		tag = 0,
		LayoutOrder = 0,
		onActivated = 0,
		onStateChanged = 0
	}
	local fontStyle

	if defineFastFlag then
		fontStyle = props.fontStyle
	end

	v5.fontStyle = fontStyle
	v5.tag = props.tag
	v5.LayoutOrder = props.layoutOrder

	if v4 == nil then
		onActivated = nil
	end

	v5.onActivated = onActivated

	if v4 == nil then
		onStateChanged = nil
	end

	v5.onStateChanged = onStateChanged
	return createElement(Text, v5)
end

return React.memo(TextWithTranslation)
