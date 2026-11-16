local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local presenceType = dependencies.RoduxPresence.Enums.PresenceType
local filterStates = require(FriendsLanding.Friends.filterStates)

return function(p)
	if p == filterStates.InExperience then
		return { presenceType.InGame, presenceType.InStudio }
	end

	if p == filterStates.Offline then
		return { presenceType.Offline }
	end

	if p == filterStates.Online then
		return { presenceType.Online, presenceType.InStudio, presenceType.InGame }
	end

	return { presenceType.Online, presenceType.InStudio, presenceType.InGame, presenceType.Offline }
end
