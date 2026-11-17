local parent = script:FindFirstAncestor("ApolloFriends").Parent

local Cryo = require(parent.Cryo)
local ApolloLocalState = require(parent.ApolloLocalState)
local utils = ApolloLocalState.typePolicies.utils

local createFriendInCache = require(script.Parent.createFriendInCache)

local function addFriendToFriendsByUserIdCache(p, data)
	local friendInCache = createFriendInCache(p, {
		userId = data.userId,
		targetUserId = data.targetUserId,
		hasVerifiedBadge = data.hasVerifiedBadge
	})

	p.cache:modify({
		id = p.cache:identify({ __typename = "AllFriendsPage" }),
		fields = {
			allFriendsByUserId = function(_, p2, _)
				if p2.targetUserId == data.targetUserId then
					return (Cryo.Dictionary.join(p2, {
						friends = utils.mergeListsWithoutDuplicates(p2.friends, { friendInCache }, "__ref")
					}))
				end

				return p2
			end
		}
	})
end

return addFriendToFriendsByUserIdCache
