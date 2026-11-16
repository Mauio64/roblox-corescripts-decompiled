local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
require(parent.AppCommonLib)

local Impressions = require(parent.Impressions)
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker

local SduiCoreSystem = require(parent.SduiCoreSystem)
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType

local UnifiedLogging = require(parent.UnifiedLogging)
local sendSduiFeedImpressions = UnifiedLogging.sendSduiFeedImpressions

local function SduiFeedImpressionsDetector(props)
	local ref = React.useRef(props.feedItems)
	ref.current = props.feedItems
	local sduiContext = props.sduiContext

	local sendImpressions = React.useCallback(function(list)
		if not list or #list == 0 then
			return
		end

		local current = ref.current

		local v = {}
		local v2 = {}
		local v3 = {}

		for _, item in list do
			if item <= 0 then
				continue
			end

			local v4 = current and current[item]

			if v4 == nil then
				sduiContext.dependencies.logger.reportError(
					SduiErrorType.FailedToLogFeedImpressions,
					{
						name = "SduiFeedImpressionsDetector",
						message = `feed item index {item} detected with no matching componentConfig`
					},
					sduiContext.appPage
				)
			else
				local v5 = findAnalyticsField("componentType", v4.analyticsData)
					or SduiBuilder.getComponentType(v4, sduiContext)
					or "unknown"

				local analyticsField = findAnalyticsField("collectionId", v4.analyticsData)
				local v6 = analyticsField == nil and "" or tostring(analyticsField)

				table.insert(v, item)
				table.insert(v2, v6)
				table.insert(v3, (tostring(v5)))
			end
		end

		if #v > 0 then
			sendSduiFeedImpressions(v, v2, v3, sduiContext.appPage)
		end
	end, { sduiContext })

	return React.createElement(ScreenSizeImpressionsTracker, {
		pageContext = sduiContext.routeName or sduiContext.appPage,
		parentRef = props.parentRef,
		impressionsTag = props.impressionsTag,
		scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
		sendImpressions = sendImpressions,
		dataUpdatedTimestamp = sduiContext.dataUpdatedTimestamp
	})
end

return SduiFeedImpressionsDetector
