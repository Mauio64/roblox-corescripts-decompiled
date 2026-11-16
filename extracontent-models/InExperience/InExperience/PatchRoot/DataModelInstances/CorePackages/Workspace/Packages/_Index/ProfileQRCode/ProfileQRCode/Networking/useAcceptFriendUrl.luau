local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent

local RoactUtils = require(parent.RoactUtils)

local configureRoduxFriends = require(ProfileQRCode.Networking.configureRoduxFriends)

local SharedFlags = require(parent.SharedFlags)
local FFlagMigrateFriendshipStatusesRemainingActions = SharedFlags.FFlagMigrateFriendshipStatusesRemainingActions

local DataHydration = require(parent.DataHydration)
local v = DataHydration.Friends.FriendsStore.get()

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

return function()
	local v2 = useDispatch()

	return function(currentUserId: string, targetUserId: string)
		if FFlagMigrateFriendshipStatusesRemainingActions then
			return v.AcceptFriendRequest(targetUserId)
		end

		return v2(configureRoduxFriends.AcceptFriendRequestFromUserId.API({
			currentUserId = currentUserId,
			targetUserId = targetUserId
		}))
	end
end
