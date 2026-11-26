require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloLocalState/ApolloClient")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloLocalState/Cryo")

local mergeListsWithoutDuplicates = require("@game/CorePackages/Workspace/Packages/_Index/ApolloLocalState/ApolloLocalState/typePolicies/utils/mergeListsWithoutDuplicates")

return {
	fields = {
		omniFeedItem = {},
		profilesInsightsByUserIds = {
			read = function(p2, p3, object)
				local result = {}

				for k, userId in pairs(object.args.userIds) do
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
			read = function(p2, p3, object)
				local result = {}

				for k, userId in object.args.userIds do
					local reference = object:toReference({
						__typename = "UserProfile",
						id = userId
					})

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
			merge = function(p2, p3, p4)
				if not p3 then
					return p4
				end

				if p3.nextCursor ~= p4.curCursor then
					return p3
				end

				local v5 = mergeListsWithoutDuplicates(p3 and p3.friends, p4 and p4.friends, "__ref")

				return Cryo.Dictionary.join(p4, { friends = v5 })
			end
		},
		onlineFriendsByUserId = {
			keyArgs = { "userId", "sort" },
			read = function(p2, p3, object)
				if p3 then
					return (Cryo.List.filter(p3, function(p4)
						local field2 = object:readField(
							"userPresenceType",
							(object:readField("presence", p4))
						)

						return field2 and field2 ~= "Offline"
					end))
				end

				return p3
			end
		}
	}
}
