local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/Rodux")
local llama = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsRodux/llama")

local Recommendation = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Models/Recommendation")

local RecommendationCreated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/RecommendationCreated")
local FriendshipCreated = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/FriendshipCreated")
local RecommendationDestroyed = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Actions/RecommendationDestroyed")

require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/roduxFriendsTypes")

local v5 = {}

local function fn(p2, p3)
	local join = llama.Dictionary.join
	local userId1 = p2.userId1
	local v7 = { baseUserId = p2.userId1, recommendedUserId = p2.userId2 }
	local v8 = p3[v7.baseUserId]

	local v9 = if v8 then llama.Dictionary.removeKey(v8, v7.recommendedUserId) else nil

	local v6 = { [userId1] = v9 }

	local userId2 = p2.userId2
	local v10 = { baseUserId = p2.userId2, recommendedUserId = p2.userId1 }
	local v11 = p3[v10.baseUserId]

	local v12 = if v11 then llama.Dictionary.removeKey(v11, v10.recommendedUserId) else nil

	v6[userId2] = v12
	return join(p3, v6)
end

return function(p2)
	local friendsNetworking = p2.friendsNetworking
	local networkingBlocking = p2.networkingBlocking

	return Rodux.createReducer(v5, {
		[RecommendationCreated.name] = function(p3, p4)
			local baseUserId = tostring(p4.payload.baseUserId)
			local id = tostring(p4.payload.recommendedUser.id)

			local v8 = p3[baseUserId] or {}

			return llama.Dictionary.join(p3, {
				[baseUserId] = llama.Dictionary.join(v8, {
					[id] = Recommendation.format(p4.payload.recommendedUser)
				})
			})
		end,
		[RecommendationDestroyed.name] = function(p3, p4)
			local join = llama.Dictionary.join
			local baseUserId = p4.payload.baseUserId
			local payload = p4.payload
			local v9 = p3[payload.baseUserId]

			local v10 = if v9 then llama.Dictionary.removeKey(v9, payload.recommendedUserId) else nil

			return join(p3, { [baseUserId] = v10 })
		end,
		[friendsNetworking.GetFriendRecommendationsFromUserId.Succeeded.name] = function(p3, p4)
			local users = tostring(p4.namedIds.users)
			local data = p4.responseBody.data

			local mapped = llama.Dictionary.map(data, function(data2, p5)
				local v8 = if data2.contextType == "Contacts" then data2.contactId else tostring(data2.id)

				return Recommendation.format({
					id = v8,
					contactId = data2.contactId,
					mutualFriendsList = data2.mutualFriendsList,
					rank = data2.rank,
					contextType = data2.contextType,
					thumbnailEntities = data2.thumbnailEntities,
					displayName = data2.displayName
				}), v8
			end)

			local v8 = p3[users] or {}

			return llama.Dictionary.join(p3, {
				[users] = llama.Dictionary.join(v8, mapped)
			})
		end,
		[FriendshipCreated.name] = function(p3, p4)
			return fn(p4.payload, p3)
		end,
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p3, p4)
			local v8 = {
				baseFriendId = tostring(p4.namedIds.users),
				users = p4.responseBody.data
			}
			local v9 = p3

			llama.Dictionary.map(v8.users, function(p5)
				v9 = fn({ userId1 = v8.baseFriendId, userId2 = tostring(p5.id) }, v9)
			end)

			return v9
		end,
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(p3, p4)
			local v8 = tostring(p4.ids[1])
			return fn({
				userId1 = tostring(p4.additionalData.currentUserId),
				userId2 = v8
			}, p3)
		end,
		[networkingBlocking.BlockUserById.Succeeded.name] = function(p3, p4)
			return fn(
				{
					userId1 = tostring(p4.additionalData.currentUserId),
					userId2 = tostring(p4.namedIds.users)
				},
				p3
			)
		end
	})
end
