local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Profile/hydratePresenceFromProfileMetadata")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Profile/createProfileCTAStore")

return {
	ProfileCTAStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Profile/ProfileCTAStore"),
	hydratePresenceFromProfileMetadata = module
}
