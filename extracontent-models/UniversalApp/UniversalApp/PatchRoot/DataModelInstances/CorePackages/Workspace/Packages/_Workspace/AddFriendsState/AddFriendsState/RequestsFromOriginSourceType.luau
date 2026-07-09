local AddFriendsState = script:FindFirstAncestor("AddFriendsState")
local AddFriendsStateParent = AddFriendsState.Parent
local Rodux = require(AddFriendsStateParent.Rodux)
local getDeepValue = require(AddFriendsStateParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local Cryo = require(AddFriendsStateParent.Cryo)
local FriendsNetworking = require(AddFriendsState.Networking.FriendsNetworking)

return Rodux.createReducer({}, {
	[FriendsNetworking.GetFriendRequests.Succeeded.name] = function(p1, p2) -- line: 16
		-- upvalues: Cryo (copy), getDeepValue (copy)
		local data = p2.responseBody.data
		local v10 = Cryo.List.foldLeft(data, function(p3, p4) -- line: 19
			-- upvalues: getDeepValue (copy)
			local v13 = getDeepValue(p4, "friendRequest.originSourceType")

			p3[tostring(p4.id)] = v13

			return p3
		end, {})

		return (Cryo.Dictionary.join(p1 or {}, v10))
	end
})
