local LegacyFriendsRodux = script:FindFirstAncestor("LegacyFriendsRodux")
local parent = LegacyFriendsRodux.Parent

local Requests = require(LegacyFriendsRodux.Requests)
local UsersGetFriendCount = Requests.UsersGetFriendCount
local Actions = require(LegacyFriendsRodux.Actions)
local SetFriendCount = Actions.SetFriendCount

local SharedFlags = require(parent.SharedFlags)
local isNewFriendsEndpointsEnabled = SharedFlags.isNewFriendsEndpointsEnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagRemoveUnusedFriendCountRoduxSlice = SharedFlags2.FFlagRemoveUnusedFriendCountRoduxSlice

return function(p)
	return function(object)
		return UsersGetFriendCount(p):andThen(function(p2)
			local responseBody = p2.responseBody

			if FFlagRemoveUnusedFriendCountRoduxSlice then
				return responseBody.count
			end

			if isNewFriendsEndpointsEnabled() then
				if responseBody.count then
					object:dispatch(SetFriendCount(responseBody.count))
				end
			elseif responseBody.success and responseBody.count then
				object:dispatch(SetFriendCount(responseBody.count))
			end

			return responseBody.count
		end)
	end
end
