local Parent = script:FindFirstAncestor("ApolloLocalState").Parent

require(Parent.ApolloClient)

local Cryo = require(Parent.Cryo)
local mergeListsWithoutDuplicates = require(script.Parent.utils.mergeListsWithoutDuplicates)

return {
	fields = {
		omniFeedItem = {},
		profilesInsightsByUserIds = {
			read = function(_, _, p3) -- line: 12
				local t1 = {}

				for _, v in pairs(p3.args.userIds) do
					local v10 = p3:toReference({
						__typename = "ProfileInsights",
						targetUserId = v
					})

					table.insert(t1, v10)

					if not p3:canRead(v10) then
						return nil
					end
				end

				return t1
			end
		},
		userProfiles = {
			read = function(_, _, p6) -- line: 34
				local t2 = {}

				for _, v16 in p6.args.userIds do
					local v17 = p6:toReference({
						__typename = "UserProfile",
						id = v16
					})

					table.insert(t2, v17)

					if not p6:canRead(v17) then
						return nil
					end
				end

				return t2
			end
		},
		allFriendsByUserId = {
			keyArgs = {
				"userId",
				"sort"
			},
			merge = function(_, p8, p9) -- line: 57
				-- upvalues: mergeListsWithoutDuplicates (copy), Cryo (copy)
				if not p8 then
					return p9
				end

				if p8.nextCursor == p9.curCursor then
					local v21 = mergeListsWithoutDuplicates(p8 and p8.friends, p9 and p9.friends, "__ref")

					return Cryo.Dictionary.join(p9, {
						friends = v21
					})
				end

				return p8
			end
		},
		onlineFriendsByUserId = {
			keyArgs = {
				"userId",
				"sort"
			},
			read = function(_, p11, p12) -- line: 80
				-- upvalues: Cryo (copy)
				if not p11 then
					return p11
				end

				return (Cryo.List.filter(p11, function(p13) -- line: 85
					-- upvalues: p12 (copy)
					local v26 = p12:readField("presence", p13)
					local v27 = p12:readField("userPresenceType", v26)

					return v27 and v27 ~= "Offline"
				end))
			end
		}
	}
}
