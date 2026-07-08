local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local useDefaultTags = Foundation.Hooks.useDefaultTags
local View = Foundation.View

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)

require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local function Footer(t1: {[any]: any}) -- line: 29
	-- upvalues: useDefaultTags (copy), React (copy), TextWithTranslation (copy), View (copy)
	local v10 = useDefaultTags(t1.additionalTag, "col gap-small size-full-0 auto-y")

	if not t1.footerItems then
		return nil
	end

	local t2 = {}

	for i, v in ipairs(t1.footerItems) do
		table.insert(t2, React.createElement(TextWithTranslation, {
			tag = "auto-xy text-body-small",
			input = v.label,
			LayoutOrder = i
		}))
	end

	return React.createElement(View, {
		padding = t1.padding,
		tag = v10,
		LayoutOrder = t1.layoutOrder
	}, t2)
end

return React.memo(Footer)
