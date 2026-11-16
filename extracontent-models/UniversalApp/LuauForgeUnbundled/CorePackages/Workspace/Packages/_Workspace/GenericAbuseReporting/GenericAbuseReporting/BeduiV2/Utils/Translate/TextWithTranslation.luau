local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local controlState = Foundation.Enums.ControlState
local text = Foundation.Text

local AbuseReportAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/AbuseReportAnalyticsContext")
local analyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService")
local useOpenLink = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/useOpenLink")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")
local useArTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/arTranslation").useArTranslation

local defineFastFlag = game:DefineFastFlag("AddFontStyleToTextWithTranslation", false)

local telemetryEventType = analyticsService.TelemetryEventType
local useOptionalAbuseReportAnalytics = AbuseReportAnalyticsContext.useOptionalAbuseReportAnalytics

local function TextWithTranslation(props)
	local translateIntoString = useArTranslation().translateIntoString
	local translateIntoRichTextString = useArTranslation().translateIntoRichTextString
	local v5 = useOpenLink()
	local state, setState = React.useState(false)

	local v6 = useOptionalAbuseReportAnalytics()
	local sendEvent = if v6 then v6.sendEvent else nil

	local v7, v8 = React.useMemo(function()
		return translateIntoRichTextString(props.input)
	end, { props.input, translateIntoRichTextString })

	local v9 = React.useCallback(function()
		local href = if v8 ~= nil then v8.href else nil

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
		v8,
		props.input,
		v5,
		translateIntoString,
		sendEvent,
		props.linkId,
		props.linkSource
	})

	local v10 = React.useCallback(function(p2)
		if p2 == controlState.Hover then
			setState(true)
		else
			setState(false)
		end
	end, {})

	local createElement = React.createElement

	if state then
		v7 = `<u>{v7}</u>`
	end

	local v12 = {
		Text = v7,
		RichText = true,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		fontStyle = 0,
		tag = 0,
		LayoutOrder = 0,
		onActivated = 0,
		onStateChanged = 0
	}
	local v13 = if defineFastFlag then props.fontStyle else nil
	v12.fontStyle = v13
	v12.tag = props.tag
	v12.LayoutOrder = props.layoutOrder

	if v8 == nil then
		v9 = nil
	end

	v12.onActivated = v9

	if v8 == nil then
		v10 = nil
	end

	v12.onStateChanged = v10
	return createElement(text, v12)
end

return React.memo(TextWithTranslation)
