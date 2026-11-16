local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local textArea = Foundation.TextArea

local AbuseReportAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/AbuseReportAnalyticsContext")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local analyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Eyebrow")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Footer")
local getCodePointLength = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/getCodePointLength")
local LayoutSlots = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/LayoutSlots")
local translate = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")
local useArTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/arTranslation").useArTranslation

local telemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots

local function CommentNode(props)
	local v5, v6 = React.useBinding(props.initialValue or "")
	local state, setState = React.useState(false)
	local mergeTranslationParams = translate.mergeTranslationParams
	local translateIntoString = useArTranslation().translateIntoString
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local ref = React.useRef(false)

	local v7 = useLayoutSlots()
	local title = v7.Title
	local layout = v7.Layout

	local v8 = React.useCallback(function(p2)
		v6(p2)

		if props.maxLength then
			local v9 = getCodePointLength(p2) > props.maxLength
			setState(v9)

			if v9 then
				ref.current = true
			end
		end
	end, { props.maxLength })

	local v9 = React.useCallback(function()
		sendEvent({
			sub_event_type = telemetryEventType.CommentInput,
			comment_input_detail = {
				comment_length = getCodePointLength(v5:getValue()),
				has_initial_value = props.initialValue ~= nil and props.initialValue ~= "",
				did_modify_initial = props.initialValue ~= nil and v5:getValue() ~= props.initialValue,
				hit_character_limit = ref.current,
				max_length = props.maxLength or 0
			}
		})

		if props.onNext then
			props.onNext(v5:getValue())
		end
	end, { v5, props.onNext, sendEvent, props.initialValue, props.maxLength })

	local v10 = React.useCallback(function(p2)
		if props.helperText and props.maxLength and mergeTranslationParams then
			return translateIntoString(mergeTranslationParams(props.helperText, {
				currentLength = tostring(getCodePointLength(p2)),
				maxLength = tostring(props.maxLength)
			}))
		end

		if props.helperText then
			return translateIntoString(props.helperText)
		end

		return nil
	end, { props.helperText, props.maxLength })

	local v11 = {
		Eyebrow = React.createElement(module5, {
			eyebrow = props.eyebrow,
			layoutOrder = 0
		}),
		Title = React.createElement(title, {
			input = props.title,
			subtitle = props.subtitle,
			layoutOrder = 1
		}),
		TextArea = 0,
		Footer = 0
	}

	local createElement = React.createElement
	local v13 = {
		text = v5,
		hint = 0,
		numLines = 6,
		onChanged = 0,
		label = 0,
		placeholder = 0,
		hasError = 0,
		width = 0,
		LayoutOrder = 2
	}
	local v14

	if props.helperText then
		v14 = v5:map(function(p2)
			return v10(p2)
		end)
	end

	v13.hint = v14

	v13.onChanged = v8
	v13.label = not props.textAreaLabel and "" or translateIntoString(props.textAreaLabel)
	v13.placeholder = translateIntoString(props.placeholder or "")
	v13.hasError = state
	v13.width = UDim.new(1, 0)
	v11.TextArea = createElement(textArea, v13)

	local v15 = if props.footerItems then React.createElement(module6, {
		footerItems = props.footerItems,
		additionalTag = "padding-top-medium",
		layoutOrder = 3
	}) else nil
	v11.Footer = v15

	local v16 = if props.onNext then React.createElement(button, {
		text = translateIntoString(props.nextButtonText or ""),
		variant = buttonVariant.Emphasis,
		fillBehavior = fillBehavior.Fill,
		isLoading = props.isSubmitting,
		isDisabled = props.isSubmitting or state,
		onActivated = v9
	}) else nil

	return React.createElement(layout, {
		body = React.createElement(React.Fragment, nil, v11),
		actions = v16
	})
end

return React.memo(CommentNode)
