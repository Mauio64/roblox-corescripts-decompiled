local UniverseActivationStoreTypes = require(script.UniverseActivationStoreTypes)

return {
	Audience = UniverseActivationStoreTypes.Audience,
	createUniverseActivationStore = require(script.createUniverseActivationStore),
	getUniverseActivationStore = require(script.getUniverseActivationStore),
	UniverseActivationStoreTypes = UniverseActivationStoreTypes
}
