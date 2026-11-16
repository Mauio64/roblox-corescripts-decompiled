local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")
local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")

local RecommendationCreated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/RecommendationCreated")
local FriendRequestDeclined = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendRequestDeclined")

require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

local v5 = {}

return function(p2)
	local friendsNetworking = p2.friendsNetworking

	return Rodux.createReducer(v5, {
		[RecommendationCreated.name] = function(p3, p4)
			local recommendedUser = p4.payload.recommendedUser
			local id = tostring(recommendedUser.id)
			local v8 = recommendedUser.hasIncomingFriendRequest and true or false

			return llama.Dictionary.join(p3, { [id] = v8 })
		end,
		[friendsNetworking.GetFriendRecommendationsFromUserId.Succeeded.name] = function(p3, p4)
			local filtered = llama.List.filter(p4.responseBody.data, function(p5): boolean
				return p5.contextType ~= "Contacts"
			end, {})

			local reduced = llama.List.reduce(filtered, function(p5, p6)
				p5[tostring(p6.id)] = p6.friendRequest and true or false
				return p5
			end, {})

			return llama.Dictionary.join(p3, reduced)
		end,
		[friendsNetworking.DeclineFriendRequestFromUserId.Succeeded.name] = function(p3, p4)
			local ids = p4.ids
			local reduced = llama.List.reduce(ids, function(p5, p6)
				p5[tostring(p6)] = false
				return p5
			end, {})

			return llama.Dictionary.join(p3, reduced)
		end,
		[FriendRequestDeclined.name] = function(p3, p4)
			local ids = p4.ids
			local reduced = llama.List.reduce(ids, function(p5, p6)
				p5[tostring(p6)] = false
				return p5
			end, {})

			return llama.Dictionary.join(p3, reduced)
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function(p3)
			return v5
		end
	})
end
