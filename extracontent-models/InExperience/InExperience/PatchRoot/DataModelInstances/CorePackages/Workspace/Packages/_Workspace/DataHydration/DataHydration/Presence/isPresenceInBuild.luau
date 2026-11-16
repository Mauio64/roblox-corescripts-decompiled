local LocationType = require(script.Parent.Enums.LocationType)
local PresenceType = require(script.Parent.Enums.PresenceType)
require(script.Parent.normalizePresenceRawData)

return function(p): boolean
	return p ~= nil and p.userPresenceType == PresenceType.Online and p.locationType == LocationType.Build
end
