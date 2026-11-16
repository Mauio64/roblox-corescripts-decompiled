local usersGetFriendCount = require("@game/CorePackages/Workspace/Packages/_Workspace/LegacyFriendsRodux/LegacyFriendsRodux/Requests").UsersGetFriendCount
local setFriendCount = require("@game/CorePackages/Workspace/Packages/_Workspace/LegacyFriendsRodux/LegacyFriendsRodux/Actions").SetFriendCount

local isNewFriendsEndpointsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/LegacyFriendsRodux/SharedFlags").isNewFriendsEndpointsEnabled
local fFlagRemoveUnusedFriendCountRoduxSlice = require("@game/CorePackages/Workspace/Packages/_Workspace/LegacyFriendsRodux/SharedFlags").FFlagRemoveUnusedFriendCountRoduxSlice

return function(p2)
	return function(object)
		return usersGetFriendCount(p2):andThen(function(p3)
			local responseBody = p3.responseBody

			if fFlagRemoveUnusedFriendCountRoduxSlice then
				return responseBody.count
			end

			if isNewFriendsEndpointsEnabled() then
				if responseBody.count then
					object:dispatch(setFriendCount(responseBody.count))
				end
			elseif responseBody.success and responseBody.count then
				object:dispatch(setFriendCount(responseBody.count))
			end

			return responseBody.count
		end)
	end
end
