local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")
local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")

require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

local FriendRequestCreated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendRequestCreated")

local v5 = {}

return function(p2)
	local friendsNetworking = p2.friendsNetworking

	return Rodux.createReducer(v5, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p3, p4)
			local data = p4.responseBody.data

			local contactNamesById = {}

			for k, v8 in pairs(data) do
				contactNamesById[tostring(v8.id)] = v8.friendRequest.contactName
			end

			return llama.Dictionary.join(p3, contactNamesById)
		end,
		[FriendRequestCreated.name] = function(p3, p4)
			local requesteeId = tostring(p4.requesteeId)
			local contactName = p4.contactName

			return llama.Dictionary.join(p3, { [requesteeId] = contactName })
		end
	})
end
