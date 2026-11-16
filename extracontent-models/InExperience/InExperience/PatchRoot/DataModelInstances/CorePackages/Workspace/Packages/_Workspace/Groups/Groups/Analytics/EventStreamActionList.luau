local parent = script:FindFirstAncestor("Groups").Parent

require(parent.SocialLuaAnalytics)

local EventNames = require(script.Parent.EventNames)

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
