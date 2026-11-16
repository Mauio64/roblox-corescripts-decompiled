local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/RoactUtils")

local configureRoduxFriends = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Networking/configureRoduxFriends")

local fFlagMigrateFriendshipStatusesRemainingActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/SharedFlags").FFlagMigrateFriendshipStatusesRemainingActions

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/DataHydration").Friends.FriendsStore.get()

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

return function()
	local v6 = useDispatch()

	return function(p2, p3)
		if fFlagMigrateFriendshipStatusesRemainingActions then
			return v5.AcceptFriendRequest(p3)
		end

		return v6(configureRoduxFriends.AcceptFriendRequestFromUserId.API({
			currentUserId = p2,
			targetUserId = p3
		}))
	end
end
