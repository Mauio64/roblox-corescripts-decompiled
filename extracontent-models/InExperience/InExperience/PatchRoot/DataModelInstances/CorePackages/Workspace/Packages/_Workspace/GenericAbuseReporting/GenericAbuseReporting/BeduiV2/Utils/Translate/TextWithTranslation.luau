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

local defineFastFlag = game:DefineFastFlag("AddFontStyleToTextWithTranslation", false)

local telemetryEventType = analyticsService.TelemetryEventType
local useOptionalAbuseReportAnalytics = AbuseReportAnalyticsContext.useOptionalAbuseReportAnalytics

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

	local text, v3 = React.useMemo(function()
		return translateIntoRichTextString(props.input)
	end, { props.input, translateIntoRichTextString })

	local onActivated = React.useCallback(function()
		local href

		if v3 ~= nil then
			href = v3.href
		end

		if sendEvent and href then
			sendEvent({
				sub_event_type = telemetryEventType.LinkOpened,
				link_detail = { href = href, link_id = props.linkId, source = props.linkSource }
			})
		end

		v(translateIntoString(props.input), href)
	end, { v3, props.input, v, translateIntoString, sendEvent, props.linkId, props.linkSource })

	local onStateChanged = React.useCallback(function(p)
		if p == ControlState.Hover then
			setState(true)
		else
			setState(false)
		end
	end, {})

	local createElement = React.createElement

	if state then
		text = `<u>{text}</u>`
	end

	local v4 = {
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

	v4.fontStyle = fontStyle
	v4.tag = props.tag
	v4.LayoutOrder = props.layoutOrder

	if v3 == nil then
		onActivated = nil
	end

	v4.onActivated = onActivated

	if v3 == nil then
		onStateChanged = nil
	end

	v4.onStateChanged = onStateChanged
	return createElement(Text, v4)
end

return React.memo(TextWithTranslation)
