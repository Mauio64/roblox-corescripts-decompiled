local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")

local FriendRequestCreated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendRequestCreated")

require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")

local v5 = {}

return function(p2)
	local friendsNetworking = p2.friendsNetworking

	return Rodux.createReducer(v5, {
		[friendsNetworking.GetFriendRequests.Succeeded.name] = function(p3, p4)
			local data = p4.responseBody.data

			local isUnseensById = {}

			for k, v8 in pairs(data) do
				isUnseensById[tostring(v8.id)] = v8.isUnseen
			end

			return (llama.Dictionary.join(p3, isUnseensById))
		end,
		[FriendRequestCreated.name] = function(p3, p4)
			local requesteeId = p4.requesteeId

			return llama.Dictionary.join(p3, { [tostring(requesteeId)] = true })
		end,
		[friendsNetworking.ClearNewFriendRequests.Succeeded.name] = function(p3, p4)
			return v5
		end
	})
end
