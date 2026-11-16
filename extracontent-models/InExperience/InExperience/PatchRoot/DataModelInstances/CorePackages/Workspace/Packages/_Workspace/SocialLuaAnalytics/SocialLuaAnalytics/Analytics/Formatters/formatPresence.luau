local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local Enums = require(parent.Analytics.Enums)

local PresenceTypes = Enums.PresenceTypes
local presenceType = dependencies.RoduxPresence.Enums.PresenceType

local v = {
	[presenceType.InGame] = PresenceTypes.InGame,
	[presenceType.InStudio] = PresenceTypes.InStudio,
	[presenceType.Offline] = PresenceTypes.Offline,
	[presenceType.Online] = PresenceTypes.Online
}

return function(value)
	if not value then
		return nil
	end

	if type(value) == "string" and value ~= "" then
		return PresenceTypes[value]
	end

	return v[value]
end
