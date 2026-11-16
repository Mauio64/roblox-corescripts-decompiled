local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent
local Rodux = require(parent2.Rodux)
local llama = require(parent2.llama)

local models = parent.Models
local Recommendation = require(models.Recommendation)
local actions = parent.Actions
local RecommendationCreated = require(actions.RecommendationCreated)
local FriendshipCreated = require(actions.FriendshipCreated)
local RecommendationDestroyed = require(actions.RecommendationDestroyed)

require(parent.roduxFriendsTypes)

local v = {}

local function fn(p, p2) -- 3 equivalent calls inferred from this helper
	local v2 = p2[p.baseUserId]

	if v2 then
		return (llama.Dictionary.removeKey(v2, p.recommendedUserId))
	end

	return nil
end

local function fn2(p, p2)
	local join = llama.Dictionary.join
	local v2 = {
		[p.userId1] = fn({ baseUserId = p.userId1, recommendedUserId = p.userId2 }, p2) -- inferred equivalent call
	}

	local userId2 = p.userId2
	v2[userId2] = fn({ baseUserId = p.userId2, recommendedUserId = p.userId1 }, p2) -- inferred equivalent call
	return join(p2, v2)
end

local function fn3(p, p2) -- 1 equivalent call inferred from this helper
	local v2 = p2

	llama.Dictionary.map(p.users, function(p3)
		v2 = fn2({ userId1 = p.baseFriendId, userId2 = tostring(p3.id) }, v2)
	end)

	return v2
end

return function(p)
	local friendsNetworking = p.friendsNetworking
	local networkingBlocking = p.networkingBlocking

	return Rodux.createReducer(v, {
		[RecommendationCreated.name] = function(p2, p3)
			local baseUserId = tostring(p3.payload.baseUserId)
			local id = tostring(p3.payload.recommendedUser.id)

			local v2 = p2[baseUserId] or {}

			return llama.Dictionary.join(p2, {
				[baseUserId] = llama.Dictionary.join(v2, {
					[id] = Recommendation.format(p3.payload.recommendedUser)
				})
			})
		end,
		[RecommendationDestroyed.name] = function(p2, p3)
			return llama.Dictionary.join(p2, { [p3.payload.baseUserId] = fn(p3.payload, p2) }) -- inferred equivalent call
		end,
		[friendsNetworking.GetFriendRecommendationsFromUserId.Succeeded.name] = function(p2, p3)
			local users = tostring(p3.namedIds.users)
			local data = p3.responseBody.data

			local mapped = llama.Dictionary.map(data, function(data2, _)
				local id

				if data2.contextType == "Contacts" then
					id = data2.contactId
				else
					id = tostring(data2.id)
				end

				return Recommendation.format({
					id = id,
					contactId = data2.contactId,
					mutualFriendsList = data2.mutualFriendsList,
					rank = data2.rank,
					contextType = data2.contextType,
					thumbnailEntities = data2.thumbnailEntities,
					displayName = data2.displayName
				}), id
			end)

			local v2 = p2[users] or {}

			return llama.Dictionary.join(p2, {
				[users] = llama.Dictionary.join(v2, mapped)
			})
		end,
		[FriendshipCreated.name] = function(p2, p3)
			return fn2(p3.payload, p2)
		end,
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p2, p3)
			return fn3({ baseFriendId = tostring(p3.namedIds.users), users = p3.responseBody.data }, p2) -- inferred equivalent call
		end,
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(p2, p3)
			local userId = tostring(p3.ids[1])
			return fn2({
				userId1 = tostring(p3.additionalData.currentUserId),
				userId2 = userId
			}, p2)
		end,
		[networkingBlocking.BlockUserById.Succeeded.name] = function(p2, p3)
			return fn2(
				{
					userId1 = tostring(p3.additionalData.currentUserId),
					userId2 = tostring(p3.namedIds.users)
				},
				p2
			)
		end
	})
end
