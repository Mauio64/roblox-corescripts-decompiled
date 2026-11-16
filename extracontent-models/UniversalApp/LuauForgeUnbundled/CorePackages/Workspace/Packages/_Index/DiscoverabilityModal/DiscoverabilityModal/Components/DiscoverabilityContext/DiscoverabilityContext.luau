local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/dependencies")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Common/Constants")
local react = dependencies.React
local DiscoverabilityModalAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/DiscoverabilityModalAnalyticsContext")
local setupFireAnalyticsEvents = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/setupFireAnalyticsEvents")
local AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/AnalyticsService")

local useSelector = dependencies.Hooks.useSelector

local function Container(p2)
	return function(p3)
		local v5 = useSelector(function(p4)
			return p4.LocalUserId
		end)

		local createElement = react.createElement
		local provider = DiscoverabilityModalAnalyticsContext.Provider

		local v9 = { analytics = AnalyticsService, defaultAnalyticsInfo = 0 }

		local v11 = if p3.navigation then p3.navigation.getParam(Constants.ENTRY_POINT) else p3.entryPoint
		v9.defaultAnalyticsInfo = { uid = v5, entry = v11 }
		return createElement(provider, {
			value = { fireAnalyticsEvent = setupFireAnalyticsEvents(v9) }
		}, { react.createElement(p2, p3) })
	end
end

return Container
