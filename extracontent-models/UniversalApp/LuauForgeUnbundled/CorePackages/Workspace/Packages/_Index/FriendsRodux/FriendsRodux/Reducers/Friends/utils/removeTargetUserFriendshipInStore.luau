local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")
local removeUser = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Reducers/Friends/utils/removeUser")

return function(p2, p3)
	local currentUserId = tostring(p3.additionalData.currentUserId)
	local users = tostring(p3.namedIds.users)

	local joined = llama.Dictionary.join(p2, {
		[currentUserId] = removeUser(p2[currentUserId], users),
		[users] = removeUser(p2[users], currentUserId)
	})

	joined[users] = nil

	return joined
end
