local enums = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/SocialLuaAnalytics").Analytics.Enums
local contexts = enums.Contexts
local eventTypes = enums.EventTypes

local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Analytics/Enums/EventNames")
local ButtonNames = require("@game/CorePackages/Workspace/Packages/_Index/EditProfileBackground/EditProfileBackground/Analytics/Enums/ButtonNames")

return {
	[EventNames.EditProfileBackgroundOpened] = {
		context = contexts.EditProfile,
		eventType = eventTypes.PageLoad,
		additionalInfo = { btn = ButtonNames.EditProfileBackgroundOpened }
	},
	[EventNames.BackgroundSelected] = {
		context = contexts.EditProfile,
		eventType = eventTypes.ButtonClick,
		additionalInfo = { btn = ButtonNames.BackgroundSelected }
	}
}
