local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/GamePassConfigTypes")

return {
	createGamePassConfigStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/createGamePassConfigStore"),
	getGamePassConfigStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/getGamePassConfigStore"),
	GamePassConfigTypes = module,
	INCOMPLETE_LIST_CODE = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/incompleteListCode"),
	isManagedPricingEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/GamePassConfig/isManagedPricingEnabled")
}
