local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local SharedFlags = require(GenericAbuseReportingParent.SharedFlags)
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
local useArTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).useArTranslation
local TelemetryEventType = analyticsService.TelemetryEventType
local useAbuseReportAnalytics = AbuseReportAnalyticsContext.useAbuseReportAnalytics
local useLayoutSlots = LayoutSlots.useLayoutSlots
local FFlagAddReportCharacterLimit = SharedFlags.FFlagAddReportCharacterLimit
local FFlagAbuseReportMenuV2 = SharedFlags.FFlagAbuseReportMenuV2
local v23 = game:DefineFastFlag("AbuseReportCommentNodeAnalyticsIntegration", false)

local function CommentNode(t1: {[any]: any}) -- line: 56
	-- upvalues: React (copy), FFlagAddReportCharacterLimit (copy), translate (copy), useArTranslation (copy), v23 (copy), useAbuseReportAnalytics (copy), useLayoutSlots (copy), FFlagAbuseReportMenuV2 (copy), getCodePointLength (copy), TelemetryEventType (copy), Eyebrow (copy), TextArea (copy), Footer (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local v26, v27 = React.useBinding(t1.initialValue or "")
	local v28, v29 = React.useState(false)
	local v30 = if not FFlagAddReportCharacterLimit then nil else translate.mergeTranslationParams
	local translateIntoString = useArTranslation().translateIntoString
	local v32 = if not v23 then nil else useAbuseReportAnalytics().sendEvent
	local v33 = React.useRef(false)
	local v34 = useLayoutSlots()
	local Body = v34.Body
	local Actions = v34.Actions
	local Title = v34.Title
	local Layout = nil

	if FFlagAbuseReportMenuV2 then
		Layout = v34.Layout
	end

	local v39 = React.useCallback(function(s1: string) -- line: 75
		-- upvalues: v27 (copy), FFlagAddReportCharacterLimit (copy), t1 (copy), getCodePointLength (copy), v29 (copy), v23 (copy), v33 (copy)
		v27(s1)

		if FFlagAddReportCharacterLimit and t1.maxLength then
			local v45 = getCodePointLength(s1) > t1.maxLength

			v29(v45)

			if v23 and v45 then
				v33.current = true
			end
		end
	end, { t1.maxLength })
	local v40 = React.useCallback(function() -- line: 87
		-- upvalues: v23 (copy), v32 (copy), TelemetryEventType (copy), getCodePointLength (copy), v26 (copy), t1 (copy), v33 (copy)
		if v23 and v32 then
			v32({
				sub_event_type = TelemetryEventType.CommentInput,
				comment_input_detail = {
					comment_length = getCodePointLength(v26:getValue()),
					has_initial_value = t1.initialValue ~= nil and t1.initialValue ~= "",
					did_modify_initial = t1.initialValue ~= nil and v26:getValue() ~= t1.initialValue,
					hit_character_limit = v33.current,
					max_length = t1.maxLength or 0
				}
			})
		end

		if t1.onNext then
			t1.onNext(v26:getValue())
		end
	end, {
		v26,
		t1.onNext,
		if not v23 then nil else v32,
		if not v23 then nil else t1.initialValue,
		if not v23 then nil else t1.maxLength
	})
	local v41 = React.useCallback(function(s2: string) -- line: 118
		-- upvalues: t1 (copy), v30 (copy), translateIntoString (copy), getCodePointLength (copy)
		if t1.helperText and (t1.maxLength and v30) then
			return translateIntoString(v30(t1.helperText, {
				currentLength = tostring(getCodePointLength(s2)),
				maxLength = tostring(t1.maxLength)
			}))
		end

		if t1.helperText then
			return translateIntoString(t1.helperText)
		end

		return nil
	end, {
		t1.helperText,
		t1.maxLength
	})
	local t2 = {
		Eyebrow = React.createElement(Eyebrow, {
			layoutOrder = 0,
			eyebrow = t1.eyebrow
		}),
		Title = React.createElement(Title, {
			layoutOrder = 1,
			input = t1.title,
			subtitle = t1.subtitle,
			tag = not FFlagAbuseReportMenuV2 and "padding-bottom-small" or nil
		}),
		TextArea = React.createElement(TextArea, {
			numLines = 6,
			LayoutOrder = 2,
			text = v26,
			hint = if not FFlagAddReportCharacterLimit or not t1.helperText then nil else v26:map(function(p1) -- line: 145
				-- upvalues: v41 (copy)
				return v41(p1)
			end),
			onChanged = v39,
			label = not t1.textAreaLabel and "" or translateIntoString(t1.textAreaLabel),
			placeholder = translateIntoString(t1.placeholder or ""),
			hasError = not not FFlagAddReportCharacterLimit and v28,
			width = UDim.new(1, 0)
		}),
		Footer = if not FFlagAbuseReportMenuV2 or not t1.footerItems then nil else React.createElement(Footer, {
			additionalTag = "padding-top-medium",
			layoutOrder = 3,
			footerItems = t1.footerItems
		})
	}
	local v43 = if not t1.onNext then nil else React.createElement(Button, {
		text = translateIntoString(t1.nextButtonText or ""),
		variant = ButtonVariant.Emphasis,
		fillBehavior = FillBehavior.Fill,
		isLoading = t1.isSubmitting,
		isDisabled = if not FFlagAddReportCharacterLimit then t1.isSubmitting else t1.isSubmitting or v28,
		onActivated = v40
	})

	if FFlagAbuseReportMenuV2 then
		return React.createElement(Layout, {
			body = React.createElement(React.Fragment, nil, t2),
			actions = v43
		})
	end

	return React.createElement(React.Fragment, nil, {
		Content = React.createElement(Body, nil, t2),
		Actions = if not v43 then nil else React.createElement(Actions, nil, {
			Button = v43
		})
	})
end

return React.memo(CommentNode)
