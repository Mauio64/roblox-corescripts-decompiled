return {
	GroupsInExperienceApp = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/GroupsInExperienceApp"),
	GroupsList = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/GroupsList"),
	GroupsPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Components/GroupsPage"),
	Common = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common"),
	Networking = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Networking"),
	Contexts = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Contexts"),
	Hooks = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Hooks"),
	Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Navigation"),
	CommunityListRouting = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/CommunityListRouting"),
	getGroupSidebar = function()
		return require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Common/GroupSidebar")
	end
}
