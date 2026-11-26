local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local useDefaultTags = Foundation.Hooks.useDefaultTags
local view = Foundation.View

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Hooks/AbuseSheetFlow/AbuseSheetFlowTypes")
local analyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService")
local TextWithTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/TextWithTranslation")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")

local linkOpenedSource = analyticsService.LinkOpenedSource

local function Footer(props)
	local v5 = useDefaultTags(props.additionalTag, "col gap-small size-full-0 auto-y")

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

	return React.createElement(
		view,
		{ padding = props.padding, tag = v5, LayoutOrder = props.layoutOrder },
		children
	)
end

return React.memo(Footer)
