local parent = script:FindFirstAncestor("ApolloLocalState").Parent

require(parent.ApolloClient)
local Cryo = require(parent.Cryo)

local mergeListsWithoutDuplicates = require(script.Parent.utils.mergeListsWithoutDuplicates)

return {
	fields = {
		omniFeedItem = {},
		profilesInsightsByUserIds = {
			read = function(_, _, object)
				local result = {}

				for _, userId in pairs(object.args.userIds) do
					local reference = object:toReference({
						__typename = "ProfileInsights",
						targetUserId = userId
					})

					table.insert(result, reference)

					if not object:canRead(reference) then
						return nil
					end
				end

				return result
			end
		},
		userProfiles = {
			read = function(_, _, object)
				local result = {}

				for _, userId in object.args.userIds do
					local reference = object:toReference({ __typename = "UserProfile", id = userId })

					table.insert(result, reference)

					if not object:canRead(reference) then
						return nil
					end
				end

				return result
			end
		},
		allFriendsByUserId = {
			keyArgs = { "userId", "sort" },
			merge = function(_, p, p2)
				if not p then
					return p2
				end

				if p.nextCursor ~= p2.curCursor then
					return p
				end

				local friends = mergeListsWithoutDuplicates(p and p.friends, p2 and p2.friends, "__ref")

				return Cryo.Dictionary.join(p2, { friends = friends })
			end
		},
		onlineFriendsByUserId = {
			keyArgs = { "userId", "sort" },
			read = function(_, p, object)
				if p then
					return (Cryo.List.filter(p, function(p2)
						local field = object:readField("userPresenceType", (object:readField("presence", p2)))

						return field and field ~= "Offline"
					end))
				end

				return p
			end
		}
	}
}
