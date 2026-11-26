local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/createPresenceStore")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/isPresenceInBuild")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/normalizePresenceRawData")

return {
	PresenceStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/PresenceStore"),
	PresenceEnums = Enums,
	isPresenceInBuild = module2,
	normalizePresenceRawData = module3
}
