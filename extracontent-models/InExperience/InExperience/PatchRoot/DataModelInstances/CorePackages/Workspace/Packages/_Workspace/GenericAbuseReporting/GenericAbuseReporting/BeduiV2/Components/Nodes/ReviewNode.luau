local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local View = Foundation.View

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local Eyebrow = require(GenericAbuseReporting.BeduiV2.Components.Eyebrow)
local Footer = require(GenericAbuseReporting.BeduiV2.Components.Footer)
local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)
local PreviewBox = require(GenericAbuseReporting.BeduiV2.Components.PreviewBox)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)
require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)
local arTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation)
local useArTranslation = arTranslation.useArTranslation

local useLayoutSlots = LayoutSlots.useLayoutSlots

local function ReviewNode(props)
	local translateIntoString = useArTranslation().translateIntoString

	local v = useLayoutSlots()
	local layout = v.Layout
	local title = v.Title

	local createElement = React.createElement

	local v2 = {
		TitleContainer = React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			Eyebrow = props.eyebrow and React.createElement(Eyebrow, {
				eyebrow = props.eyebrow,
				layoutOrder = 1
			}),
			Title = React.createElement(title, {
				input = props.title,
				subtitle = props.subtitle,
				layoutOrder = 2
			})
		}),
		Preview = props.preview and React.createElement(PreviewBox, {
			preview = props.preview,
			layoutOrder = 2
		}),
		DetailsContainer = React.createElement(
			View,
			{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 3 },
			Dash.map(props.details, function(p)
				return React.createElement(View, { tag = "col gap-xsmall size-full-0 auto-y" }, {
					Heading = React.createElement(TextWithTranslation, {
						input = p.heading,
						fontStyle = { Font = Enum.Font.BuilderSansBold },
						tag = "size-full-0 auto-y text-body-medium",
						layoutOrder = 1
					}),
					Text = React.createElement(TextWithTranslation, {
						input = p.text,
						tag = "size-full-0 auto-y text-body-medium",
						layoutOrder = 2
					})
				})
			end)
		),
		Footer = 0
	}
	local footer

	if props.footerItems then
		footer = React.createElement(Footer, {
			footerItems = props.footerItems,
			additionalTag = "padding-top-medium",
			layoutOrder = 4
		})
	end

	v2.Footer = footer
	local element = createElement(View, { tag = "col gap-large size-full-0 auto-y" }, v2)
	local actions

	if props.onNext then
		actions = React.createElement(Button, {
			text = translateIntoString(props.nextButtonText),
			variant = ButtonVariant.Emphasis,
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			isLoading = props.isSubmitting,
			isDisabled = props.isSubmitting,
			onActivated = props.onNext
		})
	end

	return React.createElement(layout, { body = element, actions = actions })
end

return React.memo(ReviewNode)
