local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local SharedFlags = require(GenericAbuseReportingParent.SharedFlags)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local Eyebrow = require(GenericAbuseReporting.BeduiV2.Components.Eyebrow)
local Footer = require(GenericAbuseReporting.BeduiV2.Components.Footer)
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)

require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local useArTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).useArTranslation
local useLayoutSlots = LayoutSlots.useLayoutSlots
local FFlagSupportSubmissionOnAllReportNodes = SharedFlags.FFlagSupportSubmissionOnAllReportNodes
local FFlagAbuseReportMenuV2 = SharedFlags.FFlagAbuseReportMenuV2

local function ParagraphNode(t1: {[any]: any}) -- line: 44
	-- upvalues: useArTranslation (copy), useLayoutSlots (copy), FFlagAbuseReportMenuV2 (copy), React (copy), Eyebrow (copy), TextWithTranslation (copy), Footer (copy), Button (copy), ButtonVariant (copy), Foundation (copy), FFlagSupportSubmissionOnAllReportNodes (copy)
	local translateIntoString = useArTranslation().translateIntoString
	local v19 = useLayoutSlots()
	local Body = v19.Body
	local Actions = v19.Actions
	local Title = v19.Title
	local Layout = nil

	if FFlagAbuseReportMenuV2 then
		Layout = v19.Layout
	end

	local t2 = {
		Eyebrow = React.createElement(Eyebrow, {
			layoutOrder = 0,
			eyebrow = t1.eyebrow
		}),
		Title = React.createElement(Title, {
			layoutOrder = 1,
			input = t1.title,
			subtitle = t1.subtitle
		}),
		Paragraph = React.createElement(TextWithTranslation, {
			tag = "size-full-0 auto-y text-body-small",
			layoutOrder = 2,
			input = t1.paragraph
		}),
		Footer = if not FFlagAbuseReportMenuV2 or not t1.footerItems then nil else React.createElement(Footer, {
			additionalTag = "padding-top-medium",
			layoutOrder = 3,
			footerItems = t1.footerItems
		})
	}
	local v25 = if not t1.onNext then nil else React.createElement(Button, {
		text = translateIntoString(t1.nextButtonText),
		variant = ButtonVariant.Emphasis,
		fillBehavior = Foundation.Enums.FillBehavior.Fill,
		isLoading = not not FFlagSupportSubmissionOnAllReportNodes and t1.isSubmitting,
		isDisabled = not not FFlagSupportSubmissionOnAllReportNodes and t1.isSubmitting,
		onActivated = t1.onNext
	})

	if FFlagAbuseReportMenuV2 then
		return React.createElement(Layout, {
			body = React.createElement(React.Fragment, nil, t2),
			actions = v25
		})
	end

	return React.createElement(React.Fragment, nil, {
		Content = React.createElement(Body, nil, t2),
		Actions = if not v25 then nil else React.createElement(Actions, nil, {
			Button = v25
		})
	})
end

return React.memo(ParagraphNode)
