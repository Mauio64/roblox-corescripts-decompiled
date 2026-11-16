local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local presenceType = dependencies.RoduxPresence.Enums.PresenceType
local llama = dependencies.llama
local t = dependencies.t
local filterToPresence = require(FriendsLanding.Friends.filterToPresence)
local filterStates = require(FriendsLanding.Friends.filterStates)
local getCorrectUserPresence = require(FriendsLanding.Friends.getCorrectUserPresence)

return function(p, p2)
	assert(t.table(p), "friends should be a table")
	assert(t.string(p2), "filter should be a string")

	return llama.List.filter(p, function(p3)
		if p2 == filterStates.Inactive then
			return p3.isInactiveFriend
		end

		local v = filterToPresence(p2)
		local v2 = getCorrectUserPresence(p3) or presenceType.Offline
		return llama.List.includes(v, v2)
	end)
end
