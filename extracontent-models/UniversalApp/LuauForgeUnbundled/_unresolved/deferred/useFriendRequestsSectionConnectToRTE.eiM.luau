local useLocalUserId = require("@luauforge/deferred/efV").useLocalUserId
local useRealtimeNamespace = require("@luauforge/deferred/eiN").useRealtimeNamespace

local module = require("@luauforge/deferred/eiO")
local module2 = require("@luauforge/deferred/eiz")

local friendsRequestsStore = require("@luauforge/deferred/eig").FriendsRequestsStore

local function useFriendRequestsSectionConnectToRTE()
	local v5 = tostring(useLocalUserId())

	useRealtimeNamespace("FriendshipNotifications", function(p2)
		if not p2.EventArgs then
			return
		end

		if module and p2.Type == "FriendshipRequested" and tostring(p2.EventArgs.UserId2) == v5 then
			friendsRequestsStore.get().appendNewUserId((tostring(p2.EventArgs.UserId1)))
		end

		local v6 = tostring(p2.EventArgs.UserId1)
		local userId2 = tostring(p2.EventArgs.UserId2)

		if v5 == v6 then
			v6 = userId2
		end

		if p2.Type == "FriendshipDeclined" then
			friendsRequestsStore.get().removeFriendRequestByUserId(v6)
		elseif p2.Type == "FriendshipCreated" and not module2 then
			friendsRequestsStore.get().removeFriendRequestByUserId(v6)
		end
	end, { v5 })
end

return useFriendRequestsSectionConnectToRTE
