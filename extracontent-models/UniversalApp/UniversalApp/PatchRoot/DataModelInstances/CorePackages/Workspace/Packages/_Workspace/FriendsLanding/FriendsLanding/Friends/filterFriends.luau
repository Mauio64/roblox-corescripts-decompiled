local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local PresenceType = dependencies.RoduxPresence.Enums.PresenceType
local llama = dependencies.llama
local t = dependencies.t
local filterToPresence = require(FriendsLanding.Friends.filterToPresence)
local filterStates = require(FriendsLanding.Friends.filterStates)
local getCorrectUserPresence = require(FriendsLanding.Friends.getCorrectUserPresence)

return function(p1, p2) -- line: 10
	-- upvalues: t (copy), llama (copy), filterStates (copy), filterToPresence (copy), getCorrectUserPresence (copy), PresenceType (copy)
	assert(t.table(p1), "friends should be a table")
	assert(t.string(p2), "filter should be a string")

	return llama.List.filter(p1, function(p3) -- line: 14
		-- upvalues: p2 (copy), filterStates (copy), filterToPresence (copy), getCorrectUserPresence (copy), PresenceType (copy), llama (copy)
		if p2 == filterStates.Inactive then
			return p3.isInactiveFriend
		end

		local v12 = filterToPresence(p2)
		local v13 = getCorrectUserPresence(p3) or PresenceType.Offline

		return llama.List.includes(v12, v13)
	end)
end
