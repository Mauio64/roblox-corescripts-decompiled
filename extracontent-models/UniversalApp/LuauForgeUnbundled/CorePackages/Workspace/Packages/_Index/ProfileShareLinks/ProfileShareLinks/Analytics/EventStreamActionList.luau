local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/Dash")
local eventTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileShareLinks/SocialLuaAnalytics").Analytics.Enums.EventTypes
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/ProfileShareLinks/ProfileShareLinks/Analytics/EventNames")

return {
	[EventNames.ProfileShareLinkActivated] = {
		context = "",
		eventType = eventTypes.ButtonClick,
		additionalInfo = { btn = EventNames.ProfileShareLinkActivated },
		formatRulesForAdditionalInfo = {
			context = Dash.identity,
			shareType = Dash.identity,
			stamp = Dash.identity
		}
	}
}
