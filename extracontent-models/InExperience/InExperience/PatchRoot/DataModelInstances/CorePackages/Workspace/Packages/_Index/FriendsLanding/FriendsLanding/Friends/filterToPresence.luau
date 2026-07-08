local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local PresenceType = require(FriendsLanding.dependencies).RoduxPresence.Enums.PresenceType
local filterStates = require(FriendsLanding.Friends.filterStates)

return function(p1) -- line: 6
	-- upvalues: filterStates (copy), PresenceType (copy)
	if p1 == filterStates.InExperience then
		return {
			PresenceType.InGame,
			PresenceType.InStudio
		}
	end

	if p1 == filterStates.Offline then
		return { PresenceType.Offline }
	end

	if p1 == filterStates.Online then
		return {
			PresenceType.Online,
			PresenceType.InStudio,
			PresenceType.InGame
		}
	end

	return {
		PresenceType.Online,
		PresenceType.InStudio,
		PresenceType.InGame,
		PresenceType.Offline
	}
end
