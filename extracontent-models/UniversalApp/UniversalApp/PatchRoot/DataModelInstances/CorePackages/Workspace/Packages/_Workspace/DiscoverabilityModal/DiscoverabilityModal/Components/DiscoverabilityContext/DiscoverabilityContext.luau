local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local Constants = require(ParentParent.Common.Constants)
local React = dependencies.React
local DiscoverabilityModalAnalyticsContext = require(ParentParent.Analytics.DiscoverabilityModalAnalyticsContext)
local setupFireAnalyticsEvents = require(ParentParent.Analytics.setupFireAnalyticsEvents)
local AnalyticsService = require(ParentParent.Analytics.AnalyticsService)
local useSelector = dependencies.Hooks.useSelector

local function Container(p1) -- line: 11
	-- upvalues: useSelector (copy), React (copy), DiscoverabilityModalAnalyticsContext (copy), setupFireAnalyticsEvents (copy), AnalyticsService (copy), Constants (copy)
	return function(p2) -- line: 12
		-- upvalues: useSelector (copy), React (copy), DiscoverabilityModalAnalyticsContext (copy), setupFireAnalyticsEvents (copy), AnalyticsService (copy), Constants (copy), p1 (copy)
		local v12 = useSelector(function(p3) -- line: 13
			return p3.LocalUserId
		end)

		return React.createElement(DiscoverabilityModalAnalyticsContext.Provider, {
			value = {
				fireAnalyticsEvent = setupFireAnalyticsEvents({
					analytics = AnalyticsService,
					defaultAnalyticsInfo = {
						uid = v12,
						entry = if not p2.navigation then p2.entryPoint else p2.navigation.getParam(Constants.ENTRY_POINT)
					}
				})
			}
		}, { React.createElement(p1, p2) })
	end
end

return Container
