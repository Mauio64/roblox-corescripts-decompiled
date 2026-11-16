local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

require(UserSearch.Common.LocalTypes)
local RoduxPresence = require(UserSearch.Rodux.RoduxPresence)
local PresenceType = RoduxPresence.Enums.PresenceType
local FFlagUserSearchPresenceStoreMigration = require(UserSearch.Flags.FFlagUserSearchPresenceStoreMigration)
local presenceType

if FFlagUserSearchPresenceStoreMigration then
	local DataHydration = require(parent.DataHydration)
	presenceType = DataHydration.Presence.PresenceEnums.PresenceType
else
	presenceType = nil
end

local PresenceHelpers = {}

function PresenceHelpers.isUserOnline(p): boolean
	if FFlagUserSearchPresenceStoreMigration then
		return p == presenceType.Online or p == presenceType.InStudio or p == presenceType.InGame
	end

	return p == PresenceType.Online or p == PresenceType.InStudio or p == PresenceType.InGame
end

function PresenceHelpers.isUserInGame(p): boolean
	if p and p.universeId then
		if FFlagUserSearchPresenceStoreMigration then
			return p.userPresenceType == presenceType.InGame
		end

		return p.userPresenceType == PresenceType.InGame
	end

	return false
end

return PresenceHelpers
