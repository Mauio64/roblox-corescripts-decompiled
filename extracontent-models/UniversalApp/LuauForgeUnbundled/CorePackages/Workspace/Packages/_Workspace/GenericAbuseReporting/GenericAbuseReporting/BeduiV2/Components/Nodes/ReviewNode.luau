local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local view = Foundation.View

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Eyebrow")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Footer")
local LayoutSlots = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/LayoutSlots")
local PreviewBox = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/PreviewBox")
local TextWithTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/TextWithTranslation")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")
local useArTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/arTranslation").useArTranslation

local useLayoutSlots = LayoutSlots.useLayoutSlots

local function ReviewNode(props)
	local translateIntoString = useArTranslation().translateIntoString

	local v5 = useLayoutSlots()
	local layout = v5.Layout
	local title = v5.Title

	local createElement = React.createElement

	local v8 = {
		TitleContainer = React.createElement(
			view,
			{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 1 },
			{
				Eyebrow = props.eyebrow and React.createElement(module4, {
					eyebrow = props.eyebrow,
					layoutOrder = 1
				}),
				Title = React.createElement(title, {
					input = props.title,
					subtitle = props.subtitle,
					layoutOrder = 2
				})
			}
		),
		Preview = props.preview and React.createElement(PreviewBox, {
			preview = props.preview,
			layoutOrder = 2
		}),
		DetailsContainer = React.createElement(
			view,
			{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 3 },
			Dash.map(props.details, function(p2)
				return React.createElement(view, {
					tag = "col gap-xsmall size-full-0 auto-y"
				}, {
					Heading = React.createElement(TextWithTranslation, {
						input = p2.heading,
						fontStyle = { Font = Enum.Font.BuilderSansBold },
						tag = "size-full-0 auto-y text-body-medium",
						layoutOrder = 1
					}),
					Text = React.createElement(TextWithTranslation, {
						input = p2.text,
						tag = "size-full-0 auto-y text-body-medium",
						layoutOrder = 2
					})
				})
			end)
		),
		Footer = 0
	}

	local v9 = if props.footerItems then React.createElement(module5, {
		footerItems = props.footerItems,
		additionalTag = "padding-top-medium",
		layoutOrder = 4
	}) else nil
	v8.Footer = v9
	local element = createElement(view, { tag = "col gap-large size-full-0 auto-y" }, v8)

	local v10 = if props.onNext then React.createElement(button, {
		text = translateIntoString(props.nextButtonText),
		variant = buttonVariant.Emphasis,
		fillBehavior = Foundation.Enums.FillBehavior.Fill,
		isLoading = props.isSubmitting,
		isDisabled = props.isSubmitting,
		onActivated = props.onNext
	}) else nil

	return React.createElement(layout, { body = element, actions = v10 })
end

return React.memo(ReviewNode)
