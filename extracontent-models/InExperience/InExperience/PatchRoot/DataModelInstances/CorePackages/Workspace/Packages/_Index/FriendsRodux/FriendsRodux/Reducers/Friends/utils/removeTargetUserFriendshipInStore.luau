local parent = script:FindFirstAncestor("FriendsRodux").Parent
local llama = require(parent.llama)
local removeUser = require(script.Parent.removeUser)

return function(p, p2)
	local currentUserId = tostring(p2.additionalData.currentUserId)
	local users = tostring(p2.namedIds.users)

	local joined = llama.Dictionary.join(p, {
		[currentUserId] = removeUser(p[currentUserId], users),
		[users] = removeUser(p[users], currentUserId)
	})

	joined[users] = nil

	return joined
end
