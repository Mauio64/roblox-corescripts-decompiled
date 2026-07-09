local UserSearch = script:FindFirstAncestor("UserSearch")

require(UserSearch.Common.LocalTypes)

local PresenceType = require(UserSearch.Rodux.RoduxPresence).Enums.PresenceType

return {
	isUserOnline = function(p1) -- line: 7
		-- upvalues: PresenceType (copy)
		return p1 == PresenceType.Online or (p1 == PresenceType.InStudio or p1 == PresenceType.InGame)
	end,
	isUserInGame = function(p2) -- line: 15
		-- upvalues: PresenceType (copy)
		return not not p2 and (not not p2.universeId and (p2.userPresenceType == PresenceType.InGame or false))
	end
}
