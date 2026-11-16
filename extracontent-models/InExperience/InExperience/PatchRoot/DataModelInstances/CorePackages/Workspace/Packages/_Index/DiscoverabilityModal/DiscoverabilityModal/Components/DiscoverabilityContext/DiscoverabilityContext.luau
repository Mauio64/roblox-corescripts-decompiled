local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local Constants = require(parent.Common.Constants)
local react = dependencies.React
local DiscoverabilityModalAnalyticsContext = require(parent.Analytics.DiscoverabilityModalAnalyticsContext)
local setupFireAnalyticsEvents = require(parent.Analytics.setupFireAnalyticsEvents)
local AnalyticsService = require(parent.Analytics.AnalyticsService)

local useSelector = dependencies.Hooks.useSelector

local function Container(p)
	return function(p2)
		local uid = useSelector(function(p3)
			return p3.LocalUserId
		end)

		local createElement = react.createElement
		local provider = DiscoverabilityModalAnalyticsContext.Provider

		local v = { analytics = AnalyticsService, defaultAnalyticsInfo = 0 }
		local entry

		if p2.navigation then
			entry = p2.navigation.getParam(Constants.ENTRY_POINT)
		else
			entry = p2.entryPoint
		end

		v.defaultAnalyticsInfo = { uid = uid, entry = entry }
		return createElement(provider, {
			value = { fireAnalyticsEvent = setupFireAnalyticsEvents(v) }
		}, { react.createElement(p, p2) })
	end
end

return Container
