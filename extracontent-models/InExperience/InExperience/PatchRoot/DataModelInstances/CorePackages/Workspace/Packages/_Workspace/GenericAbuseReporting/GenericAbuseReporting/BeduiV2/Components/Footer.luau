local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local useDefaultTags = Foundation.Hooks.useDefaultTags
local View = Foundation.View

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)
require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local linkOpenedSource = analyticsService.LinkOpenedSource

local function Footer(props)
	local tag = useDefaultTags(props.additionalTag, "col gap-small size-full-0 auto-y")

	if not props.footerItems or #props.footerItems == 0 then
		return nil
	end

	local children = {}

	for i, footerItem in ipairs(props.footerItems) do
		table.insert(children, React.createElement(TextWithTranslation, {
			input = footerItem.label,
			linkId = footerItem.id,
			linkSource = linkOpenedSource.Footer,
			tag = "auto-xy text-body-small",
			layoutOrder = i
		}))
	end

	return React.createElement(View, {
		padding = props.padding,
		tag = tag,
		LayoutOrder = props.layoutOrder
	}, children)
end

return React.memo(Footer)
