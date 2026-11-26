local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseSearch/UniverseSearchStoreTypes")

return {
	createUniverseSearchStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseSearch/createUniverseSearchStore"),
	getUniverseSearchStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseSearch/getUniverseSearchStore"),
	UniverseSearchStoreTypes = module
}
