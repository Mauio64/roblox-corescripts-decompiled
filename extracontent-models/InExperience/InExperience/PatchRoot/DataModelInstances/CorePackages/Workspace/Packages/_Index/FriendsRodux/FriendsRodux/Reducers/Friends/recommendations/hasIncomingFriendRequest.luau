local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local llama = require(ParentParentParent.llama)
local Actions = ParentParent.Actions
local RecommendationCreated = require(Actions.RecommendationCreated)
local FriendRequestDeclined = require(Actions.FriendRequestDeclined)

require(ParentParent.roduxFriendsTypes)

local t1 = {}

return function(p1) -- line: 16
	-- upvalues: Rodux (copy), t1 (copy), RecommendationCreated (copy), llama (copy), FriendRequestDeclined (copy)
	local friendsNetworking = p1.friendsNetworking

	return Rodux.createReducer(t1, {
		[RecommendationCreated.name] = function(p2, p3) -- line: 20
			-- upvalues: llama (copy)
			local recommendedUser = p3.payload.recommendedUser
			local str = tostring(recommendedUser.id)
			local v15 = not not recommendedUser.hasIncomingFriendRequest

			return llama.Dictionary.join(p2, {
				[str] = v15
			})
		end,
		[friendsNetworking.GetFriendRecommendationsFromUserId.Succeeded.name] = function(p4, p5) -- line: 32
			-- upvalues: llama (copy)
			local v18 = llama.List.filter(p5.responseBody.data, function(p6) -- line: 36
				return p6.contextType ~= "Contacts"
			end, {})
			local v19 = llama.List.reduce(v18, function(p7, p8) -- line: 40
				p7[tostring(p8.id)] = not not p8.friendRequest

				return p7
			end, {})

			return llama.Dictionary.join(p4, v19)
		end,
		[friendsNetworking.DeclineFriendRequestFromUserId.Succeeded.name] = function(p9, p10) -- line: 49
			-- upvalues: llama (copy)
			local ids = p10.ids
			local v23 = llama.List.reduce(ids, function(p11, p12) -- line: 54
				p11[tostring(p12)] = false

				return p11
			end, {})

			return llama.Dictionary.join(p9, v23)
		end,
		[FriendRequestDeclined.name] = function(p13, p14) -- line: 62
			-- upvalues: llama (copy)
			local ids = p14.ids
			local v27 = llama.List.reduce(ids, function(p15, p16) -- line: 67
				p15[tostring(p16)] = false

				return p15
			end, {})

			return llama.Dictionary.join(p13, v27)
		end,
		[friendsNetworking.DeclineAllFriendRequests.Succeeded.name] = function(_) -- line: 75
			-- upvalues: t1 (copy)
			return t1
		end
	})
end
