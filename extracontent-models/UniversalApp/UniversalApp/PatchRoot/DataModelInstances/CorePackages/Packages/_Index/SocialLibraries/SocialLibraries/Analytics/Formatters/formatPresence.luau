local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local Enums = require(parent.Analytics.Enums)
local PresenceTypes = Enums.PresenceTypes
local presenceType = dependencies.RoduxPresence.Enums.PresenceType

local v = {
	[presenceType.InGame] = PresenceTypes.InGame.rawValue(),
	[presenceType.InStudio] = PresenceTypes.InStudio.rawValue(),
	[presenceType.Offline] = PresenceTypes.Offline.rawValue(),
	[presenceType.Online] = PresenceTypes.Online.rawValue()
}

return function(p)
	return v[p]
end
