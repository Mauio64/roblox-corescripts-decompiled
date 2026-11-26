local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppCommonLib")

local screenSizeImpressionsTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Impressions").ScreenSizeImpressionsTracker

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SduiCoreSystem")
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local sduiBuilder = SduiCoreSystem.SduiBuilder
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local sendSduiFeedImpressions = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/UnifiedLogging").sendSduiFeedImpressions

local function SduiFeedImpressionsDetector(props)
	local ref = React.useRef(props.feedItems)
	ref.current = props.feedItems
	local sduiContext = props.sduiContext

	local v5 = React.useCallback(function(list)
		if not list or #list == 0 then
			return
		end

		local current = ref.current

		local v6 = {}
		local v7 = {}
		local v8 = {}

		for k, item in list do
			if item <= 0 then
				continue
			end

			local v9 = current and current[item]

			if v9 == nil then
				sduiContext.dependencies.logger.reportError(
					sduiErrorType.FailedToLogFeedImpressions,
					{
						name = "SduiFeedImpressionsDetector",
						message = `feed item index {item} detected with no matching componentConfig`
					},
					sduiContext.appPage
				)
			else
				local v10 = findAnalyticsField("componentType", v9.analyticsData)
					or sduiBuilder.getComponentType(v9, sduiContext)
					or "unknown"

				local analyticsField = findAnalyticsField("collectionId", v9.analyticsData)
				local v11 = analyticsField == nil and "" or tostring(analyticsField)

				table.insert(v6, item)
				table.insert(v7, v11)
				table.insert(v8, (tostring(v10)))
			end
		end

		if #v6 > 0 then
			sendSduiFeedImpressions(v6, v7, v8, sduiContext.appPage)
		end
	end, { sduiContext })

	return React.createElement(screenSizeImpressionsTracker, {
		pageContext = sduiContext.routeName or sduiContext.appPage,
		parentRef = props.parentRef,
		impressionsTag = props.impressionsTag,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		sendImpressions = v5,
		dataUpdatedTimestamp = sduiContext.dataUpdatedTimestamp
	})
end

return SduiFeedImpressionsDetector
