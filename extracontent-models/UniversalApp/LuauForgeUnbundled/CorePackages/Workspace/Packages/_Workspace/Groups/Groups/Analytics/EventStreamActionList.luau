require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/SocialLuaAnalytics")

local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Analytics/EventNames")

return {
	[EventNames.GroupsListCreateGroupClicked] = {
		context = "myGroups",
		eventType = "groupPageClickEvent",
		additionalInfo = { clickTargetType = "createGroup" }
	},
	[EventNames.GroupsListPageExposure] = {
		context = "myGroups",
		eventType = "groupPageExposureEvent",
		additionalInfo = { exposureType = "myGroups" }
	}
}
