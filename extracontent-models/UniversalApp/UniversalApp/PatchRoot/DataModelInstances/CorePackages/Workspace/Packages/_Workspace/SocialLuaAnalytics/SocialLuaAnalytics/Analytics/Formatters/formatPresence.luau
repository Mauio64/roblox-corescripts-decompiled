local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local PresenceTypes = require(ParentParent.Analytics.Enums).PresenceTypes
local PresenceType = dependencies.RoduxPresence.Enums.PresenceType
local t1 = {
	[PresenceType.InGame] = PresenceTypes.InGame,
	[PresenceType.InStudio] = PresenceTypes.InStudio,
	[PresenceType.Offline] = PresenceTypes.Offline,
	[PresenceType.Online] = PresenceTypes.Online
}

return function(p1) -- line: 15
	-- upvalues: PresenceTypes (copy), t1 (copy)
	if not p1 then
		return nil
	end

	if type(p1) == "string" and p1 ~= "" then
		return PresenceTypes[p1]
	end

	return t1[p1]
end
