local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local PresenceTypes = require(ParentParent.Analytics.Enums).PresenceTypes
local PresenceType = dependencies.RoduxPresence.Enums.PresenceType
local t1 = {
	[PresenceType.InGame] = PresenceTypes.InGame.rawValue(),
	[PresenceType.InStudio] = PresenceTypes.InStudio.rawValue(),
	[PresenceType.Offline] = PresenceTypes.Offline.rawValue(),
	[PresenceType.Online] = PresenceTypes.Online.rawValue()
}

return function(p1) -- line: 15
	-- upvalues: t1 (copy)
	return t1[p1]
end
