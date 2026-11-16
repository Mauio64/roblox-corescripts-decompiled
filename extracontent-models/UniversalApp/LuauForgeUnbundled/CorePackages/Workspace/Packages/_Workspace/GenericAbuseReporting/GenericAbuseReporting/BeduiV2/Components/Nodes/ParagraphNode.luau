local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags")

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Eyebrow")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/Footer")
local LayoutSlots = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/LayoutSlots")
local TextWithTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/TextWithTranslation")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")
local useArTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/arTranslation").useArTranslation

local useLayoutSlots = LayoutSlots.useLayoutSlots

local fFlagSupportSubmissionOnAllReportNodes = SharedFlags.FFlagSupportSubmissionOnAllReportNodes

local function ParagraphNode(props)
	local translateIntoString = useArTranslation().translateIntoString

	local v5 = useLayoutSlots()
	local title = v5.Title
	local layout = v5.Layout

	local v6 = {
		Eyebrow = React.createElement(module4, {
			eyebrow = props.eyebrow,
			layoutOrder = 0
		}),
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

	local v7 = if props.footerItems then React.createElement(module5, {
		footerItems = props.footerItems,
		additionalTag = "padding-top-medium",
		layoutOrder = 3
	}) else nil
	v6.Footer = v7
	local v8

	if props.onNext then
		local createElement = React.createElement
		local v10 = {
			text = translateIntoString(props.nextButtonText),
			variant = buttonVariant.Emphasis,
			fillBehavior = Foundation.Enums.FillBehavior.Fill,
			isLoading = 0,
			isDisabled = 0,
			onActivated = 0
		}
		local v11 = if fFlagSupportSubmissionOnAllReportNodes then props.isSubmitting else false
		v10.isLoading = v11
		local v12 = if fFlagSupportSubmissionOnAllReportNodes then props.isSubmitting else false
		v10.isDisabled = v12
		v10.onActivated = props.onNext
		v8 = createElement(button, v10)
	end

	return React.createElement(layout, {
		body = React.createElement(React.Fragment, nil, v6),
		actions = v8
	})
end

return React.memo(ParagraphNode)
