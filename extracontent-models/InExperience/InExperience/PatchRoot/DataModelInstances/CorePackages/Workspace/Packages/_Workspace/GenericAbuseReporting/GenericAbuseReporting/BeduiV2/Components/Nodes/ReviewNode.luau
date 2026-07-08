local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local SharedFlags = require(GenericAbuseReportingParent.SharedFlags)
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

local useArTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).useArTranslation
local useLayoutSlots = LayoutSlots.useLayoutSlots
local FFlagAbuseReportMenuV2 = SharedFlags.FFlagAbuseReportMenuV2

local function ReviewNode(t1: {[any]: any}) -- line: 47
	-- upvalues: useArTranslation (copy), useLayoutSlots (copy), React (copy), View (copy), Eyebrow (copy), PreviewBox (copy), Dash (copy), TextWithTranslation (copy), FFlagAbuseReportMenuV2 (copy), Footer (copy), Button (copy), ButtonVariant (copy), Foundation (copy)
	local translateIntoString = useArTranslation().translateIntoString
	local v21 = useLayoutSlots()
	local Layout = v21.Layout
	local Title = v21.Title
	local v24 = React.createElement(View, {
		tag = "col gap-large size-full-0 auto-y"
	}, {
		TitleContainer = React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			Eyebrow = t1.eyebrow and React.createElement(Eyebrow, {
				layoutOrder = 1,
				eyebrow = t1.eyebrow
			}),
			Title = React.createElement(Title, {
				layoutOrder = 2,
				input = t1.title,
				subtitle = t1.subtitle
			})
		}),
		Preview = t1.preview and React.createElement(PreviewBox, {
			layoutOrder = 2,
			preview = t1.preview
		}),
		DetailsContainer = React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y",
			LayoutOrder = 3
		}, Dash.map(t1.details, function(p1) -- line: 81
			-- upvalues: React (copy), View (copy), TextWithTranslation (copy)
			return React.createElement(View, {
				tag = "col size-full-0 auto-y gap-xsmall"
			}, {
				Heading = React.createElement(TextWithTranslation, {
					tag = "size-full-0 auto-y text-body-medium",
					layoutOrder = 1,
					input = p1.heading,
					fontStyle = {
						Font = Enum.Font.BuilderSansBold
					}
				}),
				Text = React.createElement(TextWithTranslation, {
					tag = "size-full-0 auto-y text-body-medium",
					layoutOrder = 2,
					input = p1.text
				})
			})
		end)),
		Footer = if not FFlagAbuseReportMenuV2 or not t1.footerItems then nil else React.createElement(Footer, {
			additionalTag = "padding-top-medium",
			layoutOrder = 4,
			footerItems = t1.footerItems
		})
	})
	local v25 = if not t1.onNext then nil else React.createElement(Button, {
		text = translateIntoString(t1.nextButtonText),
		variant = ButtonVariant.Emphasis,
		fillBehavior = Foundation.Enums.FillBehavior.Fill,
		isLoading = t1.isSubmitting,
		isDisabled = t1.isSubmitting,
		onActivated = t1.onNext
	})

	return React.createElement(Layout, {
		body = v24,
		actions = v25
	})
end

return React.memo(ReviewNode)
