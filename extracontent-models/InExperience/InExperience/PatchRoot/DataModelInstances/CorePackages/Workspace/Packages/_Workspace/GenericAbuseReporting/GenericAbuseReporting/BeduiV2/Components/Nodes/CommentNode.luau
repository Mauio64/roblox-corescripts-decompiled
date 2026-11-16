local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local TextArea = Foundation.TextArea

local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local Eyebrow = require(GenericAbuseReporting.BeduiV2.Components.Eyebrow)
local Footer = require(GenericAbuseReporting.BeduiV2.Components.Footer)
local getCodePointLength = require(GenericAbuseReporting.BeduiV2.Utils.getCodePointLength)
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local translate = require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)
local arTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation)
local useArTranslation = arTranslation.useArTranslation

local telemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots

local function CommentNode(props)
	local text, v = React.useBinding(props.initialValue or "")
	local state, setState = React.useState(false)
	local mergeTranslationParams = translate.mergeTranslationParams
	local translateIntoString = useArTranslation().translateIntoString
	local sendEvent = useAbuseReportAnalytics().sendEvent
	local ref = React.useRef(false)

	local v2 = useLayoutSlots()
	local title = v2.Title
	local layout = v2.Layout

	local onChanged = React.useCallback(function(p: string)
		v(p)

		if props.maxLength then
			local v3 = getCodePointLength(p) > props.maxLength
			setState(v3)

			if v3 then
				ref.current = true
			end
		end
	end, { props.maxLength })

	local onActivated = React.useCallback(function()
		sendEvent({
			sub_event_type = telemetryEventType.CommentInput,
			comment_input_detail = {
				comment_length = getCodePointLength(text:getValue()),
				has_initial_value = props.initialValue ~= nil and props.initialValue ~= "",
				did_modify_initial = props.initialValue ~= nil and text:getValue() ~= props.initialValue,
				hit_character_limit = ref.current,
				max_length = props.maxLength or 0
			}
		})

		if props.onNext then
			props.onNext(text:getValue())
		end
	end, { text, props.onNext, sendEvent, props.initialValue, props.maxLength })

	local v3 = React.useCallback(function(p: string)
		if props.helperText and props.maxLength and mergeTranslationParams then
			return translateIntoString(mergeTranslationParams(props.helperText, {
				currentLength = tostring(getCodePointLength(p)),
				maxLength = tostring(props.maxLength)
			}))
		end

		if props.helperText then
			return translateIntoString(props.helperText)
		end

		return nil
	end, { props.helperText, props.maxLength })

	local v4 = {
		Eyebrow = React.createElement(Eyebrow, { eyebrow = props.eyebrow, layoutOrder = 0 }),
		Title = React.createElement(title, {
			input = props.title,
			subtitle = props.subtitle,
			layoutOrder = 1
		}),
		TextArea = 0,
		Footer = 0
	}

	local createElement = React.createElement
	local v5 = {
		text = text,
		hint = 0,
		numLines = 6,
		onChanged = 0,
		label = 0,
		placeholder = 0,
		hasError = 0,
		width = 0,
		LayoutOrder = 2
	}
	local hint

	if props.helperText then
		hint = text:map(function(p)
			return v3(p)
		end)
	end

	v5.hint = hint

	v5.onChanged = onChanged
	v5.label = not props.textAreaLabel and "" or translateIntoString(props.textAreaLabel)
	v5.placeholder = translateIntoString(props.placeholder or "")
	v5.hasError = state
	v5.width = UDim.new(1, 0)
	v4.TextArea = createElement(TextArea, v5)
	local footer

	if props.footerItems then
		footer = React.createElement(Footer, {
			footerItems = props.footerItems,
			additionalTag = "padding-top-medium",
			layoutOrder = 3
		})
	end

	v4.Footer = footer
	local actions

	if props.onNext then
		actions = React.createElement(Button, {
			text = translateIntoString(props.nextButtonText or ""),
			variant = ButtonVariant.Emphasis,
			fillBehavior = FillBehavior.Fill,
			isLoading = props.isSubmitting,
			isDisabled = props.isSubmitting or state,
			onActivated = onActivated
		})
	end

	return React.createElement(layout, {
		body = React.createElement(React.Fragment, nil, v4),
		actions = actions
	})
end

return React.memo(CommentNode)
