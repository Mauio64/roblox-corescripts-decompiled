local ParentParent = script.Parent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Rodux = require(ParentParentParent.Rodux)
local llama = require(ParentParentParent.llama)
local Models = ParentParent.Models
local Recommendation = require(Models.Recommendation)
local Actions = ParentParent.Actions
local RecommendationCreated = require(Actions.RecommendationCreated)
local FriendshipCreated = require(Actions.FriendshipCreated)
local RecommendationDestroyed = require(Actions.RecommendationDestroyed)

require(ParentParent.roduxFriendsTypes)

local t1 = {}

local function v12(p1, p2) -- line: 27
	-- upvalues: llama (copy)
	local join = llama.Dictionary.join
	local t2 = {}
	local userId1 = p1.userId1
	local t3 = {
		baseUserId = p1.userId1,
		recommendedUserId = p1.userId2
	}
	local v22 = p2[t3.baseUserId]

	t2[userId1] = if not v22 then nil else llama.Dictionary.removeKey(v22, t3.recommendedUserId)

	local userId2 = p1.userId2
	local t4 = {
		baseUserId = p1.userId2,
		recommendedUserId = p1.userId1
	}
	local v25 = p2[t4.baseUserId]

	t2[userId2] = if not v25 then nil else llama.Dictionary.removeKey(v25, t4.recommendedUserId)

	return join(p2, t2)
end

return function(p3) -- line: 53
	-- upvalues: Rodux (copy), t1 (copy), RecommendationCreated (copy), llama (copy), Recommendation (copy), RecommendationDestroyed (copy), FriendshipCreated (copy), v12 (copy)
	local friendsNetworking = p3.friendsNetworking
	local networkingBlocking = p3.networkingBlocking

	return Rodux.createReducer(t1, {
		[RecommendationCreated.name] = function(p4, p5) -- line: 58
			-- upvalues: llama (copy), Recommendation (copy)
			local str = tostring(p5.payload.baseUserId)
			local str2 = tostring(p5.payload.recommendedUser.id)
			local v37 = p4[str] or {}

			return llama.Dictionary.join(p4, {
				[str] = llama.Dictionary.join(v37, {
					[str2] = Recommendation.format(p5.payload.recommendedUser)
				})
			})
		end,
		[RecommendationDestroyed.name] = function(p6, p7) -- line: 75
			-- upvalues: llama (copy)
			local join = llama.Dictionary.join
			local t5 = {}
			local baseUserId = p7.payload.baseUserId
			local payload = p7.payload
			local v44 = p6[payload.baseUserId]

			t5[baseUserId] = if not v44 then nil else llama.Dictionary.removeKey(v44, payload.recommendedUserId)

			return join(p6, t5)
		end,
		[friendsNetworking.GetFriendRecommendationsFromUserId.Succeeded.name] = function(p8, p9) -- line: 84
			-- upvalues: llama (copy), Recommendation (copy)
			local str = tostring(p9.namedIds.users)
			local data = p9.responseBody.data
			local v49 = llama.Dictionary.map(data, function(p10, _) -- line: 91
				-- upvalues: Recommendation (copy)
				local v67 = if p10.contextType ~= "Contacts" then tostring(p10.id) else p10.contactId

				return Recommendation.format({
					id = v67,
					contactId = p10.contactId,
					mutualFriendsList = p10.mutualFriendsList,
					rank = p10.rank,
					contextType = p10.contextType,
					thumbnailEntities = p10.thumbnailEntities,
					displayName = p10.displayName
				}), v67
			end)
			local v50 = p8[str] or {}

			return llama.Dictionary.join(p8, {
				[str] = llama.Dictionary.join(v50, v49)
			})
		end,
		[FriendshipCreated.name] = function(p12, p13) -- line: 113
			-- upvalues: v12 (copy)
			return v12(p13.payload, p12)
		end,
		[friendsNetworking.GetFriendsFromUserId.Succeeded.name] = function(p14, p15) -- line: 120
			-- upvalues: llama (copy), v12 (copy)
			local t6 = {
				baseFriendId = tostring(p15.namedIds.users),
				users = p15.responseBody.data
			}
			local u56 = p14

			llama.Dictionary.map(t6.users, function(p16) -- line: 43
				-- upvalues: u56 (ref), v12 (copy), t6 (copy)
				u56 = v12({
					userId1 = t6.baseFriendId,
					userId2 = tostring(p16.id)
				}, u56)
			end)

			return u56
		end,
		[friendsNetworking.AcceptFriendRequestFromUserId.Succeeded.name] = function(p17, p18) -- line: 130
			-- upvalues: v12 (copy)
			local str = tostring(p18.ids[1])
			local str3 = tostring(p18.additionalData.currentUserId)

			return v12({
				userId1 = str3,
				userId2 = str
			}, p17)
		end,
		[networkingBlocking.BlockUserById.Succeeded.name] = function(p19, p20) -- line: 143
			-- upvalues: v12 (copy)
			local str = tostring(p20.additionalData.currentUserId)
			local str4 = tostring(p20.namedIds.users)

			return v12({
				userId1 = str,
				userId2 = str4
			}, p19)
		end
	})
end
