local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)

require(Parent.AppCommonLib)

local ScreenSizeImpressionsTracker = require(Parent.Impressions).ScreenSizeImpressionsTracker
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local findAnalyticsField = SduiCoreSystem.findAnalyticsField
local SduiBuilder = SduiCoreSystem.SduiBuilder
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sendSduiFeedImpressions = require(Parent.UnifiedLogging).sendSduiFeedImpressions

local function SduiFeedImpressionsDetector(t1: {[any]: any}) -- line: 29
	-- upvalues: React (copy), SduiErrorType (copy), findAnalyticsField (copy), SduiBuilder (copy), sendSduiFeedImpressions (copy), ScreenSizeImpressionsTracker (copy)
	local v11 = React.useRef(t1.feedItems)

	v11.current = t1.feedItems

	local sduiContext = t1.sduiContext
	local v13 = React.useCallback(function(t2: {[any]: any}) -- line: 37
		-- upvalues: v11 (copy), sduiContext (copy), SduiErrorType (copy), findAnalyticsField (copy), SduiBuilder (copy), sendSduiFeedImpressions (copy)
		if not t2 or #t2 == 0 then
			return
		end

		local current = v11.current
		local t3 = {}
		local t4 = {}
		local t5 = {}

		for _, v20 in t2 do
			if not (v20 <= 0) then
				local v21 = current and current[v20]

				if v21 == nil then
					sduiContext.dependencies.logger.reportError(SduiErrorType.FailedToLogFeedImpressions, {
						name = "SduiFeedImpressionsDetector",
						message = `feed item index { v20 } detected with no matching componentConfig`
					}, sduiContext.appPage)
				else
					local v22 = findAnalyticsField("componentType", v21.analyticsData) or (SduiBuilder.getComponentType(v21, sduiContext) or "unknown")
					local v23 = findAnalyticsField("collectionId", v21.analyticsData)
					local v24 = v23 == nil and "" or tostring(v23)

					table.insert(t3, v20)
					table.insert(t4, v24)
					table.insert(t5, (tostring(v22)))
				end
			end
		end

		if #t3 > 0 then
			sendSduiFeedImpressions(t3, t4, t5, sduiContext.appPage)
		end
	end, { sduiContext })

	return React.createElement(ScreenSizeImpressionsTracker, {
		pageContext = sduiContext.routeName or sduiContext.appPage,
		parentRef = t1.parentRef,
		impressionsTag = t1.impressionsTag,
		scrollViewPositionChangedSignal = t1.scrollViewPositionChangedSignal,
		sendImpressions = v13,
		dataUpdatedTimestamp = sduiContext.dataUpdatedTimestamp
	})
end

return SduiFeedImpressionsDetector
