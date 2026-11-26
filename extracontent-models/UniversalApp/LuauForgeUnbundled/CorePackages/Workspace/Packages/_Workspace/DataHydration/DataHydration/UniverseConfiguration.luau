local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseConfiguration/UniverseConfigurationStoreTypes")

return {
	PrivacyType = module.PrivacyType,
	getPrivacyTypeForAudiences = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseConfiguration/getPrivacyTypeForAudiences"),
	createUniverseConfigurationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseConfiguration/createUniverseConfigurationStore"),
	getUniverseConfigurationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/UniverseConfiguration/getUniverseConfigurationStore"),
	UniverseConfigurationStoreTypes = module
}
