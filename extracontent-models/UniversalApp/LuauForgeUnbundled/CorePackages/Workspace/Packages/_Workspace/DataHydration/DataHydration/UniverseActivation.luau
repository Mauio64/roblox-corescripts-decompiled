local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseActivation/UniverseActivationStoreTypes")

return {
	Audience = module.Audience,
	createUniverseActivationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseActivation/createUniverseActivationStore"),
	getUniverseActivationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseActivation/getUniverseActivationStore"),
	UniverseActivationStoreTypes = module
}
