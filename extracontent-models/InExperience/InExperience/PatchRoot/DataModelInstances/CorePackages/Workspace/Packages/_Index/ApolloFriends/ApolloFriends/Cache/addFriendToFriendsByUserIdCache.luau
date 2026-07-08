local Parent = script:FindFirstAncestor("ApolloFriends").Parent
local Cryo = require(Parent.Cryo)
local utils = require(Parent.ApolloLocalState).typePolicies.utils
local createFriendInCache = require(script.Parent.createFriendInCache)

local function addFriendToFriendsByUserIdCache(p1, t1: {[any]: any}) -- line: 16
	-- upvalues: createFriendInCache (copy), Cryo (copy), utils (copy)
	local v8 = createFriendInCache(p1, {
		userId = t1.userId,
		targetUserId = t1.targetUserId,
		hasVerifiedBadge = t1.hasVerifiedBadge
	})

	p1.cache:modify({
		id = p1.cache:identify({
			__typename = "AllFriendsPage"
		}),
		fields = {
			allFriendsByUserId = function(_, p3, _) -- line: 28
				-- upvalues: t1 (copy), Cryo (copy), utils (copy), v8 (copy)
				if p3.targetUserId == t1.targetUserId then
					return (Cryo.Dictionary.join(p3, {
						friends = utils.mergeListsWithoutDuplicates(p3.friends, { v8 }, "__ref")
					}))
				end

				return p3
			end
		}
	})
end

return addFriendToFriendsByUserIdCache
