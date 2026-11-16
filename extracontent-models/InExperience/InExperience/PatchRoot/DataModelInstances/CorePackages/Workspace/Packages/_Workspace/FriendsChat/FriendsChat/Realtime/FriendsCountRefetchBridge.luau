local parent = script:FindFirstAncestor("FriendsChat").Parent

local RealtimeDelivery = require(parent.RealtimeDelivery)
local DataHydration = require(parent.DataHydration)

local getLocalUserId = require(script.Parent.Parent.Utils.getLocalUserId)
local FriendshipNotifications = require(script.Parent.FriendshipNotifications)

local function FriendsCountRefetchBridge(): nil
	RealtimeDelivery.useRealtimeNamespace(FriendshipNotifications.Namespace, function(p)
		if
			p == nil
			or p.Type ~= FriendshipNotifications.EventType.Created
			and p.Type ~= FriendshipNotifications.EventType.Destroyed
		then
			return
		end

		local localUserId = getLocalUserId()

		if localUserId == nil then
			return
		end

		DataHydration.Friends.FriendsStore.get().RefreshFriendsCountByUserId((tostring(localUserId)))
	end, {})

	return nil
end

return FriendsCountRefetchBridge
