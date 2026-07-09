local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local View = Foundation.View
local AbuseReportBeduiTypes = require(GenericAbuseReporting.Bedui.Provider.AbuseReportBeduiTypes)
local BeduiAnalytics = require(GenericAbuseReporting.Bedui.Utils.BeduiAnalytics)
local ComponentType = AbuseReportBeduiTypes.ComponentType
local Dropdown = require(GenericAbuseReporting.Bedui.Components.Dropdown)
local FreeComment = require(GenericAbuseReporting.Bedui.Components.FreeComment)
local Paragraph = require(GenericAbuseReporting.Bedui.Components.Paragraph)
local Selector = require(GenericAbuseReporting.Bedui.Components.Selector)
local sendAnalyticsEvent = BeduiAnalytics.sendAnalyticsEvent
local TelemetryEventType = BeduiAnalytics.TelemetryEventType
local useAnalyticsContext = require(GenericAbuseReporting.Bedui.Provider.useAnalyticsContext)
local WebViewLink = require(GenericAbuseReporting.Bedui.Components.WebViewLink)
local FFlagAddThumbnailSelectorReport = require(GenericAbuseReportingParent.SharedFlags).FFlagAddThumbnailSelectorReport

local function SingleStepInnerContentRenderer(t1: {[any]: any}) -- line: 30
	-- upvalues: useAnalyticsContext (copy), React (copy), ComponentType (copy), Dropdown (copy), FreeComment (copy), Paragraph (copy), WebViewLink (copy), FFlagAddThumbnailSelectorReport (copy), Selector (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy), View (copy)
	local v20 = useAnalyticsContext()
	local v21 = React.useMemo(function() -- line: 33
		-- upvalues: t1 (copy), ComponentType (copy), React (copy), Dropdown (copy), FreeComment (copy), Paragraph (copy), WebViewLink (copy), FFlagAddThumbnailSelectorReport (copy), Selector (copy), v20 (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy)
		if t1.contentConfig == nil then
			return {}
		end

		local t2 = {}

		if t1.contentConfig.type == "configurableComponentList" then
			for i, v in ipairs(t1.contentConfig.configurableComponentList.components) do
				if v.componentType == ComponentType.Dropdown then
					t2[`{ v.componentType }{ i }`] = React.createElement(Dropdown, {
						component = v,
						isErrorState = v.formDataKey ~= nil and table.find(t1.formDataKeysWithError, v.formDataKey) ~= nil,
						layoutOrder = i
					})
				elseif v.componentType == ComponentType.FreeComment then
					t2[`{ v.componentType }{ i }`] = React.createElement(FreeComment, {
						component = v,
						isErrorState = v.formDataKey ~= nil and table.find(t1.formDataKeysWithError, v.formDataKey) ~= nil,
						layoutOrder = i
					})
				elseif v.componentType == ComponentType.Paragraph then
					t2[`{ v.componentType }{ i }`] = React.createElement(Paragraph, {
						component = v,
						layoutOrder = i
					})
				elseif v.componentType == ComponentType.WebViewLink then
					t2[`{ v.componentType }{ i }`] = React.createElement(WebViewLink, {
						component = v,
						layoutOrder = i
					})
				elseif FFlagAddThumbnailSelectorReport and v.componentType == ComponentType.Selector then
					t2[`{ v.componentType }{ i }`] = React.createElement(Selector, {
						abuseVector = v20.abuseVector,
						component = v,
						isErrorState = v.formDataKey ~= nil and table.find(t1.formDataKeysWithError, v.formDataKey) ~= nil,
						layoutOrder = i
					})
				else
					sendAnalyticsEvent({
						eventType = TelemetryEventType.Error,
						context = v20,
						meta = {
							error = `SingleStepInnerContentRenderer - Unsupported component type: { v.componentType }`
						}
					})
				end
			end

			return t2
		end

		return {}
	end, {
		t1.contentConfig,
		t1.formDataKeysWithError,
		sendAnalyticsEvent,
		v20
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y col gap-xxlarge"
	}, v21)
end

return React.memo(SingleStepInnerContentRenderer)
