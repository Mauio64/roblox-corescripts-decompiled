local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local SocialLuaAnalytics = require(parent2.SocialLuaAnalytics)
local dependencies = require(parent.dependencies)
local react = dependencies.React
local useLocalUserId = dependencies.Hooks.useLocalUserId

local Analytics = require(parent.Analytics)
local Constants = require(parent.Common.Constants)
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local SetAliasModalContainer = require(script.Parent.SetAliasModalContainer)

return function(p)
	local uid = useLocalUserId()

	return react.createElement(Analytics.Context.Provider, {
		value = {
			fireAnalyticsEvent = Analytics.setupFireAnalyticsEvents({
				analytics = DefaultAnalyticsService,
				infoForAllEvents = {
					uid = uid,
					origin = p.navigation.getParam(Constants.ORIGIN)
				}
			})
		}
	}, { react.createElement(SetAliasModalContainer, p) })
end
