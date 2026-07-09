local LegacyFriendsRodux = script:FindFirstAncestor("LegacyFriendsRodux")
local LegacyFriendsRoduxParent = LegacyFriendsRodux.Parent
local UsersGetFriendCount = require(LegacyFriendsRodux.Requests).UsersGetFriendCount
local SetFriendCount = require(LegacyFriendsRodux.Actions).SetFriendCount
local isNewFriendsEndpointsEnabled = require(LegacyFriendsRoduxParent.SharedFlags).isNewFriendsEndpointsEnabled

return function(p1) -- line: 9
	-- upvalues: UsersGetFriendCount (copy), isNewFriendsEndpointsEnabled (copy), SetFriendCount (copy)
	return function(p2) -- line: 10
		-- upvalues: UsersGetFriendCount (copy), p1 (copy), isNewFriendsEndpointsEnabled (copy), SetFriendCount (copy)
		return UsersGetFriendCount(p1):andThen(function(p3) -- line: 11
			-- upvalues: isNewFriendsEndpointsEnabled (copy), p2 (copy), SetFriendCount (copy)
			local responseBody = p3.responseBody

			if isNewFriendsEndpointsEnabled() then
				if responseBody.count then
					p2:dispatch(SetFriendCount(responseBody.count))
				end
			elseif responseBody.success and responseBody.count then
				p2:dispatch(SetFriendCount(responseBody.count))
			end

			return responseBody.count
		end)
	end
end
