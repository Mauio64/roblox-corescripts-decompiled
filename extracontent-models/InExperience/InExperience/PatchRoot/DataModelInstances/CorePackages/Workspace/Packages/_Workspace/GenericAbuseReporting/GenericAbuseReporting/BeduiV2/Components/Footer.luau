local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local SharedFlags = require(GenericAbuseReportingParent.SharedFlags)
local useDefaultTags = Foundation.Hooks.useDefaultTags
local View = Foundation.View

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)

require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local FFlagAbuseReportDensifyResolvedArrays = require(GenericAbuseReporting.Flags.FFlagAbuseReportDensifyResolvedArrays)
local FFlagAbuseReportLinkOpenedAnalytics = SharedFlags.FFlagAbuseReportLinkOpenedAnalytics
local LinkOpenedSource = analyticsService.LinkOpenedSource

local function Footer(t1: {[any]: any}) -- line: 35
	-- upvalues: useDefaultTags (copy), FFlagAbuseReportDensifyResolvedArrays (copy), React (copy), TextWithTranslation (copy), FFlagAbuseReportLinkOpenedAnalytics (copy), LinkOpenedSource (copy), View (copy)
	local v15 = useDefaultTags(t1.additionalTag, "col gap-small size-full-0 auto-y")

	if not t1.footerItems or FFlagAbuseReportDensifyResolvedArrays and #t1.footerItems == 0 then
		return nil
	end

	local t2 = {}

	for i, v in ipairs(t1.footerItems) do
		table.insert(t2, React.createElement(TextWithTranslation, {
			tag = "auto-xy text-body-small",
			input = v.label,
			linkId = if not FFlagAbuseReportLinkOpenedAnalytics then nil else v.id,
			linkSource = if not FFlagAbuseReportLinkOpenedAnalytics then nil else LinkOpenedSource.Footer,
			layoutOrder = if not FFlagAbuseReportDensifyResolvedArrays then nil else i,
			LayoutOrder = if not FFlagAbuseReportDensifyResolvedArrays then i else nil
		}))
	end

	return React.createElement(View, {
		padding = t1.padding,
		tag = v15,
		LayoutOrder = t1.layoutOrder
	}, t2)
end

return React.memo(Footer)
