local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

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

local SharedFlags = require(parent.SharedFlags)
local FFlagAddThumbnailSelectorReport = SharedFlags.FFlagAddThumbnailSelectorReport

local function SingleStepInnerContentRenderer(p)
	local context = useAnalyticsContext()

	local v = React.useMemo(function()
		if p.contentConfig == nil then
			return {}
		end

		local children = {}

		if p.contentConfig.type ~= "configurableComponentList" then
			return {}
		end

		for i, component in ipairs(p.contentConfig.configurableComponentList.components) do
			if component.componentType == ComponentType.Dropdown then
				local formatted = `{component.componentType}{i}`
				children[formatted] = React.createElement(Dropdown, {
					component = component,
					isErrorState = component.formDataKey ~= nil and table.find(p.formDataKeysWithError, component.formDataKey) ~= nil,
					layoutOrder = i
				})
			elseif component.componentType == ComponentType.FreeComment then
				local formatted = `{component.componentType}{i}`
				children[formatted] = React.createElement(FreeComment, {
					component = component,
					isErrorState = component.formDataKey ~= nil and table.find(p.formDataKeysWithError, component.formDataKey) ~= nil,
					layoutOrder = i
				})
			elseif component.componentType == ComponentType.Paragraph then
				children[`{component.componentType}{i}`] = React.createElement(Paragraph, {
					component = component,
					layoutOrder = i
				})
			elseif component.componentType == ComponentType.WebViewLink then
				children[`{component.componentType}{i}`] = React.createElement(WebViewLink, {
					component = component,
					layoutOrder = i
				})
			elseif FFlagAddThumbnailSelectorReport and component.componentType == ComponentType.Selector then
				local formatted = `{component.componentType}{i}`
				children[formatted] = React.createElement(Selector, {
					abuseVector = context.abuseVector,
					component = component,
					isErrorState = component.formDataKey ~= nil and table.find(p.formDataKeysWithError, component.formDataKey) ~= nil,
					layoutOrder = i
				})
			else
				sendAnalyticsEvent({
					eventType = TelemetryEventType.Error,
					context = context,
					meta = {
						error = `SingleStepInnerContentRenderer - Unsupported component type: {component.componentType}`
					}
				})
			end
		end

		return children
	end, { p.contentConfig, p.formDataKeysWithError, sendAnalyticsEvent, context })

	return React.createElement(View, { tag = "size-full-0 auto-y col gap-xxlarge" }, v)
end

return React.memo(SingleStepInnerContentRenderer)
