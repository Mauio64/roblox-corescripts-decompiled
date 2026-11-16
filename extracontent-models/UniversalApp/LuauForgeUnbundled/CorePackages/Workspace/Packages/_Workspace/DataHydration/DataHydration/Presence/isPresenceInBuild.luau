local LocationType = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/Enums/LocationType")
local PresenceType = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/Enums/PresenceType")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Presence/normalizePresenceRawData")

return function(p2): boolean
	return p2 ~= nil and p2.userPresenceType == PresenceType.Online and p2.locationType == LocationType.Build
end
