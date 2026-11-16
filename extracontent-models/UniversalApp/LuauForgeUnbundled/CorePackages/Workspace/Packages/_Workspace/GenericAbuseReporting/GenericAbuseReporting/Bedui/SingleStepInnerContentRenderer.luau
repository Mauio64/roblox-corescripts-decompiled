local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local view = Foundation.View

local AbuseReportBeduiTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/AbuseReportBeduiTypes")
local BeduiAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Utils/BeduiAnalytics")
local componentType = AbuseReportBeduiTypes.ComponentType
local Dropdown = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Components/Dropdown")
local FreeComment = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Components/FreeComment")
local Paragraph = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Components/Paragraph")
local Selector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Components/Selector")
local sendAnalyticsEvent = BeduiAnalytics.sendAnalyticsEvent
local telemetryEventType = BeduiAnalytics.TelemetryEventType
local useAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Provider/useAnalyticsContext")
local WebViewLink = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Bedui/Components/WebViewLink")

local fFlagAddThumbnailSelectorReport = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags").FFlagAddThumbnailSelectorReport

local function SingleStepInnerContentRenderer(p2)
	local v5 = useAnalyticsContext()

	local v6 = React.useMemo(function()
		if p2.contentConfig == nil then
			return {}
		end

		local children = {}

		if p2.contentConfig.type ~= "configurableComponentList" then
			return {}
		end

		for i, component in ipairs(p2.contentConfig.configurableComponentList.components) do
			if component.componentType == componentType.Dropdown then
				local formatted = `{component.componentType}{i}`
				children[formatted] = React.createElement(Dropdown, {
					component = component,
					isErrorState = component.formDataKey ~= nil and table.find(p2.formDataKeysWithError, component.formDataKey) ~= nil,
					layoutOrder = i
				})
			elseif component.componentType == componentType.FreeComment then
				local formatted = `{component.componentType}{i}`
				children[formatted] = React.createElement(FreeComment, {
					component = component,
					isErrorState = component.formDataKey ~= nil and table.find(p2.formDataKeysWithError, component.formDataKey) ~= nil,
					layoutOrder = i
				})
			elseif component.componentType == componentType.Paragraph then
				children[`{component.componentType}{i}`] = React.createElement(Paragraph, {
					component = component,
					layoutOrder = i
				})
			elseif component.componentType == componentType.WebViewLink then
				children[`{component.componentType}{i}`] = React.createElement(WebViewLink, {
					component = component,
					layoutOrder = i
				})
			elseif
				fFlagAddThumbnailSelectorReport
				and component.componentType == componentType.Selector
			then
				local formatted = `{component.componentType}{i}`
				children[formatted] = React.createElement(Selector, {
					abuseVector = v5.abuseVector,
					component = component,
					isErrorState = component.formDataKey ~= nil and table.find(p2.formDataKeysWithError, component.formDataKey) ~= nil,
					layoutOrder = i
				})
			else
				sendAnalyticsEvent({
					eventType = telemetryEventType.Error,
					context = v5,
					meta = {
						error = `SingleStepInnerContentRenderer - Unsupported component type: {component.componentType}`
					}
				})
			end
		end

		return children
	end, { p2.contentConfig, p2.formDataKeysWithError, sendAnalyticsEvent, v5 })

	return React.createElement(view, { tag = "size-full-0 auto-y col gap-xxlarge" }, v6)
end

return React.memo(SingleStepInnerContentRenderer)
