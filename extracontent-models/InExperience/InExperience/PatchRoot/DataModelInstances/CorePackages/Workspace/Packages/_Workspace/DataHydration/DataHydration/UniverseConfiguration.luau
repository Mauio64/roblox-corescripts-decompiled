local UniverseConfigurationStoreTypes = require(script.UniverseConfigurationStoreTypes)

return {
	PrivacyType = UniverseConfigurationStoreTypes.PrivacyType,
	createUniverseConfigurationStore = require(script.createUniverseConfigurationStore),
	getUniverseConfigurationStore = require(script.getUniverseConfigurationStore),
	UniverseConfigurationStoreTypes = UniverseConfigurationStoreTypes
}
