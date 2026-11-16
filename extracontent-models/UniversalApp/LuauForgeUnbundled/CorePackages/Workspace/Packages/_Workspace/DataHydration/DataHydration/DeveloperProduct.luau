local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DeveloperProduct/DeveloperProductStoreTypes")

return {
	createDeveloperProductStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DeveloperProduct/createDeveloperProductStore"),
	getDeveloperProductStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DeveloperProduct/getDeveloperProductStore"),
	DeveloperProductStoreTypes = module
}
