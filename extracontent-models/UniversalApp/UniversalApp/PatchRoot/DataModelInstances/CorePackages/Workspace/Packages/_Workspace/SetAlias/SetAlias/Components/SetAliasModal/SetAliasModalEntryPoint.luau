local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local SocialLuaAnalytics = require(ParentParentParent.SocialLuaAnalytics)
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local useLocalUserId = dependencies.Hooks.useLocalUserId
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Common.Constants)
local DefaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService
local SetAliasModalContainer = require(script.Parent.SetAliasModalContainer)

return function(p1) -- line: 15
	-- upvalues: useLocalUserId (copy), React (copy), Analytics (copy), DefaultAnalyticsService (copy), Constants (copy), SetAliasModalContainer (copy)
	local v12 = useLocalUserId()

	return React.createElement(Analytics.Context.Provider, {
		value = {
			fireAnalyticsEvent = Analytics.setupFireAnalyticsEvents({
				analytics = DefaultAnalyticsService,
				infoForAllEvents = {
					uid = v12,
					origin = p1.navigation.getParam(Constants.ORIGIN)
				}
			})
		}
	}, { React.createElement(SetAliasModalContainer, p1) })
end
