local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/SocialLuaAnalytics")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/dependencies")
local react = dependencies.React
local useLocalUserId = dependencies.Hooks.useLocalUserId

local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Common/Constants")
local defaultAnalyticsService = SocialLuaAnalytics.Analytics.DefaultAnalyticsService

local SetAliasModalContainer = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Components/SetAliasModal/SetAliasModalContainer")

return function(p2)
	local v5 = useLocalUserId()

	return react.createElement(Analytics.Context.Provider, {
		value = {
			fireAnalyticsEvent = Analytics.setupFireAnalyticsEvents({
				analytics = defaultAnalyticsService,
				infoForAllEvents = {
					uid = v5,
					origin = p2.navigation.getParam(Constants.ORIGIN)
				}
			})
		}
	}, { react.createElement(SetAliasModalContainer, p2) })
end
