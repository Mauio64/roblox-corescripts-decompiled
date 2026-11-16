local hydratePresenceFromProfileMetadata = require(script.hydratePresenceFromProfileMetadata)
require(script.createProfileCTAStore)

return {
	ProfileCTAStore = require(script.ProfileCTAStore),
	hydratePresenceFromProfileMetadata = hydratePresenceFromProfileMetadata
}
