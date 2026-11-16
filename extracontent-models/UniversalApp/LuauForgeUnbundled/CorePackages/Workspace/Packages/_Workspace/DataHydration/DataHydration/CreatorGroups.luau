local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorGroups/CreatorGroupsStoreTypes")

return {
	createCreatorGroupsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorGroups/createCreatorGroupsStore"),
	getCreatorGroupsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorGroups/getCreatorGroupsStore"),
	CreatorGroupsStoreTypes = module
}
