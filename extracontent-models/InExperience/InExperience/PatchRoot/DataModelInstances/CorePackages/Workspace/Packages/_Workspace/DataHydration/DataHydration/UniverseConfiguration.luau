local UniverseConfigurationStoreTypes = require(script.UniverseConfigurationStoreTypes)

return {
	PrivacyType = UniverseConfigurationStoreTypes.PrivacyType,
	getPrivacyTypeForAudiences = require(script.getPrivacyTypeForAudiences),
	createUniverseConfigurationStore = require(script.createUniverseConfigurationStore),
	getUniverseConfigurationStore = require(script.getUniverseConfigurationStore),
	UniverseConfigurationStoreTypes = UniverseConfigurationStoreTypes
}
