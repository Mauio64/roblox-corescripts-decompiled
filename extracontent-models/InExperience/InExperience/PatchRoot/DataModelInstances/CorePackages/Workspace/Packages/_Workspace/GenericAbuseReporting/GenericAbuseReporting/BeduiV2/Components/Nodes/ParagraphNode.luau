local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local Eyebrow = require(GenericAbuseReporting.BeduiV2.Components.Eyebrow)
local Footer = require(GenericAbuseReporting.BeduiV2.Components.Footer)
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)
require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)
local arTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation)
local useArTranslation = arTranslation.useArTranslation

local useLayoutSlots = LayoutSlots.useLayoutSlots

local FFlagSupportSubmissionOnAllReportNodes = SharedFlags.FFlagSupportSubmissionOnAllReportNodes

local function ParagraphNode(props)
	local translateIntoString = useArTranslation().translateIntoString

	local v = useLayoutSlots()
	local title = v.Title
	local layout = v.Layout

	local v2 = {
		Eyebrow = React.createElement(Eyebrow, { eyebrow = props.eyebrow, layoutOrder = 0 }),
		Title = React.createElement(title, {
			input = props.title,
			subtitle = props.subtitle,
			layoutOrder = 1
		}),
		Paragraph = React.createElement(TextWithTranslation, {
			input = props.paragraph,
			tag = "size-full-0 auto-y text-body-small",
			layoutOrder = 2
		}),
		Footer = 0
	}
	local footer

	if props.footerItems then
		footer = React.createElement(Footer, {
			footerItems = props.footerItems,
			additionalTag = "padding-top-medium",
			layoutOrder = 3
		})
	end

	v2.Footer = footer
	local actions

	if props.onNext then
		local createElement = React.createElement
		local v3 = {
			text = translateIntoString(props.nextButtonText),
			variant = ButtonVariant.Emphasis,
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			isLoading = 0,
			isDisabled = 0,
			onActivated = 0
		}
		local isLoading

		if FFlagSupportSubmissionOnAllReportNodes then
			isLoading = props.isSubmitting
		else
			isLoading = false
		end

		v3.isLoading = isLoading
		local isDisabled

		if FFlagSupportSubmissionOnAllReportNodes then
			isDisabled = props.isSubmitting
		else
			isDisabled = false
		end

		v3.isDisabled = isDisabled
		v3.onActivated = props.onNext
		actions = createElement(Button, v3)
	end

	return React.createElement(layout, {
		body = React.createElement(React.Fragment, nil, v2),
		actions = actions
	})
end

return React.memo(ParagraphNode)
