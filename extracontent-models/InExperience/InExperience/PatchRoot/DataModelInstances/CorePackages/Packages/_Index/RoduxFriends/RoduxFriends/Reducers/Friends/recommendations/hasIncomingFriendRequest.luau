local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)
local llama = require(parent2.llama)

local actions = parent.Actions
local RecommendationCreated = require(actions.RecommendationCreated)
local FriendRequestDeclined = require(actions.FriendRequestDeclined)

require(parent.roduxFriendsTypes)

local v = {}

return function(p)
	local friendsNetworking = p.friendsNetworking

	return Rodux.createReducer(v, {
		[RecommendationCreated.name] = function(p2, p3)
			local recommendedUser = p3.payload.recommendedUser
			local id = tostring(recommendedUser.id)
			local v2 = recommendedUser.hasIncomingFriendRequest and true or false

			return llama.Dictionary.join(p2, { [id] = v2 })
		end,
		[friendsNetworking.GetFriendRecommendationsFromUserId.Succeeded.name] = function(p2, p3)
			local filtered = llama.List.filter(p3.responseBody.data, function(p4): boolean
				return p4.contextType ~= "Contacts"
			end, {})

			local reduced = llama.List.reduce(filtered, function(p4, p5)
				p4[tostring(p5.id)] = p5.friendRequest and true or false
				return p4
			end, {})

			return llama.Dictionary.join(p2, reduced)
		end,
		[friendsNetworking.DeclineFriendRequestFromUserId.Succeeded.name] = function(p2, p3)
			local ids = p3.ids
			local reduced = llama.List.reduce(ids, function(p4, p5)
				p4[tostring(p5)] = false
				return p4
			end, {})

			return llama.Dictionary.join(p2, reduced)
		end,
		[FriendRequestDeclined.name] = function(p2, p3)
			local ids = p3.ids
			local reduced = llama.List.reduce(ids, function(p4, p5)
				p4[tostring(p5)] = false
				return p4
			end, {})

			return llama.Dictionary.join(p2, reduced)
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function(_)
			return v
		end
	})
end
