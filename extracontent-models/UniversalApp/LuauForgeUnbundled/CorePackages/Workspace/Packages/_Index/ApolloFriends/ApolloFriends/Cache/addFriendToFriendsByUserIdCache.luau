local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloFriends/Cryo")
local utils = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloFriends/ApolloLocalState").typePolicies.utils

local createFriendInCache = require("@game/CorePackages/Workspace/Packages/_Index/ApolloFriends/ApolloFriends/Cache/createFriendInCache")

local function addFriendToFriendsByUserIdCache(p2, data)
	local v5 = createFriendInCache(p2, {
		userId = data.userId,
		targetUserId = data.targetUserId,
		hasVerifiedBadge = data.hasVerifiedBadge
	})

	p2.cache:modify({
		id = p2.cache:identify({ __typename = "AllFriendsPage" }),
		fields = {
			allFriendsByUserId = function(p3, p4, p5)
				if p4.targetUserId == data.targetUserId then
					return (Cryo.Dictionary.join(p4, {
						friends = utils.mergeListsWithoutDuplicates(p4.friends, { v5 }, "__ref")
					}))
				end

				return p4
			end
		}
	})
end

return addFriendToFriendsByUserIdCache
