local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SocialLuaAnalytics").Analytics.Enums
local contexts = enums.Contexts
local eventTypes = enums.EventTypes

return {
	[require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Analytics/Enums/EventNames").UsernameSaved] = {
		context = contexts.EditProfile,
		eventType = eventTypes.UsernameSaved
	}
}
